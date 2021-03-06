USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_getOpenTasks]    Script Date: 11/22/2019 9:47:10 AM ******/
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
--exec sp_getOpenTasks 2,1,1,4,1,3,8
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

Select res.id answer_id,audit_id, que.question, res.question_id,answer,audit_comment ,audit_images
from tbl_AuditResult res JOIN tbl_question_master que ON que.question_id=res.question_id and que.module_id=res.module_id
WHERE audit_id=@audit_id AND answer=1 AND assigned_To in ( Select Item from dbo.SplitString(@process_id,','))
--and review_comment<>1
END


--select * from tbl_AuditResult res JOIN tbl_question_master que ON res