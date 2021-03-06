USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_getCAPAReport]    Script Date: 27-05-2020 15:15:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_getCAPAReport  1,3,8
ALTER PROCEDURE [dbo].[sp_getCAPAReport]
(
	@module_id INT,
	@audittype_id INT,
	@user_id INT
)
AS
BEGIN
SET FMTONLY OFF
	DECLARE @Admin_flag VARCHAR(2)
	Select @Admin_flag=global_admin_flag  from tbl_user_master where user_id=@user_id


	SELECT t.Audit_number, t.audit_id, t.report_date,t.Containment, t.pa_date, t.Status, t.confirm_comment, count(*) que_count
	INTO #TEMP
	FROM (
	Select ans.Audit_number
		, ans.audit_id
		,FORMAT(ans.audit_performed_date,'dd/MM/yyyy') report_date 
		,FORMAT(DATEADD(DAY,1,ans.audit_performed_date),'dd/MM/yyyy')  Containment
		 ,FORMAT(DATEADD(DAY,90,ans.audit_performed_date),'dd/MM/yyyy') pa_date
		 ,
		CASE WHEN ans.review_status=1 THEN 
				CASE WHEN ans.reviewed_date<=DATEADD(DAY,90,ans.audit_performed_date) THEN 'OnTime' ELSE 'Delayed' END
			ELSE CASE WHEN GETDATE()<=DATEADD(DAY,90,ans.audit_performed_date) THEN 'Open' ELSE 'Delayed' END  
			END Status,
			ans.confirm_comment
		from tbl_AuditResult ans JOIN tbl_question_master que ON ans.question_id=que.question_id AND ans.module_id=que.module_id
		LEFT JOIN tbl_process_master pro ON ans.assigned_To=pro.id
		where ans.module_id=@module_id and answer in (1,11)
				AND (que.Audit_type_id=ISNULL(@audittype_id,que.Audit_type_id)	OR que.Audit_type_id is null)
				AND ans.AuditType_id=@audittype_id
				AND (ans.audit_performed_by=@user_id OR @Admin_flag='Y')
				) t

				GROUP BY  t.Audit_number, t.audit_id, t.report_date,t.Containment, t.pa_date, t.Status, t.confirm_comment


				SELECT distinct m.Audit_number, m.audit_id, m.report_date, m.Containment, m.pa_date, m.Final_Status, m.confirm_comment
				FROM(
	SELECT t.*, t1.c, 
	CASE WHEN t1.c=1 THEN t.Status ELSE CASE WHEN GETDATE()> CONVERT(DATETIME,t.pa_date,103) THEN 'Delayed' ELSE 'Open' END END 'Final_Status' 
	FROM #TEMP t JOIN 
	(SELECT audit_id, count(*) c from #TEMP GROUP BY audit_id) t1 ON t.audit_id=t1.audit_id
	) m
	--IF(@module_id=3)
	--BEGIN
	-- Select t.Audit_number, t.audit_id, t.audit_performed_date, t.Containment, t.pa_date, count()
	-- FROM 
	--	(Select ans.Audit_number
	--	, ans.audit_id
	--	, ans.question_id
	--	, ans.audit_comment
	--	,que.clause
	--	, ans.root_cause
	--	, ans.review_comment
	--	 ,ans.Corrective_Action
	--	 ,ans.Preventive_Action
	--	 ,FORMAT(DATEADD(DAY,90,ans.audit_performed_date),'dd/MM/yyyy') target_date
	--	 ,ans.assigned_To
	--	 ,pro.Process 
	--	 ,ans.review_status,
	--	CASE WHEN ans.review_status=1 THEN 
	--			CASE WHEN ans.reviewed_date<=DATEADD(DAY,90,ans.audit_performed_date) THEN 'OnTime' ELSE 'Delayed' END
	--		ELSE 'Open' END Status,
	--	ans.confirm_comment,
	--	ans.audit_performed_date,
	--	DATEADD(DAY,1,ans.audit_performed_date) Containment,
	--	DATEADD(DAY,90,ans.audit_performed_date) pa_date
	--	from tbl_AuditResult ans JOIN tbl_question_master que ON ans.question_id=que.question_id AND ans.module_id=que.module_id
	--	LEFT JOIN tbl_process_master pro ON ans.assigned_To=pro.id
	--	where ans.module_id=@module_id and answer in (1,11)
	--			AND (que.Audit_type_id=ISNULL(@audittype_id,que.Audit_type_id)	OR que.Audit_type_id is null)
	--			AND ans.AuditType_id=@audittype_id
	--			AND (ans.audit_performed_by=@user_id OR @Admin_flag='Y')) t
	--END
	--ELSE
	--BEGIN
	--	Select ans.Audit_number
	--	, ans.audit_id
	--	, ans.question_id
	--	, ans.audit_comment
	--	,que.clause
	--	, ans.root_cause
	--	, ans.review_comment
	--	 ,ans.Corrective_Action
	--	 ,ans.Preventive_Action
	--	 ,FORMAT(DATEADD(DAY,90,ans.audit_performed_date),'dd/MM/yyyy') target_date
	--	 ,ans.assigned_To
	--	 ,pro.Process 
	--	 ,ans.review_status,
	--	CASE WHEN ans.review_status=1 THEN 
	--			CASE WHEN ans.reviewed_date<=DATEADD(DAY,90,ans.audit_performed_date) THEN 'OnTime' ELSE 'Delayed' END
	--		ELSE 'Open' END Status,
	--	ans.confirm_comment,
	--	ans.audit_performed_date,
	--	DATEADD(DAY,1,ans.audit_performed_date) Containment,
	--	DATEADD(DAY,90,ans.audit_performed_date) pa_date
		
	--	from tbl_AuditResult ans 
	--	JOIN tbl_question_master que ON ans.question_id=que.question_id AND ans.module_id=que.module_id AND ans.AuditType_id=que.Audit_type_id
	--	LEFT JOIN tbl_process_master pro ON ans.assigned_To=pro.id
	--	where ans.module_id=@module_id and answer in (1,11)
	--	AND (ans.audit_performed_by=@user_id OR @Admin_flag='Y')
	--	AND ans.AuditType_id=@audittype_id
	--END

END



--select * from tbl_audit_type


--update tbl_AuditResult set confirm_comment='Y' where audit_id=22771 and question_id=2


--select * from tbl_AuditResult where confirm_comment IS NOT NULL