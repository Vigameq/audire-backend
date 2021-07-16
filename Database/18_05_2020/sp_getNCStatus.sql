CREATE procedure sp_getNCStatus
(
@location_id int,
@module_id INT,
@Status VARCHAR(MAX)
)
AS
BEGIN
Select t.audit_id, t.Audit_number, t.module, t.Audit_Type, t.report_date, t.emp_full_name, t.tot_nc, t1.completed_nc INTO #temp
FROM
(Select ans.audit_id, ans.Audit_number, m.module, typ.Audit_Type, ans.report_date, u.emp_full_name, count(*) tot_nc
from tbl_AuditResult ans LEFT JOIN tbl_Module_master m ON ans.module_id=m.module_id
LEFT JOIN tbl_audit_type typ ON ans.AuditType_id=typ.ID
LEFT JOIN tbl_user_master u ON ans.audit_performed_by=u.user_id
WHERE ans.answer IN (1,11)
GROUP BY ans.audit_id, ans.Audit_number, m.module, typ.Audit_Type, ans.report_date, u.emp_full_name) t
JOIN 
(Select ans.audit_id, ans.Audit_number, m.module, typ.Audit_Type, ans.report_date, u.emp_full_name, count(*) completed_nc
from tbl_AuditResult ans LEFT JOIN tbl_Module_master m ON ans.module_id=m.module_id
LEFT JOIN tbl_audit_type typ ON ans.AuditType_id=typ.ID
LEFT JOIN tbl_user_master u ON ans.audit_performed_by=u.user_id
WHERE ans.answer IN (1,11)
GROUP BY ans.audit_id, ans.Audit_number, m.module, typ.Audit_Type, ans.report_date, u.emp_full_name) t1
ON t.audit_id=t1.audit_id

IF(@Status='Completed')
BEGIN
Select audit_id, Audit_number, module, Audit_Type, report_date, emp_full_name, tot_nc, completed_nc FROM #temp
END
END