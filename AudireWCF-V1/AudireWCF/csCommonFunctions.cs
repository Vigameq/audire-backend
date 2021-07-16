using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.UI.DataVisualization.Charting;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;


namespace AudireWCF
{
    class csCommonFunctions
    {
        OutputDetail objOutputDetail;

        #region CommonFunctions
        public OutputDetail checkLogin(Parameters param)
        {
            OutputDetail objOutput = new OutputDetail();
            SqlConnection sqlconn = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand sqlcmd = null;
            try
            {
                sqlcmd = new SqlCommand(AudireResources.sp_checkAuthentication, sqlconn);
                sqlconn.Open();
                sqlcmd.CommandType = CommandType.StoredProcedure;
                sqlcmd.Parameters.Add(AudireResources.username, SqlDbType.VarChar, 100).Value = param.username;
                sqlcmd.Parameters.Add(AudireResources.password, SqlDbType.VarChar, -1).Value = param.encryptedPassword;
                sqlcmd.Parameters.Add(AudireResources.userID, SqlDbType.VarChar, 1000).Value = param.userID;
                sqlcmd.Parameters.Add(AudireResources.deviceID, SqlDbType.VarChar, 1000).Value = param.deviceID;
                sqlcmd.Parameters.Add(AudireResources.l_err_code, SqlDbType.Int).Direction = ParameterDirection.Output;
                sqlcmd.Parameters.Add(AudireResources.l_err_message, SqlDbType.VarChar, 100).Direction = ParameterDirection.Output;
                sqlcmd.ExecuteNonQuery();

                objOutput.Error_code = Convert.ToInt32(sqlcmd.Parameters[AudireResources.l_err_code].Value);
                objOutput.err_message = Convert.ToString(sqlcmd.Parameters[AudireResources.l_err_message].Value);

            }
            catch (Exception ex)
            {
                objOutput.Error_code = 1;
                objOutput.err_message = ex.Message;
                //objOutput.Error_msg = ex.Message;
                ErrorLog(ex);
            }
            finally
            {
                sqlconn.Close();
            }
            objOutput.Error_msg = "[{\"err_code\":" + objOutput.Error_code + ", \"err_message\":\"" + objOutput.err_message + "\"}]";
            return objOutput;
        }

        private int ResetPassword(Parameters param)
        {
            int output = 0;
            SqlConnection sqlconn = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand sqlcmd = null;
            try
            {
                sqlcmd = new SqlCommand(AudireResources.sp_updatePassword, sqlconn);
                sqlconn.Open();
                sqlcmd.CommandType = CommandType.StoredProcedure;
                sqlcmd.Parameters.Add(AudireResources.username, SqlDbType.VarChar, 100).Value = param.username;
                sqlcmd.Parameters.Add(AudireResources.password, SqlDbType.VarChar, -1).Value = param.password;
                output = Convert.ToInt32(sqlcmd.ExecuteNonQuery());


            }
            catch (Exception ex)
            {
                output = 0;
                ErrorLog(ex);
            }
            finally
            {
                sqlconn.Close();
            }
            return output;
        }
        public DataTable checkUsername(Parameters param)
        {
            DataTable dtOutput = new DataTable();
            SqlConnection sqlconn = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand sqlcmd = null;
            SqlDataAdapter sqlda = null;
            try
            {
                sqlcmd = new SqlCommand(AudireResources.sp_getLoginDetails, sqlconn);
                sqlconn.Open();
                sqlcmd.CommandType = CommandType.StoredProcedure;
                sqlcmd.Parameters.Add(AudireResources.username, SqlDbType.VarChar, 100).Value = param.username;
                sqlda = new SqlDataAdapter(sqlcmd);
                sqlda.Fill(dtOutput);

            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
            finally
            {
                sqlconn.Close();
            }
            return dtOutput;
        }

        private string Encrypt(string clearText)
        {
            string EncryptionKey = "KNS_Audire";
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = Convert.ToBase64String(ms.ToArray());
                }
            }
            return clearText;
        }

        internal void ErrorLog(Exception ex)
        {
            StreamWriter log;
            DateTime dateTime = DateTime.UtcNow.Date;
            string ErrorLogFile = Convert.ToString(ConfigurationManager.AppSettings["ErrorLogFile"]) + "_" + dateTime.ToString("dd_MM_yyyy") + ".txt";
            string ErrorFile = Convert.ToString(ConfigurationManager.AppSettings["ErrorFile"]) + "_" + dateTime.ToString("dd_MM_yyyy") + ".txt";

            try
            {

                string message = string.Format("Time: {0}", DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss tt"));
                message += Environment.NewLine;
                message += "-----------------------------------------------------------";
                message += Environment.NewLine;
                message += string.Format("Message: {0}", ex.Message);
                message += Environment.NewLine;
                message += string.Format("StackTrace: {0}", ex.StackTrace);
                message += Environment.NewLine;
                message += string.Format("Source: {0}", ex.Source);
                message += Environment.NewLine;
                message += string.Format("TargetSite: {0}", ex.TargetSite.ToString());
                message += Environment.NewLine;
                message += "-----------------------------------------------------------";
                message += Environment.NewLine;

                if (!File.Exists(ErrorFile))
                {
                    log = new StreamWriter(ErrorLogFile, true);
                }
                else
                {
                    log = File.AppendText(ErrorLogFile);
                }

                // Write to the file:
                log.WriteLine("Date Time:" + DateTime.Now.ToString());
                log.WriteLine(message);
                // Close the stream:
                log.Close();

            }
            catch (Exception)
            {

                if (!File.Exists(ErrorFile))
                {
                    log = new StreamWriter(ErrorLogFile, true);
                }
                else
                {
                    log = File.AppendText(ErrorLogFile);
                }
                log.Close();
            }
        }
        internal void TestLog(string text, string fn_name)
        {
            StreamWriter log;
            DateTime dateTime = DateTime.UtcNow.Date;
            string ErrorLogFile = Convert.ToString(ConfigurationManager.AppSettings["ErrorLogFile"]) + "_" + dateTime.ToString("dd_MM_yyyy") + ".txt";
            string ErrorFile = Convert.ToString(ConfigurationManager.AppSettings["ErrorFile"]) + "_" + dateTime.ToString("dd_MM_yyyy") + ".txt";

            try
            {
                string message = string.Format("Time: {0}", DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss tt"));
                message += Environment.NewLine;
                message += "-----------------------------------------------------------";
                message += Environment.NewLine;
                message += string.Format("Function: {0}", fn_name);
                message += Environment.NewLine;
                message += string.Format("Message: {0}", text);
                message += Environment.NewLine;
                message += "-----------------------------------------------------------";
                message += Environment.NewLine;


               
                if (!File.Exists(ErrorFile))
                {
                    log = new StreamWriter(ErrorLogFile, true);
                }
                else
                {
                    log = File.AppendText(ErrorLogFile);
                }

                // Write to the file:
                log.WriteLine("Date Time:" + DateTime.Now.ToString());
                log.WriteLine(message);
                // Close the stream:
                log.Close();
            }
            catch (Exception)
            {

                if (!File.Exists(ErrorFile))
                {
                    log = new StreamWriter(ErrorLogFile, true);
                }
                else
                {
                    log = File.AppendText(ErrorLogFile);
                }
                log.Close();
            }
        }
        public static DataTable CreateDataTable<T>(IEnumerable<T> list)
        {
            Type type = typeof(T);
            var properties = type.GetProperties();

            DataTable dataTable = new DataTable();
            foreach (PropertyInfo info in properties)
            {
                dataTable.Columns.Add(new DataColumn(info.Name, Nullable.GetUnderlyingType(info.PropertyType) ?? info.PropertyType));
            }

            foreach (T entity in list)
            {
                object[] values = new object[properties.Length];
                for (int i = 0; i < properties.Length; i++)
                {
                    values[i] = properties[i].GetValue(entity);
                }

                dataTable.Rows.Add(values);
            }

            return dataTable;
        }

        private void SendMail(EmailDetails objEmail)
        {
            string ErrorMessage = string.Empty;
            string DestinationEmail = string.Empty;
            MailMessage email;
            SmtpClient smtpc;
            try
            {
                email = new MailMessage();
                if (objEmail.toMailId.Contains(";"))
                {
                    List<string> names = objEmail.toMailId.Split(';').ToList<string>();
                    for (int i = 0; i < names.Count; i++)
                    {
                        if (!string.IsNullOrEmpty(names[i].TrimStart().TrimEnd()))
                            email.To.Add(names[i]);
                    }
                }
                else
                {
                    email.To.Add(objEmail.toMailId);
                }
                //email.To.Add(objEmail.toMailId);
                if (!string.IsNullOrEmpty(objEmail.ccMailId))
                    email.CC.Add(objEmail.ccMailId);
                email.Subject = objEmail.subject;
                email.Body = objEmail.body;
                email.IsBodyHtml = true;
                //email.From.Address = objEmail.fromMailId;
                if (!string.IsNullOrEmpty(objEmail.attachment))
                    email.Attachments.Add(new Attachment(objEmail.attachment));
                smtpc = new SmtpClient();
                smtpc.Send(email);
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
        }

        #endregion


        internal List<UserDetails> GetUserDetailsFromDB(Parameters paramdetails)
        {
            DataSet ds = new DataSet();
            DataTable dtModule = new DataTable();
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<UserDetails> userList = new List<UserDetails>();
            SqlCommand command;
            List<ModuleListForUser> moduleList = new List<ModuleListForUser>();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetUserDetailsFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_UserLogin, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.username, SqlDbType.VarChar, 100).Value = paramdetails.username;
                    command.Parameters.Add(AudireResources.password, SqlDbType.VarChar, -1).Value = Encrypt(paramdetails.password);
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(ds);
                    if (ds != null)
                    {
                        if (ds.Tables.Count > 0)
                        {
                            userList = ds.Tables[0].DataTableToList<UserDetails>();
                        }
                        if (ds.Tables[1].Rows.Count > 0)
                        {
                            moduleList = ds.Tables[1].DataTableToList<ModuleListForUser>();
                        }
                        userList[0].module = moduleList;
                    }


                }
                else
                {
                    UserDetails obj = new UserDetails();
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    userList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                UserDetails obj = new UserDetails();
                obj.err_code = 202;
                obj.err_message = ex.Message;
                userList.Add(obj);
                ErrorLog(ex);
            }

            return userList;
        }


        public DataTable ToDataTable<T>(List<T> items)
        {

            DataTable dataTable = new DataTable(typeof(T).Name);

            //Get all the properties

            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

            foreach (PropertyInfo prop in Props)
            {

                //Setting column names as Property names

                dataTable.Columns.Add(prop.Name);

            }

            foreach (T item in items)
            {

                var values = new object[Props.Length];

                for (int i = 0; i < Props.Length; i++)
                {

                    //inserting property values to datatable rows

                    values[i] = Props[i].GetValue(item, null);

                }

                dataTable.Rows.Add(values);

            }

            //put a breakpoint here and check datatable

            return dataTable;

        }

        internal List<ModuleList> GetModuleListFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            DataTable dt = new DataTable();
            List<ModuleList> moduleList = new List<ModuleList>();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetModuleListFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_GetModuleList, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    moduleList = dt.DataTableToList<ModuleList>();

                }
                else
                {
                    ModuleList obj = new ModuleList();
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    moduleList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                ModuleList obj = new ModuleList();
                obj.err_code = 202;
                obj.err_message = ex.Message;
                moduleList.Add(obj);
                ErrorLog(ex);
            }

