 --exec sp_GetPlanConsolidated 1,1
 CREATE PROCEDURE  [dbo].[sp_GetPlanConsolidated]
  (@p_location_id 		int,
	@p_module_id		int)  
AS
BEGIN
  
  DECLARE @Tot_plan INT, @l_tot_plan INT, @tot_plan_rate float
  DECLARE @Tot_plan_com INT, @l_tot_plan_com INT, @tot_com_rate float

  Select @Tot_plan=COUNT(*) from tbl_audit_plan where module_id=@p_module_id and location_id=@p_location_id
  Select @l_tot_plan=COUNT(*) from tbl_audit_plan where module_id=@p_module_id and location_id=@p_location_id AND planned_date<=DATEADD(MM,-1,GETDATE())
  Set @tot_plan_rate=CASE WHEN (@Tot_plan IS NULL OR @Tot_plan=0) AND (@l_tot_plan IS NULL OR @l_tot_plan=0) THEN 0 ELSE CASE WHEN @l_tot_plan IS NULL OR @l_tot_plan=0 THEN 100 ELSE (@Tot_plan-@l_tot_plan)*100/@l_tot_plan END END

  Select @Tot_plan_com=COUNT(*) from tbl_audit_plan pln where module_id=@p_module_id and location_id=@p_location_id AND
  dbo.GetAuditScorebyAudit(dbo.GetAuditIDByPlanDate(FORMAT(pln.planned_date,'yyyy-MM-dd'),FORMAT(pln.planned_date_end,'yyyy-MM-dd'), 0))>0

  Select @l_tot_plan_com=COUNT(*) from tbl_audit_plan pln where module_id=@p_module_id and location_id=@p_location_id AND
  dbo.GetAuditScorebyAudit(dbo.GetAuditIDByPlanDate(FORMAT(pln.planned_date,'yyyy-MM-dd'),FORMAT(pln.planned_date_end,'yyyy-MM-dd'), 0))>0
   AND planned_date<=DATEADD(MM,-1,GETDATE())

   SET @tot_com_rate=CASE WHEN (@Tot_plan_com IS NULL OR @Tot_plan_com=0) AND (@l_tot_plan_com IS NULL OR @l_tot_plan_com=0) THEN 0 ELSE CASE WHEN @l_tot_plan_com IS NULL OR @l_tot_plan_com=0 THEN 100 ELSE (@Tot_plan_com-@l_tot_plan_com)*100/@l_tot_plan_com END END

   SELECT @Tot_plan TotalPlan, @l_tot_plan LMTotalPlan, @tot_plan_rate TotalPlanRate, @Tot_plan_com TotalPlanCompleted, @l_tot_plan_com LMTotalCompleted, @tot_com_rate TotalCompletedRate

END



