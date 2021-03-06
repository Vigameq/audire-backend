USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_getQuestionList]    Script Date: 05-06-2020 14:13:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec sp_getQuestionList 1,3
ALTER PROCEDURE [dbo].[sp_getQuestionList](
@module_id INT,
@auditType_id INT
)
AS
BEGIN
DECLARE @audit_id INT, @audit_number VARCHAR(100), @code VARCHAR(10)

IF(@module_id=1)
SET @code='CO'
ELSE IF(@module_id=2)
SET @code='PR'
ELSE IF(@module_id=3)
SET @code='PA'
ELSE
SET @code='SU'

exec GetMaxAuditId @audit_id output

SET @audit_number=CONCAT('VIG ',@code,' ', CONVERT(VARCHAR(10),@audit_id))

IF @module_id=3
	BEGIN 
		SELECT que.question_id, question, aty.Audit_Type,aty.ID audit_type_id, sec.section_name, sub.sub_section_name, @audit_id audit_id, @audit_number audit_number
, res.answer, res.assigned_To, res.audit_comment, res.audit_images, res.IsCompleted
		FROM tbl_question_master que LEFT JOIN tbl_section_master sec ON que.section_id=sec.section_id
		LEFT JOIN tbl_sub_section_master sub ON que.sub_section_id=sub.sub_section_id
		LEFT JOIN tbl_audit_type aty ON aty.ID=que.Audit_type_id
		LEFT JOIN tbl_AuditResult res ON que.question_id=res.question_id AND que.module_id=res.module_id AND que.Audit_type_id=res.AuditType_id AND res.IsCompleted='N'
		  WHERE que.module_id=@module_id AND (Audit_type_id=ISNULL(@auditType_id,Audit_type_id)	OR Audit_type_id is null)
		  order by que.question_id
	END
ELSE
	BEGIN
		SELECT que.question_id, question, aty.Audit_Type,aty.ID audit_type_id, sec.section_name, sub.sub_section_name, @audit_id audit_id, @audit_number audit_number
, res.answer, res.assigned_To, res.audit_comment, res.audit_images, res.IsCompleted
		FROM tbl_question_master que LEFT JOIN tbl_section_master sec ON que.section_id=sec.section_id
		LEFT JOIN tbl_sub_section_master sub ON que.sub_section_id=sub.sub_section_id
		LEFT JOIN tbl_audit_type aty ON aty.ID=que.Audit_type_id
		LEFT JOIN tbl_AuditResult res ON que.question_id=res.question_id AND que.module_id=res.module_id AND que.Audit_type_id=res.AuditType_id AND res.IsCompleted='N'
		  WHERE que.module_id=@module_id AND Audit_type_id=ISNULL(@auditType_id,Audit_type_id)
		  order by que.question_id
	END
END
