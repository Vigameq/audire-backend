USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_saveConfirmAudit]    Script Date: 27-05-2020 17:20:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_saveConfirmAudit]
(
@audit_id INT,
@confirm VARCHAR(10),
@confirm_by INT,
@err_code INT OUTPUT,
@err_msg VARCHAR(MAX) OUTPUT
)
AS
BEGIN
	SET @err_code=0
	SET @err_msg='Initializing'
	
	IF EXISTS(select * from tbl_AuditResult where audit_id=@audit_id)
	BEGIN
		UPDATE tbl_AuditResult 
			SET confirm_comment=@confirm
				,confirmed_by=@confirm_by
				,confirmed_date=GETDATE()
			WHERE audit_id=@audit_id
				--AND question_id=@question_id
				AND review_status=1
				SET @err_code=200
				SET @err_msg='Audit Review is confirmed successfully.'
	END
	ELSE
	BEGIN
		SET @err_code=201
		SET @err_msg='Audit id does not exist.'
	END

END