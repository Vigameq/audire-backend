USE [Audire_db]
GO
/****** Object:  UserDefinedFunction [dbo].[GetAuditScorebyAudit]    Script Date: 10/11/2019 9:38:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[GetAuditScorebyAudit](@p_audit_id int=null)  
 RETURNS FLOAT  
AS  
BEGIN  

	DECLARE @l_total_answers int;
	DECLARE @l_yes_answers	int;
	DECLARE @l_out			FLOAT;

	IF(@p_audit_id=null OR @p_audit_id='')
	BEGIN 
	SELECT @l_out=0  
	END
	ELSE 
	BEGIN
	SELECT @l_total_answers=count(*) FROM tbl_AuditResult WHERE audit_id=@p_audit_id and answer IN (0,1)
	SELECT @l_yes_answers=count(*) FROM tbl_AuditResult WHERE audit_id=@p_audit_id and answer=0

	if(@l_total_answers=0)
	SELECT @l_out=0
	ELSE 
	SELECT @l_out=@l_yes_answers*100/@l_total_answers
	END
	RETURN @l_out
END
