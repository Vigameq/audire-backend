USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_getRoleDetails]    Script Date: 19-05-2020 10:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_getRoleDetails]
AS
BEGIN
SET FMTONLY OFF
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
