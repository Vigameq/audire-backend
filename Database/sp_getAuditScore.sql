USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_getAuditScore]    Script Date: 12/31/2019 11:48:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_getAuditScore 2, 'week','5S'
ALTER PROCEDURE [dbo].[sp_getAuditScore]
(
@Module_id INT,
@scoreby VARCHAR(100),
@module_name VARCHAR(200)=null
)
AS
BEGIN

DECLARE @StartDate DATE, @EndDate DATE, @lastUpdate DATE
IF(UPPER(@scoreby)='WEEK')
BEGIN
	SELECT @StartDate=DATEADD(DAY, 2 - DATEPART(WEEKDAY, DATEADD(day, -7, GETDATE())), CAST(DATEADD(day, -7, GETDATE()) AS DATE))
	Select @EndDate=DATEADD(DAY, 8 - DATEPART(WEEKDAY, DATEADD(day, -7, GETDATE())), CAST(DATEADD(day, -7, GETDATE()) AS DATE))
END
ELSE IF(UPPER(@scoreby)='MONTH')
BEGIN
	select @StartDate=DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) --First day of previous month
	select @EndDate=DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)
END
ELSE IF(UPPER(@scoreby)='YEAR')
BEGIN
	select @StartDate=DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE())-1, 0) --First day of previous month
	select @EndDate=DATEADD(YEAR, DATEDIFF(YEAR, -1, GETDATE())-1, -1)
END

select AuditType_id, MAX(audit_id) id INTO #temp_id from tbl_AuditResult 
where module_id=@Module_id AND CAST(audit_performed_date AS DATE) BETWEEN @StartDate AND @EndDate
GROUP BY AuditType_id


select AuditType_id, Count(*) tot_answer INTO #temp_tot from tbl_AuditResult 
where module_id=@Module_id AND CAST(audit_performed_date AS DATE) BETWEEN @StartDate AND @EndDate
AND ((@Module_id=1 AND answer IN (0,1,11,2) ) OR (@Module_id!=1 AND answer IN (0,1)))
GROUP BY AuditType_id

select AuditType_id, Count(*) no_answer INTO #temp_no from tbl_AuditResult 
where module_id=@Module_id AND CAST(audit_performed_date AS DATE) BETWEEN @StartDate AND @EndDate
AND ((@Module_id=1 AND answer IN (1,11) ) OR (@Module_id!=1 AND answer IN (1)))
GROUP BY AuditType_id

select t1.AuditType_id, t2.no_answer*100/t1.tot_answer score INTO #temp_score FROM #temp_tot t1 JOIN #temp_no t2 ON t1.AuditType_id=t2.AuditType_id

select AuditType_id, 
(Select top 1 audit_performed_date FROM tbl_AuditResult WHERE AuditType_id=t.AuditType_id AND audit_id=t.id) last_date, 
(Select top 1 location_id FROM tbl_AuditResult WHERE AuditType_id=t.AuditType_id AND audit_id=t.id) location_id 
INTO #temp_date from #temp_id t
--GROUP BY t.AuditType_id

IF(@module_name LIKE '5S%')
BEGIN
Select ta.Audit_Type,ta.ID Audit_Type_id,
 (Select score from #temp_score WHERE AuditType_id=ta.ID) score, 
 (Select last_date from #temp_date WHERE AuditType_id=ta.ID) last_date,
 (select location_name from tbl_location_master where location_id=(select location_id FROM #temp_date WHERE AuditType_id=ta.ID)) location
from tbl_audit_type ta WHERE module_id=@Module_id 
AND Audit_Type LIKE '5S%'
END
ELSE
BEGIN
Select ta.Audit_Type,ta.ID Audit_Type_id,
 (Select score from #temp_score WHERE AuditType_id=ta.ID) score, 
 (Select last_date from #temp_date WHERE AuditType_id=ta.ID) last_date,
 (select location_name from tbl_location_master where location_id=(select location_id FROM #temp_date WHERE AuditType_id=ta.ID)) location
from tbl_audit_type ta WHERE module_id=@Module_id 
END
END


