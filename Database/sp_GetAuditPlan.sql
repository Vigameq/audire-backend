USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAuditPlan]    Script Date: 12/11/2019 9:41:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  ALTER PROCEDURE  [dbo].[sp_GetAuditPlan]
  (@p_location_id 		int,
	@p_module_id		int,
							@p_line_id 	int=null,
							@p_user_id				int=null)  
AS
BEGIN
  
   SELECT audit_plan_id,
   			planned_date, 
			planned_date_end,
			Audit_status,
			location_name,
			line_name,
			to_be_audited_by_user_id,
			Emp_name,
			Audit_Score,
			module,
			module_id,
			Audit_Type,
			Audit_type_id,
			color_code
	FROM (
		SELECT pln.audit_plan_id,
				FORMAT(pln.planned_date,'yyyy-MM-dd') planned_date, 
				FORMAT(pln.planned_date_end,'yyyy-MM-dd') planned_date_end, 
				loc.location_name,
				'' line_name,
				dbo.getAuditStatus(audit_plan_id)	Audit_status,
				pln.to_be_audited_by_user_id,
				dbo.getEmployeeName(pln.to_be_audited_by_user_id) AS emp_name,
				dbo.GetAuditScorebyAudit(dbo.GetAuditIDByPlanDate(FORMAT(pln.planned_date,'yyyy-MM-dd'),FORMAT(pln.planned_date_end,'yyyy-MM-dd'), 0)) Audit_Score,
				modu.module,
				modu.module_id,
				(select Audit_type from tbl_audit_type where ID=pln.audit_type_id) Audit_Type,
				pln.Audit_type_id,
				(select color_code from tbl_audit_type where ID=pln.audit_type_id) color_code
		FROM    tbl_audit_plan pln,
				--tbl_line_master lm,
				tbl_location_master loc,
				tbl_Module_master modu
		WHERE  pln.planned_date BETWEEN DATEADD(year, -1, CURRENT_TIMESTAMP)  AND DATEADD(year, 1, CURRENT_TIMESTAMP)
		AND    pln.location_id = ISNULL(@p_location_id, pln.location_id)
		--AND    pln.line_id = ISNULL(@p_line_id, pln.line_id)
		AND    pln.to_be_audited_by_user_id = ISNULL(@p_user_id, pln.to_be_audited_by_user_id)
		AND    pln.location_id = loc.location_id
		--AND    pln.line_id = lm.line_id
		AND	   pln.module_id=modu.module_id
		AND    pln.module_id=@p_module_id
		) tmp
		ORDER BY planned_date DESC 

END

--exec sp_GetAuditPlan 1,1,null,null
