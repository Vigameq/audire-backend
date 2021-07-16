ALTER PROCEDURE sp_getAuditType
(
@module_id int
)
AS
BEGIN

Select ID AuditType_id, Audit_Type AuditType from tbl_audit_type where module_id=@module_id and Status=1

END
GO

ALTER PROCEDURE [dbo].[sp_getQuestionList](
@module_id INT,
@auditType_id INT
)
AS
BEGIN
SELECT question_id, question FROM tbl_question_master WHERE module_id=@module_id AND Audit_type_id=@auditType_id
END
GO

ALTER TABLE tbl_AuditResult ADD AuditType_id INT
GO

ALTER PROCEDURE [dbo].[sp_InsAnswers]
(
@audit_id int=null,
@p_region_id int,
@p_country_id int,
@p_location_id int,
@p_line_id int,
@p_product_id int=null,
@module_id int,
@p_user_id int,
@deviceID VARCHAR(MAX),
@p_shift_no INT,
@auditType_id INT,
@AnswerTable AnswersTableType READONLY
)
AS
BEGIN

DECLARE @score float
If(@audit_id is null OR @audit_id=0)
BEGIN
	Select @audit_id = MAX(audit_id) FROM tbl_AuditResult
	If(@audit_id is null OR @audit_id=0)
		SET @audit_id=1
	ELSE SET @audit_id+=1

	INSERT INTO tbl_AuditResult(audit_id, question_id,answer,audit_comment,assigned_To,module_id,region_id,country_id,location_id,line_id,product_id,audit_performed_by,audit_performed_on,audit_performed_date, shift_no, AuditType_id)
	SELECT @audit_id,question_id,Answer, comment, assignedTo, @module_id,@p_region_id, @p_country_id,@p_location_id, @p_line_id, @p_product_id,@p_user_id,@deviceID,GETDATE(), @p_shift_no, @auditType_id FROM @AnswerTable

END
ELSE
BEGIN
	UPDATE t 
	SET t.answer=t2.Answer,
	t.audit_comment=t2.comment,
	t.assigned_To=t2.assignedTo
	FROM tbl_AuditResult t join @AnswerTable t2 
	ON t.audit_id=@audit_id AND t.question_id=t2.question_id

END
	
	IF EXISTS(Select * from tbl_AuditResult WHERE audit_id=@audit_id)
	BEGIN
		Select @score=dbo.GetAuditScorebyAudit(@audit_id)
		Select @audit_id audit_id, @score score, 200 err_code, 'Success' err_message

		Select ans.audit_id
		,loc.location_name
		,lin.line_name
		,ans.audit_performed_by
		,ans.audit_performed_date
		,ans.shift_no
		,us.emp_full_name
		,prod.product_name
		,ans.question_id
		,que.question
		,ans.answer
		,ans.audit_comment
		,pro.Process assignedTo
		FROM tbl_AuditResult ans 
		JOIN tbl_question_master que ON ans.question_id=que.question_id AND ans.module_id=que.module_id
		--JOIN tbl_region_master reg ON ans.region_id=reg.region_id
		--JOIN tbl_country_master cou ON ans.country_id=cou.country_id
		JOIN tbl_location_master loc ON ans.location_id=loc.location_id
		JOIN tbl_line_master lin ON ans.line_id=lin.line_id
		LEFT JOIN tbl_process_master pro ON ans.assigned_To=pro.id
		JOIN tbl_user_master us ON ans.audit_performed_by=us.user_id
		JOIN tbl_product_master prod ON ans.product_id=prod.product_id
		WHERE audit_id=@audit_id
	END
	ELSE
	BEGIN
		SElECT 0 err_code, 'There is error in insertion.' err_message
	END
	
END

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
--exec sp_getOpenTasks 2,1,1,4,1,1,6
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

Select id answer_id,audit_id,question_id,answer,audit_comment ,audit_images
from tbl_AuditResult 
WHERE audit_id=@audit_id AND answer=1 AND assigned_To in ( Select Item from dbo.SplitString(@process_id,','))
--and review_comment<>1
END
GO