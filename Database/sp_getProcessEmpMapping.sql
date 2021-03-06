CREATE PROCEDURE sp_getProcessEmpMapping
AS
BEGIN
--exec sp_getProcessEmpMapping

;WITH tmp(user_id, emp_full_name, DataItem, process_id) AS
(
    SELECT
        user_id,
		emp_full_name,
        LEFT(process_id, CHARINDEX(',', process_id + ',') - 1),
        STUFF(process_id, 1, CHARINDEX(',', process_id + ','), '')
    FROM tbl_user_master
    UNION all

    SELECT
        user_id,
        emp_full_name,
        LEFT(process_id, CHARINDEX(',', process_id + ',') - 1),
        STUFF(process_id, 1, CHARINDEX(',', process_id + ','), '')
    FROM tmp
    WHERE
        process_id > ''
)

SELECT
    user_id,
    emp_full_name,
    DataItem
INTO #temp
FROM tmp
ORDER BY user_id

Select user_id, emp_full_name, DataItem process_id, (Select process from tbl_process_master where id=DataItem) process INTO #temp1 from #temp

SELECT DISTINCT t2.process_id, t2.process,
    SUBSTRING(
        (
            SELECT ','+CONVERT(VARCHAR(10),t1.user_id)  AS [text()]
            FROM #temp1 t1
            WHERE t1.process_id = t2.process_id
            ORDER BY t1.process_id
            FOR XML PATH ('')
        ), 2, 1000) [user_id],

		SUBSTRING(
        (
            SELECT ','+t1.emp_full_name  AS [text()]
            FROM #temp1 t1
            WHERE t1.process_id = t2.process_id
            ORDER BY t1.process_id
            FOR XML PATH ('')
        ), 2, 1000) emp_full_name
FROM #temp1 t2


END