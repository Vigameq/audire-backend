USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_InsAnswers]    Script Date: 10/11/2019 9:30:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_InsAnswers]
(
@p_region_id int,
@p_country_id int,
@p_location_id int,
@p_line_id int,
@p_product_id int=null,
@module_id int,
@p_user_id int,
@deviceID VARCHAR(MAX),
@p_shift_no INT,
@AnswerTable AnswersTableType READONLY
)
AS
BEGIN
DECLARE @audit_id int 
DECLARE @score float
Select @audit_id = MAX(audit_id) FROM tbl_AuditResult

If(@audit_id is null OR @audit_id=0)
	SET @audit_id=1
ELSE SET @audit_id+=1

	INSERT INTO tbl_AuditResult(audit_id, question_id,answer,audit_comment,assigned_To,module_id,region_id,country_id,location_id,line_id,product_id,audit_performed_by,audit_performed_on,audit_performed_date, shift_no)
	SELECT @audit_id,question_id,Answer, comment, assignedTo, @module_id,@p_region_id, @p_country_id,@p_location_id, @p_line_id, @p_product_id,@p_user_id,@deviceID,GETDATE(), @p_shift_no FROM @AnswerTable

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