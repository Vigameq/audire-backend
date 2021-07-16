select * from tbl_role_master

DROP TABLE  tbl_role_master

CREATE TABLE tbl_role_master(
Role_id INT IDENTITY(1,1) PRIMARY KEY,
Role_name VARCHAR(200),
Role_Access VARCHAR(MAX)
)


CREATE TABLE tbl_permissions
(
ID INT IDENTITY(1,1),
Permission VARCHAR(100)
)

INSERT INTO tbl_permissions(Permission)
VALUES('Admin'),('Read'),('Create'),('Update')




update tbl_user_master set role='Administrator', role_id=1 where global_admin_flag='Y'

ALTER PROCEDURE sp_getRoleDetails
AS
BEGIN

Select r.Role_id, r.Role_name, emp_full_name, r.Role_Access INTO #role_temp from tbl_role_master r JOIN  tbl_user_master u ON r.Role_id=u.role_id
WHERE u.end_date>=GETDATE() or u.end_date IS NULL

SELECT Main.Role_id, Main.Role_name, Main.Role_Access,
       LEFT(Main.users,Len(Main.users)-5) As users
FROM
    (
        SELECT DISTINCT ST2.Role_id, ST2.Role_name, ST2.Role_Access,
            (
                SELECT ST1.emp_full_name + '<br/>' AS [text()]
                FROM #role_temp ST1
                WHERE ST1.Role_id = ST2.Role_id
                ORDER BY ST1.Role_id
                FOR XML PATH ('')
            ) users
        FROM #role_temp ST2
    ) [Main]

DROP TABLE #role_temp

END

exec sp_getRoleDetails



ALTER TABLE tbl_AuditResult ADD IsCompleted VARCHAR(10)


ALTER TABLE tbl_audit_plan ADD audit_note VARCHAR(MAX)