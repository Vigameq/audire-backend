using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace AudireWCF
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select Service1.svc or Service1.svc.cs at the Solution Explorer and start debugging.
    public class AudireServices : IAudireService
    {

        public List<ModuleList> GetModuleList(Parameters paramdetails) 
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ModuleList> obj = new List<ModuleList>();
            try
            {
                obj = objComm.GetModuleListFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }
        
        public List<UserDetails> AuthenticateUser(Parameters paramdetails)
        {
            List<UserDetails> obj = new List<UserDetails>();
            csCommonFunctions objComm = new csCommonFunctions();
            try
            {
                obj = objComm.GetUserDetailsFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<RegionList> GetRegionList(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<RegionList> obj = new List<RegionList>();
            try
            {
                obj = objComm.GetRegionListFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<CountryList> GetCountryList(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<CountryList> obj = new List<CountryList>();
            try
            {
                obj = objComm.GetCountryListFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<LocationList> GetLocationList(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<LocationList> obj = new List<LocationList>();
            try
            {
                obj = objComm.GetLocationListFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<LineList> GetLineList(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<LineList> obj = new List<LineList>();
            try
            {
                obj = objComm.GetLineListFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<AuditPlanList> GetAuditPlanList(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<AuditPlanList> obj = new List<AuditPlanList>();
            try
            {
                obj = objComm.GetAuditPlanListFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<QuestionList> GetQuestionList(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<QuestionList> obj = new List<QuestionList>();
            try
            {
                obj = objComm.GetQuestionListFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<QuestionsWithSection> GetQuestionListForC(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<QuestionsWithSection> obj = new List<QuestionsWithSection>();
            try
            {
                obj = objComm.GetQuestionListForCFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<ProductList>  GetProductListBasedOnLine(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ProductList> obj = new List<ProductList>();
            try
            {
                obj = objComm.GetProductListFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<ProcessList> GetProcessList(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ProcessList> obj = new List<ProcessList>();
            try
            {
                obj = objComm.GetProcessListFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<AuditResultOutput> SaveAuditResult(AuditResult paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<AuditResultOutput> obj = new List<AuditResultOutput>();
            try
            {
                obj = objComm.SaveAuditResult_mobile(paramdetails);
                //if (paramdetails.IsCompleted == "Y")
                //{
                    Parameters param = new Parameters();
                    param.audit_id = obj[0].audit_id;
                    param.password = paramdetails.password;
                    param.userID = paramdetails.userID;
                    param.username = paramdetails.username;
                    param.deviceID = paramdetails.deviceID;
                    obj = objComm.SendReport(param);
                //}
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }
            return obj;
        }

        public List<AuditResultOutput> SaveAuditResultWeb(Parameters filename)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<AuditResultOutput> obj = new List<AuditResultOutput>();
            try
            {
                objComm.TestLog(filename.filename, "SaveAuditResultWeb");
                int len = filename.filename.LastIndexOf('.');
                objComm.TestLog(Convert.ToString(len), "SaveAuditResultWeb");
                string audit_id = filename.filename.Substring(0, len);
                objComm.TestLog(filename.filename, "SaveAuditResultWeb");

                string path = ConfigurationManager.AppSettings["Json_filepath"].ToString() + filename.filename;
                objComm.TestLog(filename.filename, "SaveAuditResultWeb");
                //string path = @"G:\\BitBucket\\Audire\\Audire_App\\Audire_MVC\\Audire_MVC\\Data\\test.json";
                string text = System.IO.File.ReadAllText(path);
                AuditResult paramdetails = JSONHelper.JsonDeserialize<AuditResult>(text);
                objComm.TestLog(paramdetails.username, "SaveAuditResultWeb");
                paramdetails.audit_id = Convert.ToInt32(audit_id);
                objComm.TestLog(Convert.ToString(paramdetails.audit_id), "SaveAuditResultWeb");
                //MultipartParser parser = new MultipartParser(stream);
                //if (parser.Success)
                //{
                //    // Save the file
                //    //SaveFile(parser.Filename, parser.ContentType, parser.FileContents);

                //}
                obj = objComm.SaveAuditResultToDB(paramdetails, "SaveAuditResultWeb");
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<ErrorOutput> SaveAuditReviewWeb(Parameters filename)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ErrorOutput> obj = new List<ErrorOutput>();
            try
            {
                objComm.TestLog(filename.filename, "SaveAuditReviewWeb");
                int len = filename.filename.LastIndexOf('_');
                objComm.TestLog(Convert.ToString(len), "SaveAuditReviewWeb");
                string audit_id = filename.filename.Substring(0, len);
                objComm.TestLog(filename.filename, "SaveAuditReviewWeb");

                string path = ConfigurationManager.AppSettings["Json_filepath"].ToString() + filename.filename;
                objComm.TestLog(filename.filename, "SaveAuditReviewWeb");
                //string path = @"G:\\BitBucket\\Audire\\Audire_App\\Audire_MVC\\Audire_MVC\\Data\\test.json";
                string text = System.IO.File.ReadAllText(path);
                AuditReview paramdetails = JSONHelper.JsonDeserialize<AuditReview>(text);
                objComm.TestLog(paramdetails.username, "SaveAuditReviewWeb");
                paramdetails.audit_id = Convert.ToInt32(audit_id);
                objComm.TestLog(Convert.ToString(paramdetails.audit_id), "SaveAuditReviewWeb");
                obj = objComm.SaveAuditReviewToDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }
        public Stream RetrieveAuditResultFile(Parameters param)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            string filename = string.Empty;
            string filepath = string.Empty;
            string path = string.Empty;
            try
            {
                filename = "Audit_Result_" + Convert.ToString(param.audit_id) + ".pdf";
                filepath = ConfigurationManager.AppSettings["PDF_Folder"].ToString();
                path = filepath + filename;
                if (WebOperationContext.Current == null) throw new Exception("WebOperationContext not set");

                // As the current service is being used by a windows client, there is no browser interactivity.  
                // In case you are using the code Web, please use the appropriate content type.  
                var fileName = Path.GetFileName(path);
                WebOperationContext.Current.OutgoingResponse.ContentType = "application/octet-stream";
                WebOperationContext.Current.OutgoingResponse.Headers.Add("content-disposition", "inline; filename=" + fileName);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }
            return File.OpenRead(path);  
        }

        public List<TaskList> GetTasks(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<TaskList> obj = new List<TaskList>();
            try
            {
                obj = objComm.GetTasksFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<ErrorOutput> SaveAuditReview(AuditReview paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ErrorOutput> obj = new List<ErrorOutput>();
            try
            {
                obj = objComm.SaveAuditReviewToDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<AuditResultOutput> SendPDFReport(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<AuditResultOutput> obj = new List<AuditResultOutput>();
            try
            {
                obj = objComm.SendReport(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<AuditTypeList> GetAuditType(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<AuditTypeList> obj = new List<AuditTypeList>();
            try
            {
                obj = objComm.GetAuditTypeFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<PartList> GetPartsForProduct(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<PartList> obj = new List<PartList>();
            try
            {
                obj = objComm.GetPartsForProductFromDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }


        //public List<ErrorOutput> PostImage(Stream stream)
        //{

        //    csCommonFunctions objComm = new csCommonFunctions();
        //    ImageContent objImage = new ImageContent();
        //    List<ErrorOutput> oList = new List<ErrorOutput>();
        //    ErrorOutput obj = new ErrorOutput();
        //    try
        //    {
        //        MultipartParser parser = new MultipartParser(stream);
        //        if (parser.Success)
        //        {
        //        }
        //        string filename = parser.Filename;
        //        objImage.audit_id = Convert.ToString(filename.Substring(0, filename.IndexOf('_')));
        //        objComm.TestLog("audit_id : " + objImage.audit_id + " : " + filename, "PostImage");
        //        string pathString = ConfigurationManager.AppSettings["ImageURL"].ToString() + objImage.audit_id;
        //        System.IO.Directory.CreateDirectory(pathString);
        //        using (FileStream writer = new FileStream(pathString + "/" + parser.Filename + "." + System.Drawing.Imaging.ImageFormat.Jpeg, FileMode.OpenOrCreate))
        //        {
        //            writer.Write(parser.FileContents, 0, parser.FileContents.Length);
        //        }
        //        obj.err_code = 0;
        //        obj.err_message = "Inserted Successfully";

        //    }
        //    catch (Exception ex)
        //    {
        //        obj.err_code = 101;
        //        obj.err_message = ex.Message;
        //        objComm.ErrorLog(ex);

        //    }
        //    oList.Add(obj);
        //    return oList;

        //}


        public string PostImage(Stream stream)
        {

            csCommonFunctions objComm = new csCommonFunctions();
            ImageContent objImage = new ImageContent();
            string output = string.Empty;
            try
            {
                MultipartParser parser = new MultipartParser(stream);
                if (parser.Success)
                {
                }

                string filename = parser.Filename;
                // string filepath = ConfigurationManager.AppSettings["PublishedImageURL"].ToString();

                string pathString = ConfigurationManager.AppSettings["ImageURL"].ToString() + objImage.audit_id;
                System.IO.Directory.CreateDirectory(pathString);
                using (FileStream writer = new FileStream(pathString + "/" + parser.Filename + "." + System.Drawing.Imaging.ImageFormat.Jpeg, FileMode.OpenOrCreate))
                {
                    writer.Write(parser.FileContents, 0, parser.FileContents.Length);
                }
                output = "[{\"err_code\":0,\"err_message\":\"Inserted Successfully\"}]";
                return output;
            }
            catch (Exception ex)
            {

                objComm.ErrorLog(ex);
                return output;
            }

        }


        //public string SaveImageForOpenTasks(Stream stream)
        //{

        //    csCommonFunctions objComm = new csCommonFunctions();
        //    ImageContent objImage = new ImageContent();
        //    string output = string.Empty;
        //    try
        //    {
        //        MultipartParser parser = new MultipartParser(stream);
        //        if (parser.Success)
        //        {
        //            // Save the file
        //            //SaveFile(parser.Filename, parser.ContentType, parser.FileContents);

        //        }
        //        objComm.ParamLog("filename : " + parser.Filename);
        //        objComm.ParamLog("ContentType : " + parser.ContentType);
        //        string dirPath = AppDomain.CurrentDomain.BaseDirectory.Replace("\\bin\\Debug\\", "");
        //        string filename = parser.Filename;
        //        objImage.audit_id = Convert.ToInt32(filename.Substring(0, filename.IndexOf('_')));
        //        using (FileStream writer = new FileStream(dirPath + "images/" + objImage.audit_id + "/Task_" + parser.Filename + "." + System.Drawing.Imaging.ImageFormat.Jpeg, FileMode.OpenOrCreate))
        //        {
        //            writer.Write(parser.FileContents, 0, parser.FileContents.Length);
        //        }


        //        string filepath = ConfigurationManager.AppSettings["PublishedImageURL"].ToString();
        //        objComm.ParamLog(filename);
        //        //objImage.audit_id = Convert.ToInt32(filename.Substring(0, parser.Filename.IndexOf('_')));
        //        objImage.filename = filepath + "/" + objImage.audit_id + "/Task_" + parser.Filename + "." + System.Drawing.Imaging.ImageFormat.Jpeg;
        //        objComm.ParamLog("audit_id : " + objImage.audit_id);
        //        string pathString = ConfigurationManager.AppSettings["ImageURL"].ToString() + objImage.audit_id;
        //        System.IO.Directory.CreateDirectory(pathString);
        //        int len = (filename.Length - filename.IndexOf('_'));
        //        objComm.ParamLog("length : " + len);
        //        objImage.question_id = Convert.ToInt32(filename.Substring(filename.IndexOf('_') + 1, len - 1));
        //        objComm.ParamLog("question_id : " + objImage.question_id);
        //        output = objComm.SaveImageForTaskToDatabase(objImage);

        //        return output;
        //    }
        //    catch (Exception ex)
        //    {

        //        objComm.ErrorLog(ex);
        //        return output;
        //    }

        //}


        public List<URLOutput> GetDashboardURL(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<URLOutput> obj = new List<URLOutput>();
            try
            {
                obj = objComm.GetDashboardURLcs(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<AuditResultOutput> SendReport(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<AuditResultOutput> obj = new List<AuditResultOutput>();
            try
            {
                obj = objComm.SendReport(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<URLOutput> GetBulkQRCodesURL(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<URLOutput> obj = new List<URLOutput>();
            try
            {
                obj = objComm.GetBulkQRCodesURLcs(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<ErrorOutput> SaveImagesForPerformAudit(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ErrorOutput> obj = new List<ErrorOutput>();
            try
            {
                obj = objComm.SaveImagesForPerformAuditToDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<ErrorOutput> SaveImagesForOpenTask(Parameters paramdetails)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ErrorOutput> obj = new List<ErrorOutput>();
            try
            {
                obj = objComm.SaveImagesForOpenTaskToDB(paramdetails);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<ErrorOutput> UploadBulkReview(BulkReview objReview)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ErrorOutput> obj = new List<ErrorOutput>();
            try
            {
                obj = objComm.UploadBulkReviewToDB(objReview);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<ErrorOutput> ForgotPassword(Parameters param)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ErrorOutput> obj = new List<ErrorOutput>();
            try
            {
                obj = objComm.ForgotPassword(param);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<LandingScreenDetail> LandingScreenDetails(Parameters param)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<LandingScreenDetail> obj = new List<LandingScreenDetail>();
            try
            {
                obj = objComm.GetLandingScreenDataFromDB(param);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<AuditList> GetMyAudits(Parameters param)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<AuditList> obj = new List<AuditList>();
            try
            {
                obj = objComm.GetMyAuditsFromDB(param);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }
     
        public List<CalendarDashboard> CalendarDashboardDetail(Parameters param)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<CalendarDashboard> obj = new List<CalendarDashboard>();
            try
            {
                obj = objComm.GetCalendarDashboardFromDB(param);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }
        public List<ErrorOutput> SaveAuditPlan(PlanParameters param)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ErrorOutput> obj = new List<ErrorOutput>();
            try
            {
                obj = objComm.SaveAuditPlanToDB(param);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }
        public List<EmployeeList> GetEmployeeList(Parameters param)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<EmployeeList> obj = new List<EmployeeList>();
            try
            {
                obj = objComm.GetEmployeeListFromDB(param);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }
        public List<ProfileScore> GetProfileScore(Parameters param)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ProfileScore> obj = new List<ProfileScore>();
            try
            {
                obj = objComm.GetProfileScoreFromDB(param);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public List<ErrorOutput> SaveUserDetails(Parameters param)
        {
            csCommonFunctions objComm = new csCommonFunctions();
            List<ErrorOutput> obj = new List<ErrorOutput>();
            try
            {
                obj = objComm.SaveUserDetailsToDB(param);
            }
            catch (Exception ex)
            {
                objComm.ErrorLog(ex);
            }

            return obj;
        }

        public string UploadProfilePic(Stream stream)
        {

            csCommonFunctions objComm = new csCommonFunctions();
            ImageContent objImage = new ImageContent();
            string output = string.Empty;
            try
            {
                MultipartParser parser = new MultipartParser(stream);
                if (parser.Success)
                {
                }

                string filename = parser.Filename;
                // string filepath = ConfigurationManager.AppSettings["PublishedImageURL"].ToString();

                string pathString = ConfigurationManager.AppSettings["ProfileImages"].ToString();
                System.IO.Directory.CreateDirectory(pathString);
                using (FileStream writer = new FileStream(pathString + "/" + parser.Filename + "." + System.Drawing.Imaging.ImageFormat.Jpeg, FileMode.OpenOrCreate))
                {
                    writer.Write(parser.FileContents, 0, parser.FileContents.Length);
                }
                output = "[{\"err_code\":0,\"err_message\":\"Inserted Successfully\"}]";
                return output;
            }
            catch (Exception ex)
            {

                objComm.ErrorLog(ex);
                return output;
            }

        }
    }
}
