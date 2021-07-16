using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace AudireWCF
{

    public class Parameters
    {
        public string username { get; set; }
        public string password { get; set; }
        public string encryptedPassword { get; set; }
        public string userID { get; set; }
        public string deviceID { get; set; }
        public int module_id { get; set; }
        public int region_id { get; set; }
        public int country_id { get; set; }
        public int location_id { get; set; }
        public int line_id { get; set; }
        public int user_id { get; set; }
        public int audit_id { get; set; }
        public int auditType_id { get; set; }
        public string filename { get; set; }
        public List<ImageDetails> imgDetails { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public string profile_url { get; set; }
    }

    public class BulkReview
    {
        public string userID { get; set; }
        public string deviceID { get; set; }
        public List<BulkReviewList> reviewObj { get; set; }
    }
    public class BulkReviewList
    {

        public int audit_id { get; set; }
        public int question_id { get; set; }
        public string review_closed_on { get; set; }
        public int review_closed_status { get; set; }
        public string review_comments { get; set; }
        public string review_image_file_name { get; set; }
    }

    public class ImageDetails {
        public int audit_id { get; set; }
        public int question_id { get; set; }
        public string img_url { get; set; }
    }
    public class OutputDetail
    {
        public int Error_code { get; set; }
        public string Error_msg { get; set; }
        public int err_code { get; set; }
        public string err_message { get; set; }
    }


    [DataContract]
    [Serializable]
    public class UserDetails
    {
        [DataMember]
        public int user_id { get; set; }
        [DataMember]
        public string role { get; set; }
        [DataMember]
        public int role_id { get; set; }
        [DataMember]
        public string email_id { get; set; }
        [DataMember]
        public string emp_full_name { get; set; }
        [DataMember]
        public string display_name_flag { get; set; }
        [DataMember]
        public string global_admin_flag { get; set; }
        [DataMember]
        public string site_admin_flag { get; set; }
        [DataMember]
        public int region_id { get; set; }
        [DataMember]
        public string region_name { get; set; }
        [DataMember]
        public int country_id { get; set; }
        [DataMember]
        public string country_name { get; set; }
        [DataMember]
        public int location_id { get; set; }
        [DataMember]
        public string location_name { get; set; }
        [DataMember]
        public string module_id { get; set; }
        [DataMember]
        public string profile_pic { get; set; }
        [DataMember]
        public string role_access { get; set; }

        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
        [DataMember]
        public List<ModuleListForUser> module { get; set; }
    }

    public class ModuleListForUser
    {
        public int module_id { get; set; }
        public string module { get; set; }
    }
    [Serializable]
    [DataContract]
    public class ErrorOutput
    {
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }

    [Serializable]
    [DataContract]
    public class URLOutput
    {
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
        [DataMember]
        public string url { get; set; }

    }

    [DataContract]
    [Serializable]
    public class RegionList
    {
        [DataMember]
        public int region_id { get; set; }
        [DataMember]
        public string region_code { get; set; }
        [DataMember]
        public string region_name { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }


    [DataContract]
    [Serializable]
    public class ModuleList
    {
        [DataMember]
        public int module_id { get; set; }
        [DataMember]
        public string module { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }

    [DataContract]
    [Serializable]
    public class LocationList
    {
        [DataMember]
        public int location_id { get; set; }
        [DataMember]
        public string location_code { get; set; }
        [DataMember]
        public string location_name { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }


    [DataContract]
    [Serializable]
    public class CountryList
    {
        [DataMember]
        public int country_id { get; set; }
        [DataMember]
        public string country_code { get; set; }
        [DataMember]
        public string country_name { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }

    [DataContract]
    [Serializable]
    public class LineList
    {
        [DataMember]
        public int line_id { get; set; }
        [DataMember]
        public string line_name { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }


    [DataContract]
    [Serializable]
    public class AuditPlanList
    {
        [DataMember]
        public int audit_plan_id { get; set; }
        [DataMember]
        public string planned_date { get; set; }
        [DataMember]
        public string planned_date_end { get; set; }
        [DataMember]
        public string Audit_status { get; set; }
        [DataMember]
        public string location_name { get; set; }
        [DataMember]
        public string line_name { get; set; }
        [DataMember]
        public string Emp_name { get; set; }
        [DataMember]
        public int Audit_Score { get; set; }
        [DataMember]
        public int module_id { get; set; }
        [DataMember]
        public string module { get; set; }
        [DataMember]
        public int Audit_type_id { get; set; }
        [DataMember]
        public string Audit_Type { get; set; }

        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }


    [DataContract]
    [Serializable]
    public class QuestionList
    {

        [DataMember]
        public int audit_id { get; set; }
        [DataMember]
        public string audit_number { get; set; }
        [DataMember]
        public int question_id { get; set; }
        [DataMember]
        public string question { get; set; }
        [DataMember]
        public string help_text { get; set; }
        //[DataMember]
        //public string sub_section_name { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
        [DataMember]
        public string answer { get; set; }
        //[DataMember]
        //public string assigned_To_ID { get; set; }
        //[DataMember]
        //public string assigned_To { get; set; }
        //[DataMember]
        //public string audit_comment { get; set; }
        //[DataMember]
        //public string audit_images { get; set; }
        //[DataMember]
        //public string IsCompleted { get; set; }


        //[DataMember]
        //public string type { get; set; }
        //[DataMember]
        //public string subtype { get; set; }
        //[DataMember]
        //public string label { get; set; }
        //[DataMember]
        //public string name { get; set; }
        //[DataMember]
        //public string other { get; set; }
        //[DataMember]
        //public List<Info> values { get; set; }
        //[DataMember]
        //public string description { get; set; }
        //[DataMember]
        //public string rows { get; set; }

    }

    [DataContract]
    [Serializable]
    public class QuestionsWithSection
    {
        [DataMember]
        public Boolean expanded { get; set; }
        [DataMember]
        public string id { get; set; }
        [DataMember]
        public string category_Name { get; set; }
        [DataMember]
        public List<QuestionsWithSubSection> sub_Category { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
        [DataMember]
        public int audit_id { get; set; }
        [DataMember]
        public string audit_number { get; set; }
        //[DataMember]
        //public string IsCompleted { get; set; }

    }

    [DataContract]
    [Serializable]
    public class QuestionsWithSubSection
    {
        [DataMember]
        public string id { get; set; }
        [DataMember]
        public string clause { get; set; }
        [DataMember]
        public string sub_name { get; set; }
        [DataMember]
        public List<QuestionList> name { get; set; }
    }

    public class Info
    {
        public string label { get; set; }
        public string value { get; set; }
    }


    [DataContract]
    [Serializable]
    public class ProductList
    {
        [DataMember]
        public int line_id { get; set; }
        [DataMember]
        public string line_name { get; set; }
        [DataMember]
        public int product_id { get; set; }
        [DataMember]
        public string product_name { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }

    [DataContract]
    [Serializable]
    public class PartList
    {
        [DataMember]
        public string part_name { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }

    [DataContract]
    [Serializable]
    public class ProcessList
    {
        [DataMember]
        public int process_id { get; set; }
        [DataMember]
        public string process_name { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }

    public class AuditResult
    {

        public string username { get; set; }
        public string password { get; set; }
        public string userID { get; set; }
        public string deviceID { get; set; }
        public int audit_id { get; set; }
        public int module_id { get; set; }
        public int region_id { get; set; }
        public int country_id { get; set; }
        public int location_id { get; set; }
        public int line_id { get; set; }
        public int product_id { get; set; }
        public List<QuestionAnswer> questionAnswer { get; set; }
        public int shift_no { get; set; }
        public int auditType_id { get; set; }
        public string part_name { get; set; }

        public string Auditor_comment { get; set; }
        public string auditor_comment { get; set; }
        public string IsCompleted { get; set; }
    }

    public class QuestionAnswer
    {
        public int question_id { get; set; }
        public string Answer { get; set; }
        public string comment { get; set; }
        public string assignedTo { get; set; }
        public string img_content { get; set; }
    }

    [DataContract]
    [Serializable]
    public class AuditResultOutput
    {
        [DataMember]
        public int audit_id { get; set; }
        [DataMember]
        public string score { get; set; }
        [DataMember]
        public string audit_report { get; set; }
        [DataMember]
        public string audit_number { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }

    [DataContract]
    [Serializable]
    public class TaskList
    {
        [DataMember]
        public int answer_id { get; set; }
        [DataMember]
        public int audit_id { get; set; }
        [DataMember]
        public int question_id { get; set; }
        [DataMember]
        public string question { get; set; }
        [DataMember]
        public int answer { get; set; }
        [DataMember]
        public string audit_comment { get; set; }
        [DataMember]
        public string audit_images { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
        [DataMember]
        public string review_comment { get; set; }
        
    }

    public class AuditReview
    {

        public string username { get; set; }
        public string password { get; set; }
        public string userID { get; set; }
        public string deviceID { get; set; }
        public int audit_id { get; set; }
        public int module_id { get; set; }
        public int region_id { get; set; }
        public int country_id { get; set; }
        public int location_id { get; set; }
        public int line_id { get; set; }
        public List<ReviewStatus> reviewStatus { get; set; }
    }

    public class ReviewStatus
    {
        public int answer_id { get; set; }
        public string review_closed_on { get; set; }
        public string review_closed_status { get; set; }
        public string review_comments { get; set; }
        public string review_image_file_name { get; set; }
        public string root_cause { get; set; }
        public string CA { get; set; }
        public string PA { get; set; }
    }

    public class EmailDetails
    {
        public string toMailId { get; set; }
        public string ccMailId { get; set; }
        public string subject { get; set; }
        public string body { get; set; }
        public string attachment { get; set; }
        public string fromMailId { get; set; }
    }

    [DataContract]
    [Serializable]
    public class AuditTypeList
    {
        [DataMember]
        public int AuditType_id { get; set; }
        [DataMember]
        public string AuditType { get; set; }
        [DataMember]
        public int Section_flag { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }

    public class ImageContent
    {
        public string filename { get; set; }
        public int question_id { get; set; }
        public string audit_id { get; set; }
        public string flag { get; set; }
        public int user_id { get; set; }
    }


    [DataContract]
    [Serializable]
    public class LandingScreenDetail
    {
        [DataMember]
        public List<ModuleScore> score { get; set; }
        [DataMember]
        public List<UpcomingPlan> upcomingplans { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }
    public class UpcomingPlan
    {
        public int week_num { get; set; }
        public int location_id { get; set; }
        public string location { get; set; }
        public int audit_type_id { get; set; }
        public string audit_type { get; set; }
        public int color_code { get; set; }
        public int err_code { get; set; }
        public string err_message { get; set; }
    }

    public class ModuleScore
    {
        public int module_id { get; set; }
        public string module { get; set; }
        public string score { get; set; }
        public int err_code { get; set; }
        public string err_message { get; set; }
    }

    [DataContract]
    [Serializable]
    public class AuditList
    {
        [DataMember]
        public string audit_id { get; set; }
        [DataMember]
        public int module_id { get; set; }
        [DataMember]
        public string module { get; set; }
        [DataMember]
        public int location_id { get; set; }
        [DataMember]
        public string location_name { get; set; }
        [DataMember]
        public int AuditType_id { get; set; }
        [DataMember]
        public string Audit_Type { get; set; }
        [DataMember]
        public string audit_performed_date { get; set; }
        [DataMember]
        public string score { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }

    [DataContract]
    [Serializable]
    public class CalendarDashboard
    {
        [DataMember]
        public List<CalendarPlan> calendarPlan { get; set; }
        [DataMember]
        public List<CalendarReport> calendarReport { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }

    public class CalendarPlan
    {
        public string planned_date { get; set; }
        public string planned_date_end { get; set; }
        public int module_id { get; set; }
        public string module { get; set; }
        public int Audit_type_id { get; set; }
        public string Audit_Type { get; set; }
        public int err_code { get; set; }
        public string err_message { get; set; }
    }

    public class CalendarReport
    {
        public int module_id { get; set; }
        public string module { get; set; }
        public int plan_month { get; set; }
        public int plan_year { get; set; }
        public int completed_audit { get; set; }
        public int planned_audit { get; set; }
        public string audit_rate { get; set; }
        public string week_number { get; set; }
        public int err_code { get; set; }
        public string err_message { get; set; }
    }


    public class PlanParameters
    {
        public string deviceID { get; set; }
        public string username { get; set; }
        public string password { get; set; }
        public int audit_plan_id { get; set; }
        public int user_id { get; set; }
        public string plan_start_date { get; set; }
        public string plan_end_date { get; set; }
        public int location_id { get; set; }
        public int module_id { get; set; }
        public int auditType_id { get; set; }

    }


    [Serializable]
    [DataContract]
    public class EmployeeList
    {
        [DataMember]
        public int user_id { get; set; }
        [DataMember]
        public string emp_full_name { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }


    [Serializable]
    [DataContract]
    public class ProfileScore
    {
        [DataMember]
        public string Overall_score { get; set; }
        [DataMember]
        public string planned_vs_actual { get; set; }
        [DataMember]
        public string audit_affectiveness { get; set; }
        [DataMember]
        public string action_timeline { get; set; }
        [DataMember]
        public int err_code { get; set; }
        [DataMember]
        public string err_message { get; set; }
    }
}
