USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_getQuestionListForC]    Script Date: 05-06-2020 13:11:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec sp_getQuestionListForC 1,7

ALTER PROCEDURE [dbo].[sp_getQuestionListForC](
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
SELECT que.question_id, question, section_name,  clause, LTRim(substring(sub_section_name,CharIndex(' ',sub_section_name),Len(sub_section_name))) sub_section_name,  help_text
--substring(sub_section_name,0,CharIndex(' ',sub_section_name))
, @audit_id audit_id, @audit_number audit_number
, res.answer, res.assigned_To, res.audit_comment, res.audit_images, res.IsCompleted
FROM tbl_question_master que LEFT JOIN tbl_AuditResult res ON que.question_id=res.question_id AND que.module_id=res.module_id AND que.Audit_type_id=res.AuditType_id AND res.IsCompleted='N'
--LEFT JOIN tbl_section_master sec ON que.section_id=sec.section_id
--LEFT JOIN tbl_sub_section_master sub ON que.sub_section_id=sub.sub_section_id
  WHERE que.module_id=@module_id AND que.Audit_type_id=@auditType_id
END