            return moduleList;
        }

        internal List<RegionList> GetRegionListFromDB(Parameters paramdetails)
        {
            string Output = string.Empty;
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<RegionList> regionList = new List<RegionList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetRegionListFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_GetRegionList, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.username, SqlDbType.VarChar, 100).Value = paramdetails.username;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    regionList = dt.DataTableToList<RegionList>();
                }
                else
                {
                    RegionList obj = new RegionList();
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    regionList.Add(obj);
                    Output = Convert.ToString(objOutputDetail.Error_msg);
                }
            }
            catch (Exception ex)
            {
                RegionList obj = new RegionList();
                obj.err_code = 202;
                obj.err_message = ex.Message;
                regionList.Add(obj);
                ErrorLog(ex);
            }

            return regionList;
        }

        internal List<CountryList> GetCountryListFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<CountryList> countryList = new List<CountryList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            CountryList obj = new CountryList();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetCountryListFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_GetCountryList, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_region_id, SqlDbType.Int).Value = paramdetails.region_id;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    countryList = dt.DataTableToList<CountryList>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    countryList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                countryList.Add(obj);
                ErrorLog(ex);
            }

            return countryList;
        }

        internal List<LocationList> GetLocationListFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<LocationList> locList = new List<LocationList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            LocationList obj = new LocationList();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetLocationListFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_GetLocationList, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_country_id, SqlDbType.Int).Value = paramdetails.country_id;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    locList = dt.DataTableToList<LocationList>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    locList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                locList.Add(obj);
                ErrorLog(ex);
            }

            return locList;
        }

        internal List<AuditPlanList> GetAuditPlanListFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<AuditPlanList> planList = new List<AuditPlanList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            AuditPlanList obj = new AuditPlanList();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetAuditPlanListFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_GetAuditPlanSubAuditType, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_location_id, SqlDbType.Int).Value = paramdetails.location_id;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    command.Parameters.Add(AudireResources.auditType_id, SqlDbType.Int).Value = paramdetails.auditType_id;
                    command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = null;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    planList = dt.DataTableToList<AuditPlanList>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    planList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                planList.Add(obj);
                ErrorLog(ex);
            }

            return planList;
        }

        

        internal List<LineList> GetLineListFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<LineList> lineList = new List<LineList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            LineList obj = new LineList();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetLineListFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_GetLinesForLocation, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_location_id, SqlDbType.Int).Value = paramdetails.location_id;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    lineList = dt.DataTableToList<LineList>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    lineList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                lineList.Add(obj);
                ErrorLog(ex);
            }

            return lineList;
        }

        internal List<QuestionList> GetQuestionListFromDB(Parameters paramdetails)
        {
            List<QuestionList> questionList = new List<QuestionList>();
            QuestionList obj = new QuestionList();
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            DataTable dt = new DataTable();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetQuestionListFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_getQuestionList, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    command.Parameters.Add(AudireResources.auditType_id, SqlDbType.Int).Value = paramdetails.auditType_id;
                    command.Parameters.Add(AudireResources.l_location_id, SqlDbType.Int).Value = paramdetails.location_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    questionList = dt.DataTableToList<QuestionList>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    questionList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                questionList.Add(obj);
                ErrorLog(ex);
            }

            return questionList;
        }

        internal List<QuestionsWithSection> GetQuestionListForCFromDB(Parameters paramdetails)
        {
            List<QuestionsWithSection> quesSecList = new List<QuestionsWithSection>();
            List<QuestionsWithSubSection> questSubSecList = new List<QuestionsWithSubSection>();
            List<QuestionList> questionList = new List<QuestionList>();
            QuestionsWithSection obj = new QuestionsWithSection();
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            DataTable dt = new DataTable();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetQuestionListFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_getQuestionListForC, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    command.Parameters.Add(AudireResources.auditType_id, SqlDbType.Int).Value = paramdetails.auditType_id;
                    command.Parameters.Add(AudireResources.l_location_id, SqlDbType.Int).Value = paramdetails.location_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    QuestionsWithSection quesSec = new QuestionsWithSection();
                    QuestionsWithSubSection questSubSec = new QuestionsWithSubSection();
                    QuestionList question = new QuestionList();
                    DataRow[] drSec;
                    DataRow[] drSubSec;

                    DataView dv = new DataView(dt);
                    string[] dtSecCol = { "section_name", "audit_id", "audit_number", "IsCompleted" };
                    DataTable dtSec = dv.ToTable("dtSec", true, dtSecCol);
                    if (dtSec != null)
                        if (dtSec.Rows.Count > 0)
                            for (int i = 0; i < dtSec.Rows.Count; i++)
                            {
                                if (!string.IsNullOrEmpty(Convert.ToString(dtSec.Rows[i]["section_name"])))
                                {
                                    questSubSecList = new List<QuestionsWithSubSection>();
                                    quesSec = new QuestionsWithSection();
                                    quesSec.expanded = false;
                                    if (Convert.ToString(dtSec.Rows[i]["section_name"]).Contains('.'))
                                    {
                                        quesSec.id = Convert.ToString(dtSec.Rows[i]["section_name"]).Substring(0, Convert.ToString(dtSec.Rows[i]["section_name"]).IndexOf('.'));
                                    }
                                    else
                                    {
                                        quesSec.id = "0";
                                    }
                                    quesSec.audit_id = Convert.ToInt32(dtSec.Rows[i]["audit_id"]);
                                    quesSec.audit_number = Convert.ToString(dtSec.Rows[i]["audit_number"]);
                                    quesSec.category_Name = Convert.ToString(dtSec.Rows[i]["section_name"]);
                                    quesSec.IsCompleted = Convert.ToString(dtSec.Rows[i]["IsCompleted"]);
                                    dv = new DataView(dt);
                                    string[] dtSubSecCol = { "section_name", "sub_section_name" };
                                    DataTable dtSubSec = dv.ToTable("dtSubSec", true, dtSubSecCol);
                                    drSec = dtSubSec.Select("section_name = '" + Convert.ToString(dtSec.Rows[i]["section_name"]) + "'");
                                    if (drSec.Length > 0)
                                    {
                                        for (int j = 0; j < drSec.Length; j++)
                                        {
                                            questionList = new List<QuestionList>();
                                            questSubSec = new QuestionsWithSubSection();
                                            questSubSec.sub_name = String.IsNullOrEmpty(Convert.ToString(drSec[j]["sub_section_name"]))?"": Convert.ToString(drSec[j]["sub_section_name"]);
                                            //questSubSec.clause = Convert.ToString(drSec[i]["clause"]);
                                            if (!String.IsNullOrEmpty(Convert.ToString(drSec[j]["sub_section_name"])))
                                            {
                                                drSubSec = dt.Select("sub_section_name = '" + Convert.ToString(drSec[j]["sub_section_name"]) + "'");
                                                #region question_insert

                                                if (drSubSec.Length > 0)
                                                {
                                                    for (int k = 0; k < drSubSec.Length; k++)
                                                    {
                                                        question = new QuestionList();
                                                        question.audit_id = Convert.ToInt32(drSubSec[k]["audit_id"]);
                                                        question.audit_number = Convert.ToString(drSubSec[k]["audit_number"]);
                                                        question.question_id = Convert.ToInt32(drSubSec[k]["question_id"]);
                                                        question.question = Convert.ToString(drSubSec[k]["question"]);
                                                        question.help_text = Convert.ToString(drSubSec[k]["help_text"]);
                                                        question.answer = Convert.ToString(drSubSec[k]["answer"]);
                                                        question.assigned_To = Convert.ToString(drSubSec[k]["assigned_To"]);
                                                        question.audit_comment = Convert.ToString(drSubSec[k]["audit_comment"]);
                                                        question.audit_images = Convert.ToString(drSubSec[k]["audit_images"]);
                                                        question.IsCompleted = Convert.ToString(drSubSec[k]["IsCompleted"]);
                                                        questionList.Add(question);
                                                    }
                                                }
                                                #endregion
                                            }
                                            else
                                            {
                                                drSubSec = dt.Select("(sub_section_name is null or sub_section_name='') and section_name = '" + Convert.ToString(dtSec.Rows[i]["section_name"]) + "'");
                                                #region question_insert
                                                if (drSubSec.Length > 0)
                                                {
                                                    for (int k = 0; k < drSubSec.Length; k++)
                                                    {
                                                        question = new QuestionList();
                                                        question.audit_id = Convert.ToInt32(drSubSec[k]["audit_id"]);
                                                        question.audit_number = Convert.ToString(drSubSec[k]["audit_number"]);
                                                        question.question_id = Convert.ToInt32(drSubSec[k]["question_id"]);
                                                        question.question = Convert.ToString(drSubSec[k]["question"]);
                                                        question.help_text = Convert.ToString(drSubSec[k]["help_text"]);
                                                        questionList.Add(question);
                                                    }
                                                }
                                                #endregion
                                            }
                                            questSubSec.name = questionList;
                                            questSubSecList.Add(questSubSec);
                                        }
                                        quesSec.sub_Category = questSubSecList;
                                    }

                                    quesSecList.Add(quesSec);
                                }
                                else
                                {
                                    quesSec = new QuestionsWithSection();
                                    questSubSecList = new List<QuestionsWithSubSection>();
                                    questSubSec = new QuestionsWithSubSection();
                                    questionList = dt.DataTableToList<QuestionList>();
                                    questSubSec.name = questionList;
                                    questSubSecList.Add(questSubSec);
                                    quesSec.audit_number = Convert.ToString(dt.Rows[0]["audit_number"]);
                                    quesSec.audit_id = Convert.ToInt32(dt.Rows[0]["audit_id"]);
                                    quesSec.sub_Category = questSubSecList;
                                    quesSecList.Add(quesSec);
                                }
                            }
                        else
                        {
                            //quesSec = new QuestionsWithSection();
                            //questSubSecList = new List<QuestionsWithSubSection>();
                            //questSubSec = new QuestionsWithSubSection();
                            //questionList = dt.DataTableToList<QuestionList>();
                            //questSubSec.name = questionList;
                            //questSubSecList.Add(questSubSec);
                            //quesSec.sub_Category = questSubSecList;
                            //quesSecList.Add(quesSec);
                        }
                    questionList = dt.DataTableToList<QuestionList>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    quesSecList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                quesSecList.Add(obj);
                ErrorLog(ex);
            }

            return quesSecList;
        }

        internal List<ProductList> GetProductListFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<ProductList> productList = new List<ProductList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            ProductList obj = new ProductList();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetProductListFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_GetProductsForLine, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_line_id, SqlDbType.Int).Value = paramdetails.line_id;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    if (dt != null)
                    {
                        if (dt.Rows.Count > 0)
                        {
                            if (Convert.ToString(dt.Rows[0]["line_id"]) == "0")
                            {
                                obj.err_code = Convert.ToInt32(dt.Rows[0]["product_id"]);
                                obj.err_message = Convert.ToString(dt.Rows[0]["product_name"]);
                                productList.Add(obj);
                            }
                            else
                            {
                                productList = dt.DataTableToList<ProductList>();
                            }
                        }
                    }


                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    productList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                productList.Add(obj);
                ErrorLog(ex);
            }

            return productList;
        }

        internal List<ProcessList> GetProcessListFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<ProcessList> processList = new List<ProcessList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            ProcessList obj = new ProcessList();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetProcessListFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_GetProcessList, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    processList = dt.DataTableToList<ProcessList>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    processList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                processList.Add(obj);
                ErrorLog(ex);
            }

            return processList;
        }

        public byte[] GetFileFromFolder(string filename)
        {
            byte[] filedetails = new byte[0];
            string strTempFolderPath = System.Configuration.ConfigurationManager.AppSettings.Get("PDF_Folder");
            if (File.Exists(strTempFolderPath + filename))
            {
                return File.ReadAllBytes(strTempFolderPath + filename);
            }
            else return filedetails;
        }

        private string CreatePDFForAuditResult(DataTable dtAnswers)
        {
            string html = string.Empty;
            string filename = string.Empty;
            string filepath = string.Empty;
            int module;
            string audit_type = string.Empty;
            try
            {
                if (dtAnswers != null)
                {
                    module = Convert.ToInt32(dtAnswers.Rows[0]["module_id"]);
                    audit_type = Convert.ToString(dtAnswers.Rows[0]["Audit_Type"]);
                    //html = "<html ><head> <script type='text/javascript'> window.onload = function() {var chart = new CanvasJS.Chart('chartContainer', { title:{text: 'Fruits sold in First Quarter'}, data: [{ type: 'column', dataPoints: [{ label: 'banana', y: 18 },{ label: 'orange', y: 29 },{ label: 'apple', y: 40 },{ label: 'mango', y: 34 },{ label: 'grape', y: 24 }]} ]  }); chart.render(); }</script><script type='text/javascript' src='https://canvasjs.com/assets/script/canvasjs.min.js'></script></head><body>";
                    html = "<html ><head></head><body>";

                    if (module==2 || module==3)
                    {
                        if (audit_type.Contains("5S Audit"))
                        {
                            DataTable dt5S = new DataTable();
                            dt5S = Get5SAuditScores(Convert.ToInt32(dtAnswers.Rows[0]["audit_id"]));
                            Bindchart(dt5S);
                            html += PDF_5SAudit(dtAnswers, dt5S);

                        }
                        else
                        {
                            html += Process_ProductAuditpdf(dtAnswers, module);
                        }
                    }
                    else if (module == 1 || module==4)
                    {
                        DataTable dtFirst = new DataTable();
                        dtFirst = GetComplainceScores(Convert.ToInt32(dtAnswers.Rows[0]["audit_id"]));
                        html += ComplianceAuditPDF(dtAnswers, dtFirst);
                    }
                    //html += heading(dtAnswers);
                    //html += questionheading();
                    //html += ExportDatatableToHtml(dtAnswers);
                    filename = "Audit_Result_" + Convert.ToString(dtAnswers.Rows[0]["audit_id"]) + ".pdf";
                    filepath = ConfigurationManager.AppSettings["PDF_Folder"].ToString();
                    html += "</body></html>";
                    //TestLog(html, "CreatePDFForAuditResult");
                    convertPDF(html, filepath, filename);
                }
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
            return filename;
        }

        private DataTable Get5SAuditScores(int audit_id)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            DataTable dt = new DataTable();
            try
            {
                command = new SqlCommand(AudireResources.sp_get_5S_Score, connection);
                connection.Open();
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(AudireResources.audit_id, SqlDbType.Int).Value = audit_id;
                SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                sqlDA.Fill(dt);
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
            return dt;
        }

        private DataTable GetComplainceScores(int audit_id)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            DataTable dt = new DataTable();
            try
            {
                command = new SqlCommand(AudireResources.sp_getSectionWiseScore, connection);
                connection.Open();
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(AudireResources.audit_id, SqlDbType.Int).Value = audit_id;
                SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                sqlDA.Fill(dt);
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
            return dt;
        }

        private string questionheading()
        {
            StringBuilder strHTMLBuilder = new StringBuilder();
            string Htmltext = string.Empty;
            try
            {
                strHTMLBuilder.Append("<table style='border-collapse: collapse; border: 1px solid darkgray;'>");
                strHTMLBuilder.Append("<tr height='20px' style='background-color:gray;'>");
                strHTMLBuilder.Append("<td width='50px' style='font-size:10px; border: 1px solid gray; border-collapse: collapse;'>");
                strHTMLBuilder.Append("No#");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='600px' style='border: 1px solid darkgray; border-collapse: collapse; font-size:10px; text-align:center;'>");
                strHTMLBuilder.Append("Question");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='100px' colspan='3' style='border: 1px solid darkgray; border-collapse: collapse; font-size:10px; text-align:center;'>");
                strHTMLBuilder.Append("Result");
                strHTMLBuilder.Append("<br/><table  style='border-collapse: collapse; border: 1px solid black;'><tr><td width='33px' style='border: 1px solid black; border-collapse: collapse; font-size:9px; text-align:center;'>");
                strHTMLBuilder.Append(Convert.ToString("No"));
                strHTMLBuilder.Append("</td><td width='33px' style='border: 1px solid black; border-collapse: collapse; font-size:9px; text-align:center;'>");
                strHTMLBuilder.Append(Convert.ToString("Yes"));
                strHTMLBuilder.Append("</td><td width='33px' style='border: 1px solid black; border-collapse: collapse; font-size:9px; text-align:center;'>");
                strHTMLBuilder.Append(Convert.ToString("NA"));
                strHTMLBuilder.Append("</td></tr></table>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='150px' style='border: 1px solid darkgray; border-collapse: collapse; font-size:9px; text-align:center;'>");
                strHTMLBuilder.Append("Findings");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='100px' style='border: 1px solid darkgray; border-collapse: collapse; font-size:9px; text-align:center; '>");
                strHTMLBuilder.Append("Assigned To.");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                Htmltext = strHTMLBuilder.ToString();
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
            return Htmltext;
        }

        private string ExportDatatableToHtml(DataTable dt)
        {
            StringBuilder strHTMLBuilder = new StringBuilder();
            string Htmltext = string.Empty;
            try
            {

                foreach (DataRow myRow in dt.Rows)
                {

                    strHTMLBuilder.Append("<tr style='background-color:white; height:30px'>");
                    foreach (DataColumn myColumn in dt.Columns)
                    {
                        if (myColumn.ColumnName.ToString() == "question_id")
                        {
                            strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid darkgray; font-size:10px;'>");
                            strHTMLBuilder.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder.Append("</td>");
                        }

                        else if (myColumn.ColumnName.ToString() == "question")
                        {
                            strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid darkgray; font-size:10px;'>");
                            strHTMLBuilder.Append(myRow[myColumn.ColumnName].ToString());
                            strHTMLBuilder.Append("</td>");
                        }
                        else if (myColumn.ColumnName.ToString() == "answer")
                        {
                            if (myRow[myColumn.ColumnName].ToString() == "1")
                            {
                                strHTMLBuilder.Append("<td width='33px' style='background-color:red;  border-collapse: collapse; border: 1px solid darkgray; font-size:10px;'>");
                                strHTMLBuilder.Append("&#10008;");
                                strHTMLBuilder.Append("</td>");
                                strHTMLBuilder.Append("<td width='33px' style='border-collapse: collapse; border: 1px solid darkgray; font-size:10px;'>");
                                //strHTMLBuilder.Append("Yes");
                                strHTMLBuilder.Append("</td>");
                                //if (myRow["na_flag"].ToString() == "Y")
                                //{
                                //    strHTMLBuilder.Append("<td width='25px' style='border-collapse: collapse; border: 1px solid darkgray; font-family:Gotham-Book; font-size:" + fontsize + "px;'>");
                                //    // strHTMLBuilder.Append("Not Applicable");
                                //    strHTMLBuilder.Append("</td>");
                                //}
                                //else
                                //{
                                strHTMLBuilder.Append("<td width='33px'>");
                                // strHTMLBuilder.Append("Not Applicable");
                                strHTMLBuilder.Append("</td>");
                                //}
                            }
                            else if (myRow[myColumn.ColumnName].ToString() == "0")
                            {
                                strHTMLBuilder.Append("<td width='33px' style=' border-collapse: collapse; border: 1px solid darkgray; font-size:10px;'>");
                                //strHTMLBuilder.Append("&#10004;");
                                strHTMLBuilder.Append("</td>");
                                strHTMLBuilder.Append("<td width='33px' style=' background-color:#048347; border-collapse: collapse; border: 1px solid darkgray; font-size:10px;'>");
                                strHTMLBuilder.Append("&#10004;");
                                strHTMLBuilder.Append("</td>");
                                //if (myRow["na_flag"].ToString() == "Y")
                                //{
                                //    strHTMLBuilder.Append("<td width='25px' style='border-collapse: collapse; border: 1px solid darkgray; font-family:Gotham-Book; font-size:" + fontsize + "px;'>");
                                //    // strHTMLBuilder.Append("Not Applicable");
                                //    strHTMLBuilder.Append("</td>");
                                //}
                                //else
                                //{
                                strHTMLBuilder.Append("<td width='33px'>");
                                // strHTMLBuilder.Append("Not Applicable");
                                strHTMLBuilder.Append("</td>");
                                //}
                            }
                            else
                            {
                                strHTMLBuilder.Append("<td width='33px' style=' border-collapse: collapse; border: 1px solid darkgray; font-size:10px;'>");
                                //strHTMLBuilder.Append("&#10004;");
                                strHTMLBuilder.Append("</td>");
                                strHTMLBuilder.Append("<td width='33px' style=' border-collapse: collapse; border: 1px solid darkgray; font-size:10px;'>");
                                //strHTMLBuilder.Append("Yes");
                                strHTMLBuilder.Append("</td>");
                                //if (myRow["na_flag"].ToString() == "Y")
                                //{
                                strHTMLBuilder.Append("<td width='33px' style='background-color:gray; border-collapse: collapse; border: 1px solid darkgray; font-size:10px;'>");
                                strHTMLBuilder.Append("&#10004;");
                                strHTMLBuilder.Append("</td>");
                                //}
                                //else
                                //{
                                //    strHTMLBuilder.Append("<td width='25px'>");
                                //    // strHTMLBuilder.Append("Not Applicable");
                                //    strHTMLBuilder.Append("</td>");
                                //}

                            }

                        }
                        else if (myColumn.ColumnName.ToString() == "audit_comment")
                        {
                            strHTMLBuilder.Append("<td style='font-size:10px;'>");
                            strHTMLBuilder.Append(myRow[myColumn.ColumnName]);
                            strHTMLBuilder.Append("</td>");
                        }
                        else if (myColumn.ColumnName.ToString() == "assignedTo")
                        {
                            strHTMLBuilder.Append("<td style='font-size:10px;'>");
                            strHTMLBuilder.Append(myRow[myColumn.ColumnName]);
                            strHTMLBuilder.Append("</td>");
                        }
                    }
                    strHTMLBuilder.Append("</tr>");
                }

                //Close tags.  
                strHTMLBuilder.Append("</table>");

                Htmltext = strHTMLBuilder.ToString();
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
            return Htmltext;
        }

        private string PDF_5SAudit(DataTable dtAnswers, DataTable dt5S)
        {
            string output = string.Empty;
            StringBuilder strHTMLBuilder = new StringBuilder();
            string img_comment = string.Empty;
            string img_signature = string.Empty;
            string img_chart = string.Empty;
            DataTable dtHeading = new DataTable();
            int score;
            try
            {

                img_comment = Convert.ToString(ConfigurationManager.AppSettings["Comments"]);
                img_signature = Convert.ToString(ConfigurationManager.AppSettings["Signature"]);
                img_chart = Convert.ToString(ConfigurationManager.AppSettings["ChartImageFile"]);
                dtHeading = dtAnswers;
                strHTMLBuilder.Append("<table cellspacing='0'>");

                strHTMLBuilder.Append("<tr >");
                strHTMLBuilder.Append("<td colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u>5S Audit Report</u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");

                strHTMLBuilder.Append("<table cellspacing='0'>");
                strHTMLBuilder.Append("<tr height='20px'>");
                strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u></u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");

                strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; background-color: #adadad; '>");

                strHTMLBuilder.Append("<tr height='40px'>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Audit Site");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["location_name"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Audit Date");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Audit_date"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0'>");
                strHTMLBuilder.Append("<tr height='20px'>");
                strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u></u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");

                strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; background-color: #adadad; '>");

                strHTMLBuilder.Append("<tr height='40px'>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Process Name");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Audit_Type"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Auditor Name");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["emp_full_name"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0'>");
                strHTMLBuilder.Append("<tr height='20px'>");
                strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u></u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");

                score = Convert.ToInt32(dtHeading.Rows[0]["Score"]);

                strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; '>");
                strHTMLBuilder.Append("<tr height='40px' style=' background-color: #adadad;'>");
                strHTMLBuilder.Append("<td style='width:20%; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Total No Of Question");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:20%; font-size:14px; font-weight:bold; color: white;border: 1px solid white; '>");
                strHTMLBuilder.Append("Answered With YES");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:20%; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Answered With NO");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:20%; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Answered With NA");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:20%; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Total Audit Score");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("<tr height='40px'>");
                strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: #e6e6e6;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["tot_answer"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: #dcfad7;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["yes_answer"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: red;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["no_answer"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: #b1acac;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["NA_answer"]));
                strHTMLBuilder.Append("</td>");
                if (score <= 60)
                {
                    strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: red;'>");
                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Score"]));
                    strHTMLBuilder.Append("%</td>");
                }
                else if (score > 60 && score < 80)
                {
                    strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: yellow;'>");
                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Score"]));
                    strHTMLBuilder.Append("%</td>");
                }
                else
                {
                    strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: green;'>");
                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Score"]));
                    strHTMLBuilder.Append("%</td>");
                }
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0'>");
                strHTMLBuilder.Append("<tr height='20px'>");
                strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u></u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");

                strHTMLBuilder.Append("<table style='border-collapse: collapse; border: 1px solid darkgray; width: 100%; '>");
                strHTMLBuilder.Append("<tr height='40px' style='background-color:#adadad;'>");
                strHTMLBuilder.Append("<td width='40%' style='color:white; border: 1px solid darkgray; font-weight:bold; border-collapse: collapse; font-size:14px; text-align:center;'>");
                strHTMLBuilder.Append("Section");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='20%' style='color:white; border: 1px solid darkgray; font-weight:bold; border-collapse: collapse; font-size:14px; text-align:center;'>");
                strHTMLBuilder.Append("No of YES");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='20%' style='color:white; border: 1px solid darkgray; font-weight:bold; border-collapse: collapse; font-size:14px; text-align:center;'>");
                strHTMLBuilder.Append("No of NO");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='20%' style='color:white; border: 1px solid darkgray; font-weight:bold; border-collapse: collapse; font-size:14px; text-align:center; '>");
                strHTMLBuilder.Append("Score in %");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");

                int flag = 0;
                int row_score = 0;
                foreach (DataRow myRow in dt5S.Rows)
                {
                    row_score = Convert.ToInt32(myRow["score"]);
                    flag++;
                    if (flag == 1)
                    {
                        strHTMLBuilder.Append("<tr style='background-color:#dcfad7; height:30px'>");
                    }
                    else if (flag == 2)
                    {
                        strHTMLBuilder.Append("<tr style='background-color:#b1f9a8; height:30px'>");
                    }
                    else if (flag == 3)
                    {
                        strHTMLBuilder.Append("<tr style='background-color:#75d673; height:30px'>");
                    }
                    else if (flag == 4)
                    {
                        strHTMLBuilder.Append("<tr style='background-color:#5fa25e; height:30px'>");
                    }
                    else if (flag == 5)
                    {
                        strHTMLBuilder.Append("<tr style='background-color:#3f693f; height:30px'>");
                    }
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-weight:bold; font-size:14px;'>");
                    strHTMLBuilder.Append(myRow["section_name"].ToString());
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; text-align:center; font-weight:bold; border: 1px solid white; font-size:14px;'>");
                    strHTMLBuilder.Append(myRow["yes_count"]);
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; text-align:center; font-weight:bold; border: 1px solid white; font-size:14px;'>");
                    strHTMLBuilder.Append(myRow["no_count"]);
                    strHTMLBuilder.Append("</td>");

                    if (row_score <= 60)
                    {
                        strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: red;'>");
                        strHTMLBuilder.Append(Convert.ToString(row_score));
                        strHTMLBuilder.Append("%</td>");
                    }
                    else if (row_score > 60 && row_score < 80)
                    {
                        strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: yellow;'>");
                        strHTMLBuilder.Append(Convert.ToString(row_score));
                        strHTMLBuilder.Append("%</td>");
                    }
                    else
                    {
                        strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: green;'>");
                        strHTMLBuilder.Append(Convert.ToString(row_score));
                        strHTMLBuilder.Append("%</td>");
                    }

                    //strHTMLBuilder.Append("<td style='border-collapse: collapse; text-align:center; font-weight:bold; border: 1px solid white; font-size:14px;'>");
                    //strHTMLBuilder.Append(myRow["score"]);
                    //strHTMLBuilder.Append("%</td>");
                    strHTMLBuilder.Append("</tr>");
                }

                strHTMLBuilder.Append("<tr>");
                strHTMLBuilder.Append("<td style='width:100%'><img style='width:690px; height:400px' src='");
                strHTMLBuilder.Append(img_chart);
                strHTMLBuilder.Append("'/>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("<tr>");
                strHTMLBuilder.Append("<td style='width:100%'><img style='width:690px; height:70px' src='");
                strHTMLBuilder.Append(img_signature);
                strHTMLBuilder.Append("'/>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                //Close tags.  
                strHTMLBuilder.Append("</table>");
                output = strHTMLBuilder.ToString();
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
            return output;
        }

        private string Process_ProductAuditpdf(DataTable dtAnswers, int module)
        {
            string output = string.Empty;
            StringBuilder strHTMLBuilder = new StringBuilder();
            string img_comment = string.Empty;
            string img_signature = string.Empty;
            DataTable dtHeading = new DataTable();
            int score;
            try
            {
                img_comment = Convert.ToString(ConfigurationManager.AppSettings["Comments"]);
                img_signature = Convert.ToString(ConfigurationManager.AppSettings["Signature"]);
                dtHeading = dtAnswers;
                if (module == 3)
                {
                    strHTMLBuilder.Append("<table cellspacing='0'>");

                    strHTMLBuilder.Append("<tr >");
                    strHTMLBuilder.Append("<td colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                    strHTMLBuilder.Append("<u>Product Audit Report</u>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");
                    // strHTMLBuilder.Append("<div style='width:60%;'><b><u style='float: right; font-size: 25px;'>Product Audit Report</u></b></div>");
                }
                else if (module == 4)
                {
                    strHTMLBuilder.Append("<table cellspacing='0'>");

                    strHTMLBuilder.Append("<tr >");
                    strHTMLBuilder.Append("<td colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                    strHTMLBuilder.Append("<u>Supplier Audit Report</u>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");
                    // strHTMLBuilder.Append("<div style='width:60%;'><b><u style='float: right; font-size: 25px;'>Product Audit Report</u></b></div>");
                }
                else
                {
                    strHTMLBuilder.Append("<table cellspacing='0'>");

                    strHTMLBuilder.Append("<tr >");
                    strHTMLBuilder.Append("<td colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                    strHTMLBuilder.Append("<u>Process Audit Report</u>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");
                    //strHTMLBuilder.Append("<div style='width:60%;'><b><u style='float: right; font-size: 25px;'>Process Audit Report</u></b></div>");
                }

                strHTMLBuilder.Append("<table cellspacing='0'>");
                strHTMLBuilder.Append("<tr height='10px'>");
                strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u></u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; background-color: #adadad; '>");

                strHTMLBuilder.Append("<tr height='30px'>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Audit Site");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["location_name"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Audit Date");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Audit_date"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0'>");
                strHTMLBuilder.Append("<tr height='10px'>");
                strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u></u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; background-color: #adadad; '>");

                strHTMLBuilder.Append("<tr height='30px'>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                if (module == 3)
                {
                    strHTMLBuilder.Append("Product Name");
                }
                else if (module == 4)
                {
                    strHTMLBuilder.Append("Supplier Name");
                }
                else
                {
                    strHTMLBuilder.Append("Process Name");
                }
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Audit_Type"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Auditor Name");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["emp_full_name"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0'>");
                strHTMLBuilder.Append("<tr height='10px'>");
                strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u></u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");

                score = Convert.ToInt32(dtHeading.Rows[0]["Score"]);

                strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; '>");
                strHTMLBuilder.Append("<tr height='30px' style=' background-color: #adadad;'>");
                strHTMLBuilder.Append("<td style='width:20%; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Total No Of Question");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:20%; font-size:14px; font-weight:bold; color: white;border: 1px solid white; '>");
                strHTMLBuilder.Append("Answered With YES");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:20%; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Answered With NO");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:20%; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Answered With NA");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:20%; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Total Audit Score");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("<tr height='30px'>");
                strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: #e6e6e6;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["tot_answer"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: #dcfad7;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["yes_answer"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: red;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["no_answer"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: #b1acac;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["NA_answer"]));
                strHTMLBuilder.Append("</td>");
                if (score <= 60)
                {
                    strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: red;'>");
                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Score"]));
                    strHTMLBuilder.Append("%</td>");
                }
                else if (score > 60 && score < 80)
                {
                    strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: yellow;'>");
                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Score"]));
                    strHTMLBuilder.Append("%</td>");
                }
                else
                {
                    strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color:black;border: 1px solid white; background-color: green;'>");
                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Score"]));
                    strHTMLBuilder.Append("%</td>");
                }
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0'>");
                strHTMLBuilder.Append("<tr height='10px'>");
                strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u></u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table style='border-collapse: collapse; border: 1px solid white; width: 100%; '>");
                strHTMLBuilder.Append("<tr height='30px' style='background-color:#adadad;'>");
                strHTMLBuilder.Append("<td style='border: 1px solid darkgray; border-collapse: collapse; font-weight:bold; color:white; font-size:14px; text-align:center; width: 5%; '>");
                strHTMLBuilder.Append("Q.No");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='border: 1px solid darkgray; border-collapse: collapse; font-weight:bold; color:white; font-size:14px; text-align:center; width: 50%; '>");
                strHTMLBuilder.Append("Audit Question");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='border: 1px solid darkgray; border-collapse: collapse; font-weight:bold; color:white; font-size:14px; text-align:center; width: 15%; '>");
                strHTMLBuilder.Append("Finding");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='border: 1px solid darkgray; border-collapse: collapse; font-weight:bold; color:white; font-size:14px; text-align:center; width: 15%;'>");
                strHTMLBuilder.Append("Assigned To");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='border: 1px solid darkgray; border-collapse: collapse; font-weight:bold; color:white; font-size:14px; text-align:center;  width: 15%;'>");
                strHTMLBuilder.Append("Due Date");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");

                int color_flag = 0;
                int que_seq = 0;
                DataTable dt = dtHeading;
                foreach (DataRow myRow in dt.Rows)
                {
                    que_seq++;
                    color_flag++;
                    if (color_flag % 2 == 0)
                    {
                        strHTMLBuilder.Append("<tr style='background-color:white; height:30px'>");
                    }
                    else
                    {
                        strHTMLBuilder.Append("<tr style='background-color:lightgrey; height:30px'>");
                    }
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-size:10px; width: 5%;'>");
                    //strHTMLBuilder.Append(Convert.ToString(que_seq));
                    strHTMLBuilder.Append(myRow["question_id"].ToString());
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-size:10px; width: 50%;'>");
                    strHTMLBuilder.Append(myRow["question"].ToString());
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-size:10px; width: 15%;'>");
                    strHTMLBuilder.Append(myRow["audit_comment"]);
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-size:10px; width: 15%;'>");
                    strHTMLBuilder.Append(myRow["assignedTo"]);
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-size:10px; width: 15%;'>");
                    strHTMLBuilder.Append(myRow["dueDate"]);
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                }
                //strHTMLBuilder.Append("</table>");

                //strHTMLBuilder.Append("<table style='border: 1px solid white; border-collapse:collapse; width: 100%; '>");
                strHTMLBuilder.Append("<tr>");
                strHTMLBuilder.Append("<td style='width:100%'><img style='width:690px; height:120px' src='");
                strHTMLBuilder.Append(img_comment);
                strHTMLBuilder.Append("'/>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("<tr>");
                strHTMLBuilder.Append("<td style='width:100%'><img style='width:690px; height:70px' src='");
                strHTMLBuilder.Append(img_signature);
                strHTMLBuilder.Append("'/>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                //Close tags.  
                strHTMLBuilder.Append("</table>");
                output = strHTMLBuilder.ToString();
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
            return output;
        }

        private string ComplianceAuditPDF(DataTable dtAnswers, DataTable dtFirst)
        {
            string output = string.Empty;
            StringBuilder strHTMLBuilder = new StringBuilder();
            DataTable dtHeading = new DataTable();
            string img_comment = string.Empty;
            string img_signature = string.Empty;
            try
            {
                img_comment = Convert.ToString(ConfigurationManager.AppSettings["Comments"]);
                img_signature = Convert.ToString(ConfigurationManager.AppSettings["Signature"]);
                dtHeading = dtAnswers;
                if (dtFirst.Rows.Count > 0)
                {
                    strHTMLBuilder.Append("<table cellspacing='0'>");

                    strHTMLBuilder.Append("<tr >");
                    strHTMLBuilder.Append("<td colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                    strHTMLBuilder.Append("<u>Internal Audit Report</u>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");

                    strHTMLBuilder.Append("<table cellspacing='0'>");
                    strHTMLBuilder.Append("<tr height='40px'>");
                    strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                    strHTMLBuilder.Append("<u></u>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");

                    strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; background-color: #adadad; '>");

                    strHTMLBuilder.Append("<tr height='40px'>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                    strHTMLBuilder.Append("Audit Site");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["location_name"]));
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                    strHTMLBuilder.Append("Type Of Audit");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");

                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Audit_Type"]));
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");
                    strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; background-color: lightgrey; '>");

                    strHTMLBuilder.Append("<tr height='40px'>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: black;border: 1px solid white;'>");
                    strHTMLBuilder.Append("Audit Date");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: black;border: 1px solid white;'>");
                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Audit_date"]));
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: black;border: 1px solid white;'>");
                    strHTMLBuilder.Append("Auditor Name");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: black;border: 1px solid white;'>");

                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["emp_full_name"]));
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");
                    strHTMLBuilder.Append("<table cellspacing='0'>");
                    strHTMLBuilder.Append("<tr height='30px'>");
                    strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                    strHTMLBuilder.Append("<u></u>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");
                    strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; background-color: #adadad; '>");

                    strHTMLBuilder.Append("<tr height='40px'>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                    strHTMLBuilder.Append("Report Date");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Audit_date"]));
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                    strHTMLBuilder.Append("Due Date");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                    strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["dueDate"]));
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");
                    strHTMLBuilder.Append("<table cellspacing='0'>");
                    strHTMLBuilder.Append("<tr height='30px'>");
                    strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                    strHTMLBuilder.Append("<u></u>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");
                    strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%;'>");

                    //strHTMLBuilder.Append("<table style='border-collapse: collapse; border: 1px solid white; width: 100%; '>");
                    strHTMLBuilder.Append("<tr height='40px' style='background-color:#adadad; border: 1px solid white;'>");
                    strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;  width: 40%; '>");
                    strHTMLBuilder.Append("Process Name");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;  width: 20%;'>");
                    strHTMLBuilder.Append("Major Deviation");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white; width: 20%;'>");
                    strHTMLBuilder.Append("Minor Deviation");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white; width: 20%;'>");
                    strHTMLBuilder.Append("OFI");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");

                    foreach (DataRow myRow in dtFirst.Rows)
                    {
                        if (Convert.ToInt32(myRow["id"]) == 100)
                        {
                            strHTMLBuilder.Append("<tr style='background-color:lightgrey; height:40px; border: 2px solid grey; '>");
                        }
                        else
                        {
                            strHTMLBuilder.Append("<tr style='background-color:white; height:40px; border: 2px solid grey; '>");
                        }
                        strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 2px solid white; font-size:12px; width: 40%; text-align:center; '>");
                        strHTMLBuilder.Append(myRow["section_name"].ToString());
                        strHTMLBuilder.Append("</td>");
                        strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 2px solid white; font-size:12px; width: 20%; text-align:center; '>");
                        strHTMLBuilder.Append(myRow["major_nc"]);
                        strHTMLBuilder.Append("</td>");
                        strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 2px solid white; font-size:12px; width: 20%; text-align:center; '>");
                        strHTMLBuilder.Append(myRow["minor_nc"]);
                        strHTMLBuilder.Append("</td>");
                        strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 2px solid white; font-size:12px; width: 20%; text-align:center; '>");
                        strHTMLBuilder.Append(myRow["ofi"]);
                        strHTMLBuilder.Append("</td>");
                        strHTMLBuilder.Append("</tr>");
                    }

                    strHTMLBuilder.Append("</table>");
                    strHTMLBuilder.Append("<table cellspacing='0'>");
                    strHTMLBuilder.Append("<tr height='30px'>");
                    strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                    strHTMLBuilder.Append("<u></u>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");

                    strHTMLBuilder.Append("<table cellspacing='0'>");
                    strHTMLBuilder.Append("<tr>");
                    strHTMLBuilder.Append("<td style='width:100%'><img style='width:690px; height:170px' src='");
                    strHTMLBuilder.Append(img_comment);
                    strHTMLBuilder.Append("'/>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("<tr>");
                    strHTMLBuilder.Append("<td style='width:100%'><img style='width:690px; height:100px' src='");
                    strHTMLBuilder.Append(img_signature);
                    strHTMLBuilder.Append("'/>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    //Close tags.  
                    strHTMLBuilder.Append("</table>");
                    strHTMLBuilder.Append("<table><tr style='height:100px;'><td></td></tr></table>");
                    strHTMLBuilder.Append("<table cellspacing='0'>");
                    strHTMLBuilder.Append("<tr height='90px'>");
                    strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                    strHTMLBuilder.Append("<u></u>");
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                    strHTMLBuilder.Append("</table>");
                }

                strHTMLBuilder.Append("<table cellspacing='0'>");

                strHTMLBuilder.Append("<tr >");
                strHTMLBuilder.Append("<td colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u>Internal Audit Report</u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");

                strHTMLBuilder.Append("<table cellspacing='0'>");
                strHTMLBuilder.Append("<tr height='10px'>");
                strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u></u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; background-color: #adadad; '>");

                strHTMLBuilder.Append("<tr height='30px'>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Audit Site");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["location_name"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Type Of Audit");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");

                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Audit_Type"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; background-color: lightgrey; '>");

                strHTMLBuilder.Append("<tr height='30px'>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: black;border: 1px solid white;'>");
                strHTMLBuilder.Append("Audit Date");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: black;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Audit_date"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: black;border: 1px solid white;'>");
                strHTMLBuilder.Append("Auditor Name");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: black;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["emp_full_name"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0'>");
                strHTMLBuilder.Append("<tr height='20px'>");
                strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u></u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid white; border-collapse:collapse; width: 100%; background-color: #adadad; '>");

                strHTMLBuilder.Append("<tr height='30px'>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Report Date");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["Audit_date"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append("Due Date");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='width:25%; text-align:center; font-size:14px; font-weight:bold; color: white;border: 1px solid white;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["dueDate"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table cellspacing='0'>");
                strHTMLBuilder.Append("<tr height='10px'>");
                strHTMLBuilder.Append("<td  colspan='5' width='1000px' style='text-align:center; font-size:25px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("<u></u>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("</table>");
                strHTMLBuilder.Append("<table style='border-collapse: collapse; border: 1px solid white; width: 100%; '>");
                strHTMLBuilder.Append("<tr height='30px' style='background-color:#adadad;'>");
                strHTMLBuilder.Append("<td style='border: 1px solid darkgray; border-collapse: collapse; font-size:14px; font-weight:bold; color: white; text-align:center; width: 5%; '>");
                strHTMLBuilder.Append("Q.No");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='border: 1px solid darkgray; border-collapse: collapse; font-size:14px; font-weight:bold; color: white; text-align:center; width: 50%; '>");
                strHTMLBuilder.Append("Evaluation");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='border: 1px solid darkgray; border-collapse: collapse; font-size:14px; font-weight:bold; color: white; text-align:center; width: 15%; '>");
                strHTMLBuilder.Append("Finding");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='border: 1px solid darkgray; border-collapse: collapse; font-size:14px; font-weight:bold; color: white; text-align:center; width: 10%;'>");
                strHTMLBuilder.Append("Clause");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='border: 1px solid darkgray; border-collapse: collapse; font-size:14px; font-weight:bold; color: white; text-align:center; width: 10%;'>");
                strHTMLBuilder.Append("Assigned To Process");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='border: 1px solid darkgray; border-collapse: collapse; font-size:14px; font-weight:bold; color: white; text-align:center;  width: 10%;'>");
                strHTMLBuilder.Append("Due Date");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");

                int color_flag = 0;
                int que_seq = 0;
                DataTable dt = dtHeading;
                foreach (DataRow myRow in dt.Rows)
                {
                    que_seq++;
                    color_flag++;
                    if (color_flag % 2 == 0)
                    {
                        strHTMLBuilder.Append("<tr style='background-color:white; height:30px'>");
                    }
                    else
                    {
                        strHTMLBuilder.Append("<tr style='background-color:lightgrey; height:30px'>");
                    }
                    //strHTMLBuilder.Append("<tr style='background-color:lightgrey; height:30px'>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-size:10px; width: 5%;'>");
                    strHTMLBuilder.Append(myRow["question_id"].ToString());
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-size:10px; width: 50%;'>");
                    strHTMLBuilder.Append(myRow["question"].ToString());
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-size:10px; width: 15%;'>");
                    strHTMLBuilder.Append(myRow["audit_comment"]);
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-size:10px; width: 10%;'>");
                    // strHTMLBuilder.Append(new string(Convert.ToString(myRow["question"]).TakeWhile(c => !Char.IsLetter(c)).ToArray()));
                    strHTMLBuilder.Append(Convert.ToString(myRow["clause"]));
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-size:10px; width: 10%;'>");
                    strHTMLBuilder.Append(myRow["assignedTo"]);
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("<td style='border-collapse: collapse; border: 1px solid white; font-size:10px; width: 10%;'>");
                    strHTMLBuilder.Append(myRow["dueDate"]);
                    strHTMLBuilder.Append("</td>");
                    strHTMLBuilder.Append("</tr>");
                }


                strHTMLBuilder.Append("<tr>");
                strHTMLBuilder.Append("<td style='width:100%'><img style='width:690px; height:70px' src='");
                strHTMLBuilder.Append(img_signature);
                strHTMLBuilder.Append("'/>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                //Close tags.  
                strHTMLBuilder.Append("</table>");
                output = strHTMLBuilder.ToString();
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
            return output;
        }

        private string heading(DataTable dtAnswers)
        {
            string output = string.Empty;
            StringBuilder strHTMLBuilder = new StringBuilder();
            string imageURL = string.Empty;
            DataTable dtHeading = new DataTable();

            try
            {
                dtHeading = dtAnswers;
                imageURL = Convert.ToString(ConfigurationManager.AppSettings["MHLogo"]);
                strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append("<tr >");
                strHTMLBuilder.Append("<td>");


                strHTMLBuilder.Append("<table cellspacing='0' style='border: 1px solid darkgray; border-collapse:collapse;'>");

                strHTMLBuilder.Append("<tr >");
                strHTMLBuilder.Append("<td colspan='5' width='850px' style='text-align:center; font-size:14px; font-weight:bold; color:black;'>");
                strHTMLBuilder.Append("Audire Audit Result");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='150px'><img style='float:left; width:80px;' src='");
                strHTMLBuilder.Append(imageURL);
                strHTMLBuilder.Append("'/>");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");
                strHTMLBuilder.Append("<tr >");
                strHTMLBuilder.Append("<td width='150px' style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append("Plant/Line<br/>(name/no.)");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='200px' style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["line_name"]) + "(" + Convert.ToString(dtHeading.Rows[0]["location_name"]) + ")");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='100px' style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append("Name:");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='250px' style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["emp_full_name"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='150px' style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append("Personal No.:");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td width='150px' style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["audit_performed_by"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("</tr>");

                strHTMLBuilder.Append("<tr >");
                strHTMLBuilder.Append("<td style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append("Current product<br/>/part-no.");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["product_name"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append("Date:");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["audit_performed_date"]));
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append("Shift:");
                strHTMLBuilder.Append("</td>");
                strHTMLBuilder.Append("<td style='font-weight:normal; font-size:10px; border: 1px solid darkgray; border-collapse:collapse;'>");
                strHTMLBuilder.Append(Convert.ToString(dtHeading.Rows[0]["shift_no"]));
                strHTMLBuilder.Append("</td>");

                strHTMLBuilder.Append("</tr>");

                strHTMLBuilder.Append("</table>");

                output = strHTMLBuilder.ToString();
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
            return output;
        }

        private void convertPDF(string html, string filepath, string filename)
        {
            try
            {
                using (var stream = new MemoryStream())
                {
                    using (var document = new Document())
                    {
                        PdfWriter writer = PdfWriter.GetInstance(document, stream);
                        document.Open();
                        using (var stringReader = new StringReader(html))
                        {
                            XMLWorkerHelper.GetInstance().ParseXHtml(
                                writer, document, stringReader
                            );
                        }
                    }
                    File.WriteAllBytes(string.Concat(filepath, filename), stream.ToArray());
                }


                //using (FileStream fs = new FileStream(Path.Combine(filepath, "test.htm"), FileMode.Create))
                //{
                //    using (StreamWriter w = new StreamWriter(fs, Encoding.UTF8))
                //    {
                //        w.WriteLine(html);
                //    }
                //}

                //var Renderer = new IronPdf.HtmlToPdf();
                //var PDF = Renderer.RenderHTMLFileAsPdf(Path.Combine(filepath, "test.htm"));
                ////var OutputPath = "Invoice.pdf";
                //PDF.SaveAs(string.Concat(filepath, filename));

                //GeneratePdfFromHtml(filepath, filename);

            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
        }

        private void GeneratePdfFromHtml(string filepath, string filename)
        {
            string outputFilename = Path.Combine(filepath, filename);
            string inputFilename = Path.Combine(filepath, "test.htm");

            using (var input = new FileStream(inputFilename, FileMode.Open))
            using (var output = new FileStream(outputFilename, FileMode.Create))
            {
                CreatePdf(filepath, filename, input, output);
            }
        }

        private void CreatePdf(string filepath, string filename, FileStream htmlInput, FileStream pdfOutput)
        {
            Paragraph paragraph;
            try
            {
                using (var document = new Document(PageSize.A4, 30, 30, 30, 30))
                {
                    var writer = PdfWriter.GetInstance(document, pdfOutput);
                    var worker = XMLWorkerHelper.GetInstance();
                    TextReader tr = new StreamReader(htmlInput);
                    document.Open();
                    //document.NewPage();

                    worker.ParseXHtml(writer, document, htmlInput, null, Encoding.UTF8, new UnicodeFontFactory());
                    //if (dsImage != null)
                    //{
                    //    for (int j = 1; j < dsImage.Tables.Count; j++)
                    //    {
                    //        if (dsImage.Tables[j].Rows.Count > 0)
                    //        {
                    //            for (int i = 0; i < dsImage.Tables[j].Rows.Count; i++)
                    //            {
                    //                if (!string.IsNullOrEmpty(Convert.ToString(dsImage.Tables[j].Rows[i]["image_file_name"])))
                    //                {
                    //                    imageURL = string.Empty;
                    //                    paragraph = new Paragraph(Convert.ToString("Question : " + Convert.ToString(dsImage.Tables[j].Rows[i]["display_sequence"])));
                    //                    images = Convert.ToString(dsImage.Tables[j].Rows[i]["image_file_name"]).Split(';');
                    //                    document.Add(paragraph);
                    //                    for (int k = 0; k < images.Length; k++)
                    //                    {
                    //                        //imageURL = Convert.ToString(dsImage.Tables[j].Rows[i]["image_file_name"]);
                    //                        iTextSharp.text.Image jpg = iTextSharp.text.Image.GetInstance(images[k]);
                    //                        jpg.ScaleToFit(140f, 120f);
                    //                        jpg.SpacingBefore = 10f;
                    //                        jpg.SpacingAfter = 1f;
                    //                        jpg.Alignment = Element.ALIGN_LEFT;

                    //                        document.Add(jpg);
                    //                    }
                    //                }

                    //            }
                    //        }
                    //    }
                    //}
                    document.Close();
                }

            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
        }

        public class UnicodeFontFactory : FontFactoryImp
        {
            private static readonly string FontPath = ConfigurationManager.AppSettings["fontpath"].ToString();

            private readonly BaseFont _baseFont;

            public UnicodeFontFactory()
            {
                _baseFont = BaseFont.CreateFont(FontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

            }

            public override Font GetFont(string fontname, string encoding, bool embedded, float size, int style, BaseColor color,
              bool cached)
            {
                return new Font(_baseFont, size, style, color);
            }
        }

        internal List<TaskList> GetTasksFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<TaskList> taskList = new List<TaskList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            TaskList obj = new TaskList();
            try
            {

                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetTasksFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_getOpenTasks, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_region_id, SqlDbType.Int).Value = paramdetails.region_id;
                    command.Parameters.Add(AudireResources.p_country_id, SqlDbType.Int).Value = paramdetails.country_id;
                    command.Parameters.Add(AudireResources.p_location_id, SqlDbType.Int).Value = paramdetails.location_id;
                    command.Parameters.Add(AudireResources.p_line_id, SqlDbType.Int).Value = paramdetails.line_id;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    command.Parameters.Add(AudireResources.auditType_id, SqlDbType.Int).Value = paramdetails.auditType_id;
                    command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = paramdetails.userID;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    taskList = dt.DataTableToList<TaskList>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    taskList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                taskList.Add(obj);
                ErrorLog(ex);
            }

            return taskList;
        }

        internal List<ErrorOutput> SaveAuditReviewToDB(AuditReview paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            DataTable dtReview = new DataTable();
            ErrorOutput obj = new ErrorOutput();
            List<ErrorOutput> outputList = new List<ErrorOutput>();
            Parameters param = new Parameters();
            DataSet ds = new DataSet();
            try
            {

                //JavaScriptSerializer ser = new JavaScriptSerializer();
                //string json = ser.Serialize(paramdetails);
                //TestLog(json, "SaveAuditReviewToDB");
                objOutputDetail = new OutputDetail();
                param.username = paramdetails.username;
                param.encryptedPassword = Encrypt(paramdetails.password);
                param.userID = paramdetails.userID;
                param.deviceID = paramdetails.deviceID;
                objOutputDetail = checkLogin(param);


                if (objOutputDetail.Error_code == 0)
                {
                    foreach (ReviewStatus stat_obj in paramdetails.reviewStatus)
                    {
                        if (stat_obj.review_image_file_name != null && stat_obj.review_image_file_name != "")
                        {
                            var bytes = Convert.FromBase64String(stat_obj.review_image_file_name);
                            MemoryStream stream = new MemoryStream(bytes);
                            stat_obj.review_image_file_name = PostImage(stream, Convert.ToString(paramdetails.audit_id), Convert.ToString(stat_obj.answer_id));
                        }
                    }

                    dtReview = CreateDataTable<ReviewStatus>(paramdetails.reviewStatus);
                    command = new SqlCommand(AudireResources.sp_InsAuditReview, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.audit_id, SqlDbType.Int).Value = paramdetails.audit_id;
                    command.Parameters.Add(AudireResources.p_line_id, SqlDbType.Int).Value = paramdetails.line_id;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = paramdetails.userID;
                    command.Parameters.Add(AudireResources.deviceID, SqlDbType.VarChar, -1).Value = paramdetails.deviceID;
                    command.Parameters.AddWithValue(AudireResources.ReviewTable, dtReview);
                    command.Parameters.Add(AudireResources.l_err_code, SqlDbType.Int).Direction = ParameterDirection.Output;
                    command.Parameters.Add(AudireResources.l_err_message, SqlDbType.VarChar, 100).Direction = ParameterDirection.Output;
                    command.ExecuteNonQuery();

                    obj.err_code = Convert.ToInt32(command.Parameters[AudireResources.l_err_code].Value);
                    obj.err_message = Convert.ToString(command.Parameters[AudireResources.l_err_message].Value);
                    outputList.Add(obj);
                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    outputList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                outputList.Add(obj);
                ErrorLog(ex);
            }

            return outputList;
        }

        internal List<AuditResultOutput> SendReport(Parameters paramdetails)
        {

            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            DataSet ds = new DataSet();
            string filename = string.Empty;
            string filepath = string.Empty;
            List<AuditResultOutput> objList = new List<AuditResultOutput>();
            AuditResultOutput obj = new AuditResultOutput();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "SendReport");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_GetMailDetailsForReport, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.audit_id, SqlDbType.Int).Value = paramdetails.audit_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(ds);
                    EmailDetails objEmail;
                    if (ds != null)
                    {
                        if (ds.Tables.Count > 0)
                        {

                            if (ds.Tables[0].Rows.Count > 0)
                            {

                                DataTable dt = ds.Tables[0];
                                if (!string.IsNullOrEmpty(Convert.ToString(dt.Rows[0]["EmailId"])))
                                {
                                    filename = "Audit_Result_" + Convert.ToString(paramdetails.audit_id) + ".pdf";
                                    filepath = ConfigurationManager.AppSettings["PDF_Folder"].ToString();
                                    objEmail = new EmailDetails();
                                    objEmail.toMailId = Convert.ToString(dt.Rows[0]["EmailId"]);
                                    objEmail.subject = Convert.ToString(dt.Rows[0]["Subject"]);
                                    objEmail.body = Convert.ToString(dt.Rows[0]["Body"]);
                                    objEmail.attachment = Convert.ToString(filepath + filename);
                                    SendMail(objEmail);
                                    TestLog(Convert.ToString(ds.Tables.Count), "Count");
                                    obj.audit_id = paramdetails.audit_id;
                                    obj.audit_number = Convert.ToString(dt.Rows[0]["audit_number"]);
                                    obj.err_code = 0;
                                    obj.err_message = "Audit Report is sent successfully.";
                                }
                                else
                                {
                                    obj.err_code = 201;
                                    obj.err_message = "There is no email id found for respective audit id.";
                                }
                            }
                            if (ds.Tables.Count > 0)
                            {
                                TestLog(Convert.ToString(ds.Tables.Count), "Count");
                                DataTable dtExcel;
                                for (int i = 1; i < ds.Tables.Count; i++)
                                {
                                    TestLog(Convert.ToString(ds.Tables[i].Rows.Count), "Count");
                                    if (ds.Tables[i].Rows.Count > 0)
                                    {
                                        dtExcel = new DataTable();
                                        dtExcel = ds.Tables[i];
                                        filename = Convert.ToString(dtExcel.Rows[0]["File_name"]) + ".csv";
                                        TestLog(Convert.ToString(dtExcel.Rows[0]["File_name"]), "File_name");
                                        filepath = ConfigurationManager.AppSettings["Excel_report"].ToString();
                                        TestLog(filepath, "Excel_report");
                                        objEmail = new EmailDetails();
                                        objEmail.toMailId = Convert.ToString(dtExcel.Rows[0]["to_email_ids"]);
                                        objEmail.subject = Convert.ToString(dtExcel.Rows[0]["Subject"]);
                                        objEmail.body = Convert.ToString(dtExcel.Rows[0]["Body"]);
                                        objEmail.attachment = Convert.ToString(filepath + filename);
                                        SendMail(objEmail);
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        obj.err_code = 201;
                        obj.err_message = "There is no email id found for respective audit id.";
                    }

                }
                else
                {
                    obj.err_code = 201;
                    obj.err_message = "Authentication failed.";
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                ErrorLog(ex);
            }
            objList.Add(obj);
            return objList;
        }

        internal List<AuditTypeList> GetAuditTypeFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<AuditTypeList> auditList = new List<AuditTypeList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            AuditTypeList obj = new AuditTypeList();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetAuditTypeFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_getAuditType, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    auditList = dt.DataTableToList<AuditTypeList>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    auditList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                auditList.Add(obj);
                ErrorLog(ex);
            }

            return auditList;
        }

        internal List<AuditResultOutput> SaveAuditResultToDB(AuditResult paramdetails, string fromfunc)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            DataTable dtAnswer = new DataTable();
            AuditResultOutput obj = new AuditResultOutput();
            List<AuditResultOutput> outputList = new List<AuditResultOutput>();
            Parameters param = new Parameters();
            List<QuestionAnswer> objAnsResults = new List<QuestionAnswer>();
            DataSet ds = new DataSet();
            string filepath = string.Empty;
            string filename = string.Empty;
            try
            {


                objOutputDetail = new OutputDetail();
                param.username = paramdetails.username;
                param.encryptedPassword = Encrypt(paramdetails.password);
                param.userID = paramdetails.userID;
                param.deviceID = paramdetails.deviceID;
                objOutputDetail = checkLogin(param);
                //Stream stream=new MemoryStream ;
                //string audit_id = "test";
                //var bytes;
                if (fromfunc == "SaveAuditResultWeb")
                {
                    foreach (QuestionAnswer quest_obj in paramdetails.questionAnswer)
                    {
                        if (quest_obj.img_content != null && quest_obj.img_content != "")
                        {
                            var bytes = Convert.FromBase64String(quest_obj.img_content);
                            MemoryStream stream = new MemoryStream(bytes);

                            quest_obj.img_content = PostImage(stream, Convert.ToString(paramdetails.audit_id), Convert.ToString(quest_obj.question_id));
                            TestLog(quest_obj.img_content, "Images");
                        }
                    }
                }
                else
                {
                    JavaScriptSerializer ser = new JavaScriptSerializer();
                    string json = ser.Serialize(paramdetails);
                    TestLog(json, "SaveAuditResultToDB");
                }
                if (objOutputDetail.Error_code == 0)
                {
                    //objAnsResults = ser.Deserialize<List<QuestionAnswer>>(Convert.ToString(paramdetails.questionAnswer));
                    dtAnswer = CreateDataTable<QuestionAnswer>(paramdetails.questionAnswer);
                    command = new SqlCommand(AudireResources.sp_InsAnswers, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.audit_id, SqlDbType.Int).Value = paramdetails.audit_id;
                    command.Parameters.Add(AudireResources.p_region_id, SqlDbType.Int).Value = paramdetails.region_id;
                    command.Parameters.Add(AudireResources.p_country_id, SqlDbType.Int).Value = paramdetails.country_id;
                    command.Parameters.Add(AudireResources.p_location_id, SqlDbType.Int).Value = paramdetails.location_id;
                    command.Parameters.Add(AudireResources.p_line_id, SqlDbType.Int).Value = paramdetails.line_id;
                    command.Parameters.Add(AudireResources.p_product_id, SqlDbType.Int).Value = paramdetails.product_id;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = paramdetails.userID;
                    command.Parameters.Add(AudireResources.deviceID, SqlDbType.VarChar, -1).Value = paramdetails.deviceID;
                    command.Parameters.Add(AudireResources.p_shift_no, SqlDbType.Int).Value = paramdetails.shift_no;
                    command.Parameters.Add(AudireResources.auditType_id, SqlDbType.Int).Value = paramdetails.auditType_id;
                    command.Parameters.Add(AudireResources.part_name, SqlDbType.VarChar, -1).Value = paramdetails.part_name;
                    command.Parameters.Add(AudireResources.auditor_comment, SqlDbType.VarChar, -1).Value = paramdetails.Auditor_comment;
                    command.Parameters.Add(AudireResources.IsCompleted, SqlDbType.VarChar, 10).Value = paramdetails.IsCompleted;
                    command.Parameters.AddWithValue(AudireResources.AnswerTable, dtAnswer);
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(ds);
                    if (ds != null)
                    {
                        if (ds.Tables.Count > 0)
                        {
                            if (paramdetails.IsCompleted == "Y")
                            {
                                if (ds.Tables[1] != null)
                                {
                                    if (ds.Tables[1].Rows.Count > 0)
                                    {
                                        filename = CreatePDFForAuditResult(ds.Tables[1]);
                                    }
                                }
                                if (ds.Tables[0].Rows.Count > 0)
                                {
                                    filepath = ConfigurationManager.AppSettings["Audit_report"].ToString();
                                    DataTable dtAuditResult = new DataTable();
                                    dtAuditResult = ds.Tables[0].Copy();
                                    dtAuditResult.Columns.Add("audit_report");
                                    //string  filename = "Audit_Result_" + Convert.ToString(dtAuditResult.Rows[0]["audit_id"]) + ".pdf";
                                    //byte[] pdf = GetFileFromFolder(filename);
                                    if (!string.IsNullOrEmpty(filename))
                                        dtAuditResult.Rows[0]["audit_report"] = string.Concat(filepath, filename);
                                    else
                                        dtAuditResult.Rows[0]["audit_report"] = "";
                                    outputList = dtAuditResult.DataTableToList<AuditResultOutput>();
                                }
                                else
                                {
                                    obj.err_code = 202;
                                    obj.err_message = "Error in output";
                                    outputList.Add(obj);
                                }
                                if (ds.Tables.Count > 2)
                                {
                                    //string to_mail_list = string.Empty;
                                    string Process = string.Empty;
                                    for (int i = 2; i < ds.Tables.Count; i++)
                                    {
                                        if (ds.Tables[i].Rows.Count > 0)
                                        {
                                            TestLog(Convert.ToString(ds.Tables[i].Rows.Count), "Count");
                                            DataTable dtAuditExcel = new DataTable();
                                            dtAuditExcel = ds.Tables[i].Copy();
                                            //to_mail_list = Convert.ToString(dtAuditExcel.Rows[0]["to_email_ids"]);
                                            Process = Convert.ToString(dtAuditExcel.Rows[0]["Process"]);
                                            filepath = ConfigurationManager.AppSettings["Excel_report"].ToString() + "Audit_" + Convert.ToString(ds.Tables[1].Rows[0]["audit_id"]) + "_" + Process;

                                            dtAuditExcel.Columns.Remove("to_email_ids");
                                            dtAuditExcel.Columns.Add("Review_status");
                                            dtAuditExcel.Columns.Add("Review_Comment");

                                            LoadDatatocsv(dtAuditExcel, filepath);


                                        }
                                    }
                                }


                            }
                            else
                            {
                                obj.err_code = 200;
                                obj.err_message = "Audit Details are saved successfully.";
                                outputList.Add(obj);
                            }
                        }
                        else
                        {
                            obj.err_code = 202;
                            obj.err_message = "Error in output";
                            outputList.Add(obj);
                        }
                    }
                    else
                    {
                        obj.err_code = 202;
                        obj.err_message = "Error in output";
                        outputList.Add(obj);
                    }


                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    outputList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                outputList.Add(obj);
                ErrorLog(ex);
            }

            return outputList;
        }

        internal List<AuditResultOutput> SaveAuditResult_mobile(AuditResult paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            DataTable dtAnswer = new DataTable();
            AuditResultOutput obj = new AuditResultOutput();
            List<AuditResultOutput> outputList = new List<AuditResultOutput>();
            Parameters param = new Parameters();
            List<QuestionAnswer> objAnsResults = new List<QuestionAnswer>();
            DataSet ds = new DataSet();
            string filepath = string.Empty;
            string filename = string.Empty;
            try
            {
                objOutputDetail = new OutputDetail();
                param.username = paramdetails.username;
                param.encryptedPassword = Encrypt(paramdetails.password);
                param.userID = paramdetails.userID;
                param.deviceID = paramdetails.deviceID;
                objOutputDetail = checkLogin(param);
                
                    JavaScriptSerializer ser = new JavaScriptSerializer();
                    string json = ser.Serialize(paramdetails);
                    TestLog(json, "SaveAuditResult_mobile");
                
                if (objOutputDetail.Error_code == 0)
                {
                    //objAnsResults = ser.Deserialize<List<QuestionAnswer>>(Convert.ToString(paramdetails.questionAnswer));
                    dtAnswer = CreateDataTable<QuestionAnswer>(paramdetails.questionAnswer);
                    command = new SqlCommand(AudireResources.sp_InsAnswers, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.audit_id, SqlDbType.Int).Value = paramdetails.audit_id;
                    command.Parameters.Add(AudireResources.p_region_id, SqlDbType.Int).Value = paramdetails.region_id;
                    command.Parameters.Add(AudireResources.p_country_id, SqlDbType.Int).Value = paramdetails.country_id;
                    command.Parameters.Add(AudireResources.p_location_id, SqlDbType.Int).Value = paramdetails.location_id;
                    command.Parameters.Add(AudireResources.p_line_id, SqlDbType.Int).Value = paramdetails.line_id;
                    command.Parameters.Add(AudireResources.p_product_id, SqlDbType.Int).Value = paramdetails.product_id;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = paramdetails.userID;
                    command.Parameters.Add(AudireResources.deviceID, SqlDbType.VarChar, -1).Value = paramdetails.deviceID;
                    command.Parameters.Add(AudireResources.p_shift_no, SqlDbType.Int).Value = paramdetails.shift_no;
                    command.Parameters.Add(AudireResources.auditType_id, SqlDbType.Int).Value = paramdetails.auditType_id;
                    command.Parameters.Add(AudireResources.part_name, SqlDbType.VarChar, -1).Value = paramdetails.part_name;
                    command.Parameters.Add(AudireResources.auditor_comment, SqlDbType.VarChar, -1).Value = paramdetails.auditor_comment;
                    command.Parameters.Add(AudireResources.IsCompleted, SqlDbType.VarChar, 10).Value = paramdetails.IsCompleted;
                    command.Parameters.AddWithValue(AudireResources.AnswerTable, dtAnswer);
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(ds);
                    if (ds != null)
                    {
                        if (ds.Tables.Count > 0)
                        {
                            if (paramdetails.IsCompleted == "Y")
                            {
                                if (ds.Tables[1] != null)
                            {
                                if (ds.Tables[1].Rows.Count > 0)
                                {
                                    filename = CreatePDFForAuditResult(ds.Tables[1]);
                                }
                            }
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                filepath = ConfigurationManager.AppSettings["Audit_report"].ToString();
                                DataTable dtAuditResult = new DataTable();
                                dtAuditResult = ds.Tables[0].Copy();
                                dtAuditResult.Columns.Add("audit_report");
                                //string  filename = "Audit_Result_" + Convert.ToString(dtAuditResult.Rows[0]["audit_id"]) + ".pdf";
                                //byte[] pdf = GetFileFromFolder(filename);
                                if (!string.IsNullOrEmpty(filename))
                                    dtAuditResult.Rows[0]["audit_report"] = string.Concat(filepath, filename);
                                else
                                    dtAuditResult.Rows[0]["audit_report"] = "";
                                outputList = dtAuditResult.DataTableToList<AuditResultOutput>();
                            }
                            else
                            {
                                obj.err_code = 202;
                                obj.err_message = "Error in output";
                                outputList.Add(obj);
                            }
                            if (ds.Tables.Count > 2)
                            {
                                //string to_mail_list = string.Empty;
                                string Process = string.Empty;
                                for (int i = 2; i < ds.Tables.Count; i++)
                                {
                                    if (ds.Tables[i].Rows.Count > 0)
                                    {
                                        TestLog(Convert.ToString(ds.Tables[i].Rows.Count), "Count");
                                        DataTable dtAuditExcel = new DataTable();
                                        dtAuditExcel = ds.Tables[i].Copy();
                                        //to_mail_list = Convert.ToString(dtAuditExcel.Rows[0]["to_email_ids"]);
                                        Process = Convert.ToString(dtAuditExcel.Rows[0]["Process"]);
                                        filepath = ConfigurationManager.AppSettings["Excel_report"].ToString() + "Audit_" + Convert.ToString(ds.Tables[1].Rows[0]["audit_id"]) + "_" + Process;

                                        dtAuditExcel.Columns.Remove("to_email_ids");
                                        dtAuditExcel.Columns.Add("Review_status");
                                        dtAuditExcel.Columns.Add("Review_Comment");

                                        LoadDatatocsv(dtAuditExcel, filepath);


                                    }
                                }
                            }

                            }
                            else
                            {
                                obj.err_code = 200;
                                obj.err_message = "Audit Details are saved successfully.";
                                outputList.Add(obj);
                            }
                        }
                        else
                        {
                            obj.err_code = 202;
                            obj.err_message = "Error in output";
                            outputList.Add(obj);
                        }
                    }
                    else
                    {
                        obj.err_code = 202;
                        obj.err_message = "Error in output";
                        outputList.Add(obj);
                    }


                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    outputList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                outputList.Add(obj);
                ErrorLog(ex);
            }

            return outputList;
        }

        public string PostImage(MemoryStream stream, string audit_id, string question_id)
        {

            csCommonFunctions objComm = new csCommonFunctions();
            ImageContent objImage = new ImageContent();
            string output = string.Empty;
            System.Drawing.Image image;
            try
            {
                //MultipartParser parser = new MultipartParser(stream);
                string filename = audit_id + "_" + question_id;
                objImage.audit_id = audit_id;
                objComm.TestLog("audit_id : " + objImage.audit_id + " : " + filename, "POSTIMAGE");
                string pathString = ConfigurationManager.AppSettings["ImageURL"].ToString() + objImage.audit_id;
                System.IO.Directory.CreateDirectory(pathString);
                //using (FileStream writer = new FileStream(pathString + "/" + parser.Filename + "." + System.Drawing.Imaging.ImageFormat.Jpeg, FileMode.OpenOrCreate))
                //{
                //    writer.Write(parser.FileContents, 0, parser.FileContents.Length);
                //}
                image = System.Drawing.Image.FromStream(stream);
                image.Save(pathString + "/" + filename + "." + System.Drawing.Imaging.ImageFormat.Jpeg);
                output = Convert.ToString(ConfigurationManager.AppSettings["PublishedImageURL"]) + "/" + objImage.audit_id + "/" + filename + "." + System.Drawing.Imaging.ImageFormat.Jpeg;
                objComm.TestLog(output, "PostImage");
                return output;
            }
            catch (Exception ex)
            {

                objComm.ErrorLog(ex);
                return output;
            }

        }

        public static string Base64Encode(string plainText)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
        }
        public static string Base64Decode(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }

        internal List<PartList> GetPartsForProductFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<PartList> productList = new List<PartList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            PartList obj = new PartList();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetPartsForProductFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_getPartForProduct, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.@auditType_id, SqlDbType.Int).Value = paramdetails.auditType_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    if (dt != null)
                    {
                        if (dt.Rows.Count > 0)
                        {
                            productList = dt.DataTableToList<PartList>();
                        }
                    }
                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    productList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                productList.Add(obj);
                ErrorLog(ex);
            }

            return productList;
        }

        internal List<URLOutput> GetDashboardURLcs(Parameters paramdetails)
        {
            //SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            //SqlCommand command;
            List<URLOutput> objList = new List<URLOutput>();
            URLOutput obj = new URLOutput();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetDashboardURLcs");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    obj.url = Convert.ToString(ConfigurationManager.AppSettings["DashboardURL"]) + paramdetails.userID;
                    objList.Add(obj);
                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    objList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                objList.Add(obj);
                ErrorLog(ex);
            }

            return objList;
        }

        internal List<URLOutput> GetBulkQRCodesURLcs(Parameters paramdetails)
        {
            List<URLOutput> objList = new List<URLOutput>();
            URLOutput obj = new URLOutput();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetBulkQRCodesURLcs");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    obj.url = Convert.ToString(ConfigurationManager.AppSettings["QRCodeURL"]) + paramdetails.userID;
                    objList.Add(obj);
                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    objList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                objList.Add(obj);
                ErrorLog(ex);
            }

            return objList;
        }

        internal List<ErrorOutput> SaveImagesForPerformAuditToDB(Parameters paramdetails)
        {
            List<ErrorOutput> outputList = new List<ErrorOutput>();
            ErrorOutput obj = new ErrorOutput();
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            Parameters param = new Parameters();
            DataTable dtImage = new DataTable();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "SaveImagesForPerformAuditToDB");

                objOutputDetail = new OutputDetail();
                param.username = paramdetails.username;
                param.encryptedPassword = Encrypt(paramdetails.password);
                param.userID = paramdetails.userID;
                param.deviceID = paramdetails.deviceID;
                objOutputDetail = checkLogin(param);
                if (objOutputDetail.Error_code == 0)
                {
                    dtImage = CreateDataTable<ImageDetails>(paramdetails.imgDetails);
                    command = new SqlCommand(AudireResources.sp_SaveAuditImages, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue(AudireResources.AnswerTable, dtImage);
                    int count = Convert.ToInt32(command.ExecuteNonQuery());
                    if (count > 0)
                    {
                        obj.err_code = 200;
                        obj.err_message = Convert.ToString(count) + " records updated successfully.";
                        outputList.Add(obj);
                    }
                    else
                    {
                        obj.err_code = 200;
                        obj.err_message = "No record updated.";
                        outputList.Add(obj);
                    }

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    outputList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                outputList.Add(obj);
                ErrorLog(ex);
            }

            return outputList;
        }

        internal List<ErrorOutput> SaveImagesForOpenTaskToDB(Parameters paramdetails)
        {
            List<ErrorOutput> outputList = new List<ErrorOutput>();
            ErrorOutput obj = new ErrorOutput();
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            Parameters param = new Parameters();
            DataTable dtImage = new DataTable();
            try
            {
                objOutputDetail = new OutputDetail();
                param.username = paramdetails.username;
                param.encryptedPassword = Encrypt(paramdetails.password);
                param.userID = paramdetails.userID;
                param.deviceID = paramdetails.deviceID;
                objOutputDetail = checkLogin(param);
                if (objOutputDetail.Error_code == 0)
                {
                    dtImage = CreateDataTable<ImageDetails>(paramdetails.imgDetails);
                    command = new SqlCommand(AudireResources.sp_SaveReviewImages, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue(AudireResources.AnswerTable, dtImage);
                    int count = Convert.ToInt32(command.ExecuteNonQuery());
                    if (count > 0)
                    {
                        obj.err_code = 200;
                        obj.err_message = Convert.ToString(count) + " review records updated successfully.";
                        outputList.Add(obj);
                    }
                    else
                    {
                        obj.err_code = 200;
                        obj.err_message = "No review record updated.";
                        outputList.Add(obj);
                    }

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    outputList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                outputList.Add(obj);
                ErrorLog(ex);
            }

            return outputList;
        }

        //public void CreateWorkbook(DataTable dt, String path)
        //{
        //    int rowindex = 0;
        //    int columnindex = 0;
        //    try
        //    {

        //        Microsoft.Office.Interop.Excel.Application wapp = new Microsoft.Office.Interop.Excel.Application();
        //        Microsoft.Office.Interop.Excel.Worksheet wsheet;
        //        Microsoft.Office.Interop.Excel.Workbook wbook;

        //        wapp.Visible = false;

        //        wbook = wapp.Workbooks.Add(true);
        //        wsheet = (Microsoft.Office.Interop.Excel.Worksheet)wbook.ActiveSheet;


        //        try
        //        {
        //            for (int i = 0; i < dt.Columns.Count; i++)
        //            {
        //                wsheet.Cells[1, i + 1] = dt.Columns[i].ColumnName;

        //            }

        //            foreach (DataRow row in dt.Rows)
        //            {
        //                rowindex++;
        //                columnindex = 0;
        //                foreach (DataColumn col in dt.Columns)
        //                {
        //                    columnindex++;
        //                    wsheet.Cells[rowindex + 1, columnindex] = row[col.ColumnName];
        //                }
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            ErrorLog(ex);
        //        }
        //        wapp.UserControl = true;

        //        wbook.SaveAs(path, Microsoft.Office.Interop.Excel.XlFileFormat.xlWorkbookNormal, Type.Missing, Type.Missing,
        //        false, false, Microsoft.Office.Interop.Excel.XlSaveAsAccessMode.xlNoChange,
        //        Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);
        //        wbook.Close(null, null, null);

        //    }
        //    catch (Exception ex)
        //    {
        //        ErrorLog(ex);
        //    }
        //}

        public static void LoadDatatocsv(DataTable dt, string filepath)
        {
            try
            {
                StringBuilder sb = new StringBuilder();

                string[] columnNames = dt.Columns.Cast<DataColumn>().
                                                  Select(column => column.ColumnName).
                                                  ToArray();
                sb.AppendLine(string.Join(",", columnNames));

                foreach (DataRow row in dt.Rows)
                {
                    string[] fields = row.ItemArray.Select(field => field.ToString()).
                                                    ToArray();
                    sb.AppendLine(string.Join(",", fields));
                }

                File.WriteAllText(filepath + ".csv", sb.ToString());
            }
            catch (Exception)
            {

                throw;
            }
        }

        internal List<ErrorOutput> UploadBulkReviewToDB(BulkReview objReview)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            DataTable dtReview = new DataTable();
            ErrorOutput obj = new ErrorOutput();
            List<ErrorOutput> outputList = new List<ErrorOutput>();
            Parameters param = new Parameters();
            List<QuestionAnswer> objAnsResults = new List<QuestionAnswer>();
            DataSet ds = new DataSet();
            try
            {
                dtReview = CreateDataTable<BulkReviewList>(objReview.reviewObj);
                command = new SqlCommand(AudireResources.sp_uploadBulkAuditReview, connection);
                connection.Open();
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = objReview.userID;
                command.Parameters.Add(AudireResources.deviceID, SqlDbType.VarChar, -1).Value = objReview.deviceID;
                command.Parameters.AddWithValue(AudireResources.ReviewTable, dtReview);
                command.Parameters.Add(AudireResources.l_err_code, SqlDbType.Int);
                command.Parameters[AudireResources.l_err_code].Direction = ParameterDirection.Output;
                command.Parameters.Add(AudireResources.l_err_message, SqlDbType.VarChar, -1);
                command.Parameters[AudireResources.l_err_message].Direction = ParameterDirection.Output;
                int i = command.ExecuteNonQuery();
                obj.err_code = Convert.ToInt32(command.Parameters[AudireResources.l_err_code].Value);
                obj.err_message = Convert.ToString(command.Parameters[AudireResources.l_err_message].Value);
                outputList.Add(obj);
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = ex.Message;
                outputList.Add(obj);
                ErrorLog(ex);
            }

            return outputList;
        }


        public List<ErrorOutput> ForgotPassword(Parameters param)
        {
            DataTable dtUser = checkUsername(param);
            ErrorOutput obj = new ErrorOutput();
            List<ErrorOutput> objList = new List<ErrorOutput>();
            try
            {
                if (dtUser.Rows.Count > 0)
                {
                    string password = CreateRandomPassword();
                    param.password = Passwordencryption(MD5Encrypt(password));
                    int flag = ResetPassword(param);
                    if (flag > 0)
                    {
                        EmailDetails objEmail = new EmailDetails();
                        objEmail.toMailId = Convert.ToString(dtUser.Rows[0]["email_id"]);

                        objEmail.subject = "Audire Password Created";//Subject for your request
                        string link = "<a href=\" " + Convert.ToString(ConfigurationManager.AppSettings["AppPath"]) + "\">login</a>";
                        objEmail.body = " <br/><br/>New Credentials as below: <br/> Username: " + param.username + "<br/>Password: " + password + "<br/>Click here to " + link + "<br/><br/>" + "From" + "<br/>" + "IT Team - Audire";
                        SendMail(objEmail);
                        obj.err_code = 200;
                        obj.err_message = "Password is created and sent to your email id.";
                        objList.Add(obj);
                    }
                    else
                    {
                        obj.err_code = 203;
                        obj.err_message = "There is some issue in generating password. Please contact administrator.";
                        objList.Add(obj);
                    }
                }
                else
                {
                    obj.err_code = 202;
                    obj.err_message = "Username is incorrect/invalid.";
                    objList.Add(obj);

                }

            }
            catch (Exception ex)
            {
                obj.err_code = 210;
                obj.err_message = ex.Message;
                objList.Add(obj);
                ErrorLog(ex);
            }
            return objList;
        }


        public static string CreateRandomPassword()
        {
            int passwordLength = 8;
            string allowedChars = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789!@$?_-";
            char[] chars = new char[passwordLength];
            Random rd = new Random();

            for (int i = 0; i < passwordLength; i++)
            {
                chars[i] = allowedChars[rd.Next(0, allowedChars.Length)];
            }

            return new string(chars);
        }
        public static string SHA1Passwordencryption(string password)
        {
            //create new instance of md5
            MD5 md5 = MD5.Create();

            //convert the input text to array of bytes
            byte[] hashData = md5.ComputeHash(Encoding.Default.GetBytes(password));

            //create new instance of StringBuilder to save hashed data
            StringBuilder returnValue = new StringBuilder();

            //loop for each byte and add it to StringBuilder
            for (int i = 0; i < hashData.Length; i++)
            {
                returnValue.Append(hashData[i].ToString());
            }

            // return hexadecimal string
            return returnValue.ToString();
        }

        public static string MD5Encrypt(string text)
        {
            MD5 md5 = new MD5CryptoServiceProvider();
            StringBuilder strBuilder = new StringBuilder();

            //compute hash from the bytes of text  
            md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));

            //get hash result after compute it  
            byte[] result = md5.Hash;


            for (int i = 0; i < result.Length; i++)
            {
                //change it into 2 hexadecimal digits  
                //for each byte  
                strBuilder.Append(result[i].ToString("x2"));
            }
            return strBuilder.ToString();
        }

        public static string Passwordencryption(string password)
        {
            string returnValue = string.Empty;

            string EncryptionKey = "KNS_Audire";
            byte[] clearBytes = Encoding.Unicode.GetBytes(password);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    returnValue = Convert.ToBase64String(ms.ToArray());
                }
            }
            return returnValue;
        }

        private void Bindchart(DataTable ChartData)
        {
            try
            {
                if (ChartData.Rows.Count > 0)
                {
                    string[] XPointMember1 = new string[ChartData.Rows.Count];
                    int[] YPointMember1 = new int[ChartData.Rows.Count];

                    for (int count = 0; count < ChartData.Rows.Count; count++)
                    {
                        //storing Values for X axis  
                        XPointMember1[count] = Convert.ToString(ChartData.Rows[count]["section_name"]);
                        //storing values for Y Axis  
                        YPointMember1[count] = Convert.ToInt32(ChartData.Rows[count]["score"]);
                        //ChartPerSection.Series[0].Name = column.ColumnName;

                    }
                    Chart Chart2 = new Chart();
                    Series series1 = new Series();
                    Chart2.Series.Add(series1);
                    Chart2.Series[0].Points.DataBindXY(XPointMember1, YPointMember1);
                    for (int i = 0; i < Chart2.Series[0].Points.Count; i++)
                    {
                        Chart2.Series[0].Points[i].LabelBackColor = Chart2.Series[0].Points[i].YValues[0] <= 60 ? System.Drawing.Color.Red : Chart2.Series[0].Points[i].YValues[0] < 80 ? System.Drawing.Color.Yellow : System.Drawing.Color.Green;
                    }
                    Chart2.Series[0].ChartType = SeriesChartType.Radar;
                    Chart2.Series[0]["RadarDrawingStyle"] = "Line";
                    Chart2.Series[0]["AreaDrawingStyle"] = "Polygon";
                    Chart2.Series[0].Color = System.Drawing.Color.Blue;
                    Chart2.Series[0].Font = new System.Drawing.Font(System.Drawing.FontFamily.GenericMonospace, 30f, System.Drawing.FontStyle.Bold);
                    //Title title = new System.Web.UI.DataVisualization.Charting.Title();
                    //Chart2.Titles.Add(title);
                    //Chart2.Titles[0].Text = "Audit Score";
                    Chart2.Series[0].IsValueShownAsLabel = true;
                    ChartArea ch1 = new ChartArea();
                    Chart2.ChartAreas.Add(ch1);
                    Chart2.ChartAreas[0].AxisY.MajorGrid.LineWidth = 0;
                    //Chart2.ChartAreas[0].AxisY.TitleFont = new System.Drawing.Font("Consolas", 20f);
                    Chart2.ChartAreas[0].AxisX.LabelStyle.Font = new System.Drawing.Font("Consolas", 30f, System.Drawing.FontStyle.Bold);
                    //Chart2.ChartAreas[0].AxisX.Interval = 1;
                    //Chart2.ChartAreas[0].AxisY.Interval = 25;
                    Chart2.Series[0].LabelFormat = "{0} %";
                    Chart2.Series[0].LabelForeColor = System.Drawing.Color.Black;
                    //if (Convert.ToInt32(Chart2.Series[0].Label) < 60)
                    //{
                    //  Chart2.Series[0].LabelBackColor = System.Drawing.Color.Yellow;
                    //}
                    //else
                    //{
                    //    Chart2.Series[0].LabelBackColor = System.Drawing.Color.Red;
                    //}
                    Chart2.Series[0].LabelBorderWidth = 20;
                    //Chart2.ChartAreas[0].AxisY.LabelStyle.Format = "{0} %";
                    //Chart2.ChartAreas[0].AxisY.Maximum = 100;
                    Chart2.Height = 800;
                    Chart2.Width = 2000;
                    Chart2.SaveImage(Convert.ToString(ConfigurationManager.AppSettings["ChartImageFile"]), ChartImageFormat.Png);
                }
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }

        }

        internal List<LandingScreenDetail> GetLandingScreenDataFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<LandingScreenDetail> objList = new List<LandingScreenDetail>();
            List<ModuleScore> objscoreList = new List<ModuleScore>();
            List<UpcomingPlan> objplanList = new List<UpcomingPlan>();
            SqlCommand command;
            DataSet ds = new DataSet();
            LandingScreenDetail obj = new LandingScreenDetail();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetLandingScreenDataFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_getLandingScreenDetail, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = paramdetails.userID;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(ds);
                    if (ds != null)
                    {
                        if (ds.Tables.Count > 0)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                objscoreList = ds.Tables[0].DataTableToList<ModuleScore>();
                            }
                            else
                            {
                                ModuleScore objscore = new ModuleScore();
                                objscore.err_code=404;
                                objscore.err_message="No audit performed so far for score.";
                                objscoreList.Add(objscore);
                            }
                            if (ds.Tables[1].Rows.Count > 0)
                            {
                                objplanList = ds.Tables[1].DataTableToList<UpcomingPlan>();
                            }
                            else
                            {
                                UpcomingPlan objplan = new UpcomingPlan();
                                objplan.err_code = 404;
                                objplan.err_message = "No upcoming plan available.";
                                objplanList.Add(objplan);
                            }
                            obj.score = objscoreList;
                            obj.upcomingplans = objplanList;
                            obj.err_code = 200;
                            obj.err_message = "";
                            objList.Add(obj);
                        }
                        else
                        {
                            obj.err_code = 404;
                            obj.err_message = "No data available";
                            objList.Add(obj);
                        }
                    }
                    else
                    {
                        obj.err_code = 404;
                        obj.err_message = "No data available";
                        objList.Add(obj);
                    }
                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    objList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = "There some error in fetching data.";
                objList.Add(obj);
                ErrorLog(ex);
            }

            return objList;
        }

        internal List<AuditList> GetMyAuditsFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<AuditList> auditList = new List<AuditList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            AuditList obj = new AuditList();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetMyAuditsFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_getMyAuditDetails, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = paramdetails.userID;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    auditList = dt.DataTableToList<AuditList>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    auditList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = "There is error in fetching the data.";
                auditList.Add(obj);
                ErrorLog(ex);
            }

            return auditList;
        }

        internal List<CalendarDashboard> GetCalendarDashboardFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<CalendarDashboard> objList = new List<CalendarDashboard>();
            List<CalendarPlan> objcalPlan = new List<CalendarPlan>();
            List<CalendarReport> objplanList = new List<CalendarReport>();
            SqlCommand command;
            DataSet ds = new DataSet();
            CalendarDashboard obj = new CalendarDashboard();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetCalendarDashboardFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_getCalendarDashboard, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = paramdetails.userID;
                    command.Parameters.Add(AudireResources.month, SqlDbType.Int).Value = paramdetails.Month;
                    command.Parameters.Add(AudireResources.year, SqlDbType.Int).Value = paramdetails.Year;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(ds);
                    if (ds != null)
                    {
                        if (ds.Tables.Count > 0)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                objcalPlan = ds.Tables[0].DataTableToList<CalendarPlan>();
                            }
                            else
                            {
                                CalendarPlan objplan = new CalendarPlan();
                                objplan.err_code = 404;
                                objplan.err_message = "No audit planned.";
                                objcalPlan.Add(objplan);
                            }
                            if (ds.Tables[1].Rows.Count > 0)
                            {
                                objplanList = ds.Tables[1].DataTableToList<CalendarReport>();
                            }
                            else
                            {
                                CalendarReport objreport = new CalendarReport();
                                objreport.err_code = 404;
                                objreport.err_message = "No record.";
                                objplanList.Add(objreport);
                            }
                            obj.calendarPlan = objcalPlan;
                            obj.calendarReport = objplanList;
                            obj.err_code = 200;
                            obj.err_message = "";
                            objList.Add(obj);
                        }
                        else
                        {
                            obj.err_code = 404;
                            obj.err_message = "No data available";
                            objList.Add(obj);
                        }
                    }
                    else
                    {
                        obj.err_code = 404;
                        obj.err_message = "No data available";
                        objList.Add(obj);
                    }
                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    objList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = "There some error in fetching data.";
                objList.Add(obj);
                ErrorLog(ex);
            }

            return objList;
        }

        internal List<ErrorOutput> SaveAuditPlanToDB(PlanParameters objparam)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            DataTable dtReview = new DataTable();
            ErrorOutput obj = new ErrorOutput();
            List<ErrorOutput> outputList = new List<ErrorOutput>();
            Parameters param = new Parameters();
            List<QuestionAnswer> objAnsResults = new List<QuestionAnswer>();
            DataSet ds = new DataSet();
            Parameters paramdetails = new Parameters();
            try
            {
                paramdetails.userID = Convert.ToString(objparam.user_id);
                paramdetails.deviceID = objparam.deviceID;
                paramdetails.password = objparam.password;
                paramdetails.username = objparam.username;
                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    
                    command = new SqlCommand(AudireResources.sp_InsAuditPlan, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_audit_plan_id, SqlDbType.Int).Value = objparam.audit_plan_id;
                    command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = objparam.user_id;
                    command.Parameters.Add(AudireResources.p_planned_date, SqlDbType.Date).Value = Convert.ToDateTime(objparam.plan_start_date);
                    command.Parameters.Add(AudireResources.p_planned_date_end, SqlDbType.Date).Value = Convert.ToDateTime(objparam.plan_end_date);
                    command.Parameters.Add(AudireResources.l_location_id, SqlDbType.Int).Value = objparam.location_id;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = objparam.module_id;
                    command.Parameters.Add(AudireResources.audit_type_id, SqlDbType.Int).Value = objparam.auditType_id;

                    command.Parameters.Add(AudireResources.l_invite_to_list, SqlDbType.VarChar,-1);
                    command.Parameters[AudireResources.l_invite_to_list].Direction = ParameterDirection.Output;
                    command.Parameters.Add(AudireResources.l_err_code, SqlDbType.Int);
                    command.Parameters[AudireResources.l_err_code].Direction = ParameterDirection.Output;
                    command.Parameters.Add(AudireResources.l_err_message, SqlDbType.VarChar, 100);
                    command.Parameters[AudireResources.l_err_message].Direction = ParameterDirection.Output;
                    int i = command.ExecuteNonQuery();
                    obj.err_code = Convert.ToInt32(command.Parameters[AudireResources.l_err_code].Value);
                    obj.err_message = Convert.ToString(command.Parameters[AudireResources.l_err_message].Value);
                    outputList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = "There is some issue in updating audit plan.";
                outputList.Add(obj);
                ErrorLog(ex);
            }

            return outputList;
        }
        internal List<ErrorOutput> SaveUserDetailsToDB(Parameters param)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            SqlCommand command;
            ErrorOutput obj = new ErrorOutput();
            List<ErrorOutput> outputList = new List<ErrorOutput>();
            try
            {
                objOutputDetail = new OutputDetail();
                param.encryptedPassword = Encrypt(param.password);
                objOutputDetail = checkLogin(param);
                if (objOutputDetail.Error_code == 0)
                {

                    command = new SqlCommand(AudireResources.sp_saveProfilePic, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = param.userID;
                    command.Parameters.Add(AudireResources.imq_url, SqlDbType.VarChar, -1).Value = param.profile_url;;
                    
                    command.Parameters.Add(AudireResources.l_err_code, SqlDbType.Int);
                    command.Parameters[AudireResources.l_err_code].Direction = ParameterDirection.Output;
                    command.Parameters.Add(AudireResources.l_err_message, SqlDbType.VarChar, 100);
                    command.Parameters[AudireResources.l_err_message].Direction = ParameterDirection.Output;
                    int i = command.ExecuteNonQuery();
                    obj.err_code = Convert.ToInt32(command.Parameters[AudireResources.l_err_code].Value);
                    obj.err_message = Convert.ToString(command.Parameters[AudireResources.l_err_message].Value);
                    outputList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = "There is some issue in updating profile picture.";
                outputList.Add(obj);
                ErrorLog(ex);
            }

            return outputList;
        }

        internal List<EmployeeList> GetEmployeeListFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<EmployeeList> empList = new List<EmployeeList>();
            SqlCommand command;
            DataTable dt = new DataTable();
            EmployeeList obj = new EmployeeList();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetEmployeeListFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_getEmployeeList, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_location_id, SqlDbType.Int).Value = paramdetails.location_id;
                    command.Parameters.Add(AudireResources.module_id, SqlDbType.Int).Value = paramdetails.module_id;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    empList = dt.DataTableToList<EmployeeList>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    empList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = "There is error in fetching the data.";
                empList.Add(obj);
                ErrorLog(ex);
            }

            return empList;
        }


        internal List<ProfileScore> GetProfileScoreFromDB(Parameters paramdetails)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["csAudire"].ToString());
            List<ProfileScore> scoreList = new List<ProfileScore>();
            SqlCommand command;
            DataTable dt = new DataTable();
            ProfileScore obj = new ProfileScore();
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                string json = ser.Serialize(paramdetails);
                TestLog(json, "GetProfileScoreFromDB");

                objOutputDetail = new OutputDetail();
                paramdetails.encryptedPassword = Encrypt(paramdetails.password);
                objOutputDetail = checkLogin(paramdetails);
                if (objOutputDetail.Error_code == 0)
                {
                    command = new SqlCommand(AudireResources.sp_getProfileScore, connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(AudireResources.p_user_id, SqlDbType.Int).Value = paramdetails.userID;
                    SqlDataAdapter sqlDA = new SqlDataAdapter(command);
                    sqlDA.Fill(dt);
                    scoreList = dt.DataTableToList<ProfileScore>();

                }
                else
                {
                    obj.err_code = objOutputDetail.Error_code;
                    obj.err_message = objOutputDetail.err_message;
                    scoreList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                obj.err_code = 202;
                obj.err_message = "There is error in fetching the data.";
                scoreList.Add(obj);
                ErrorLog(ex);
            }

            return scoreList;
        }
    }
}
