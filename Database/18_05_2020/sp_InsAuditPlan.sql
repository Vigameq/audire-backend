USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_InsAuditPlan]    Script Date: 01-06-2020 17:31:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DECLARE @l_invite_to_list  varchar(max),
--        @l_err_code    int,
--        @l_err_message   varchar(100)
--EXEC sp_InsAuditPlan 0,6,'12/16/2019 12:00:00 AM','12/16/2019 12:00:00 AM',1,2,1, @l_invite_to_list output, @l_err_code output, @l_err_message output



ALTER PROCEDURE [dbo].[sp_InsAuditPlan](
		@p_audit_plan_id   int=null,
        @p_user_id    int, /* Auditor's User Id */ 
        @p_planned_date   date,
        @p_planned_date_end  date,
		@l_location_id	int,
        @module_id    int,
		@audit_type_id INT,
		@audit_note VARCHAR(MAX),
        @l_invite_to_list  varchar(max) OUTPUT,
        @l_err_code    int OUTPUT,
        @l_err_message   varchar(100) OUTPUT
        )
AS
 SET NOCOUNT ON;
 
BEGIN
/* This procedure needs date overlap validation still */
 DECLARE @l_count    INT;
 DECLARE @l_count1    INT;
 
 SET @l_err_code = 0;
 SET @l_err_message = 'Initializing';

 SELECT @l_invite_to_list = email_id
 FROM   tbl_user_master
 WHERE  user_id = @p_user_id;
 
 IF @p_audit_plan_id IS NOT NULL AND @p_audit_plan_id != 0 
 
  BEGIN
 
   UPDATE tbl_audit_plan
   SET    to_be_audited_by_user_id = @p_user_id,
     planned_date = @p_planned_date,
     planned_date_end = @p_planned_date_end,
     module_id=@module_id,
	 Audit_type_id=@audit_type_id,
     location_id = @l_location_id,
	 audit_note=@audit_note
   WHERE audit_plan_id = @p_audit_plan_id;
   
   SET @l_err_code = 0;
   SET @l_err_message = 'Updated Successfully';
  END;  
 ELSE
  BEGIN
   SELECT @l_count = count(*)
   FROM   tbl_audit_plan
   WHERE  FORMAT(ISNULL(planned_date,getdate()),'dd-MM-yyyy') = FORMAT(@p_planned_date,'dd-MM-yyyy')
   AND    FORMAT(ISNULL(planned_date_end,getdate()),'dd-MM-yyyy') = FORMAT(@p_planned_date_end,'dd-MM-yyyy')
   AND    module_id=@module_id
   AND	 Audit_type_id=@audit_type_id
   AND	location_id = @l_location_id

   IF @l_count > 0
   BEGIN
    
     UPDATE tbl_audit_plan
     SET    to_be_audited_by_user_id = @p_user_id, audit_note=@audit_note
     WHERE  FORMAT(ISNULL(planned_date,getdate()),'dd-MM-yyyy') = FORMAT(@p_planned_date,'dd-MM-yyyy')
     AND    FORMAT(ISNULL(planned_date_end,getdate()),'dd-MM-yyyy') = FORMAT(@p_planned_date_end,'dd-MM-yyyy')
     AND    module_id=@module_id
	AND	 Audit_type_id=@audit_type_id
	AND	location_id = @l_location_id
     AND    location_id = @l_location_id;
    
	SET @l_err_code = 0;
   SET @l_err_message = 'Updated Successfully';

   END;
   ELSE
    INSERT INTO tbl_audit_plan
    (
     to_be_audited_by_user_id,
     planned_date,
     planned_date_end,
     module_id,
	 Audit_type_id,
     location_id,
	 audit_note
    ) VALUES (
     @p_user_id,
     @p_planned_date,
     @p_planned_date_end,
     @module_id,
	 @audit_type_id,
     @l_location_id,
	 @audit_note
    );
 
   
   SET @l_err_code = 0;
   SET @l_err_message = 'Inserted Successfully';
  END;
END