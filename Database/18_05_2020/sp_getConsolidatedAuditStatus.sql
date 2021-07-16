--exec sp_getConsolidatedAuditStatus 2,2,8
CREATE PROCEDURE sp_getConsolidatedAuditStatus
(
@location_id INT,
@module_id INT,
@user_id INT
)
AS
BEGIN
DECLARE @Role VARCHAR(10)
Select @Role=Role_Access from tbl_role_master WHERE Role_id=(Select role_id from tbl_user_master where user_id=@user_id)

Select  mm.module, typ.Audit_Type, temp.audit_performed_date, um.emp_full_name, temp.Audit_number, temp.audit_id,
CASE WHEN ISNULL(nc_count,0)=ISNULL(nc_review_count,0) THEN 'Success' ELSE 
 CASE WHEN DATEADD(DD,90,audit_performed_date)>=GETDATE() THEN 'IN-Progress' ELSE 'Delayed' END END 'Status'

 from 

(select t.audit_id,module_id, region_id, country_id, location_id, Audit_Number, AuditType_id, audit_performed_by,audit_performed_date, t.tot_count, t2.nc_count, t1.nc_review_count from
(select audit_id, module_id, region_id, country_id, location_id, Audit_Number, AuditTYpe_id, audit_performed_by,audit_performed_date , count(*) tot_count 
from tbl_AuditResult group by audit_id, module_id, region_id, country_id, location_id, Audit_Number, AuditTYpe_id, audit_performed_by,audit_performed_date) t
LEFT JOIN
(select audit_id, count(*) nc_count from tbl_AuditResult where answer in (1,11)
group by audit_id) t2 ON t.audit_id=t2.audit_id 
LEFT JOIN
(select audit_id, count(*) nc_review_count from tbl_AuditResult where review_status=0
group by audit_id) t1 ON t.audit_id=t1.audit_id) temp
JOIN tbl_Module_master mm ON temp.module_id=mm.module_id
JOIN tbl_audit_type typ ON typ.ID=temp.AuditType_id
JOIN tbl_user_master um ON temp.audit_performed_by=um.user_id

WHERE temp.location_id=@location_id
AND temp.module_id=@module_id
AND temp.audit_performed_by=CASE WHEN @Role='2' THEN @user_id ELSE temp.audit_performed_by END

END