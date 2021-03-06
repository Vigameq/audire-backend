USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_getOpenTasks]    Script Date: 27-05-2020 12:32:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_getOpenTasks]
(
@p_region_id INT,
@p_country_id INT,
@p_location_id INT,
@p_line_id INT,
@module_id INT,
@auditType_id INT,
@p_user_id INT
)
As
--exec sp_getOpenTasks 2,1,1,0,1,7,2026
BEGIN
DECLARE @audit_id INT, @process_id VARCHAR(100)

SELECT @process_id=process_id from tbl_user_master where user_id=@p_user_id

select @audit_id= MAX(audit_id) from tbl_AuditResult 
WHERE region_id=ISNULL(@p_region_id,region_id) 
AND country_id=ISNULL(@p_country_id, country_id)
AND location_id=ISNULL(@p_location_id, location_id)
AND line_id=@p_line_id
AND module_id=@module_id
AND AuditType_id=@auditType_id
if(@module_id=3)
Select ans.id answer_id,audit_id,ans.question_id, que.question,answer,audit_comment ,audit_images, review_comment, clause, root_cause, Corrective_Action, Preventive_Action, Audit_number, (Select Process from tbl_process_master where id=assigned_To) 'assigned_To'
from tbl_AuditResult ans join tbl_question_master que ON ans.question_id=que.question_id AND ans.module_id=que.module_id AND ans.AuditType_id=que.Audit_type_id
WHERE audit_id=@audit_id AND answer=1 AND assigned_To in ( Select Item from dbo.SplitString(@process_id,','))
AND ans.id not in (select id from tbl_AuditResult where review_status='1')
UNION
Select ans.id answer_id,audit_id,ans.question_id, que.question,answer,audit_comment ,audit_images, review_comment, clause, root_cause, Corrective_Action, Preventive_Action, Audit_number, (Select Process from tbl_process_master where id=assigned_To) 'assigned_To'
from tbl_AuditResult ans join tbl_question_master que ON ans.question_id=que.question_id AND ans.module_id=que.module_id AND que.Audit_type_id is null
WHERE audit_id=@audit_id AND answer=1 AND assigned_To in ( Select Item from dbo.SplitString(@process_id,','))
AND ans.id not in (select id from tbl_AuditResult where review_status='1')

ELSE
Select ans.id answer_id,audit_id,ans.question_id, que.question,answer,audit_comment ,audit_images, review_comment, clause, root_cause, Corrective_Action, Preventive_Action, Audit_number, (Select Process from tbl_process_master where id=assigned_To) 'assigned_To'
from tbl_AuditResult ans join tbl_question_master que ON ans.question_id=que.question_id AND ans.module_id=que.module_id AND ans.AuditType_id=que.Audit_type_id
WHERE audit_id=@audit_id AND answer in (1,11) AND assigned_To in ( Select Item from dbo.SplitString(@process_id,','))
AND ans.id not in (select id from tbl_AuditResult where review_status='1')
--and review_comment<>1
END


