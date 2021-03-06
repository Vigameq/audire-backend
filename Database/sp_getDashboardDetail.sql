USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_getDashboardDetail]    Script Date: 12/31/2019 11:31:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec sp_getDashboardDetail 2,'5S'
ALTER PROCEDURE [dbo].[sp_getDashboardDetail]
(
@Module_id INT,
@module_name VARCHAR(200)=null
)
AS
BEGIN
declare @tot_answer INT,  @no_answer INT, @open_NC INT, @closed_NC INT, @monthly_score INT, @tot_audit INt, @pending INT, @relative float
IF(@module_name LIKE '5S%')
BEGIN
select @tot_answer= Count(*) from tbl_AuditResult 
where module_id=@Module_id
AND ((@Module_id=1 AND answer IN (0,1,11,2) ) OR (@Module_id!=1 AND answer IN (0,1)))
AND (AuditType_id=(Select ID from tbl_audit_type Where audit_type like '5S%'))
GROUP BY module_id

select @no_answer=Count(*) from tbl_AuditResult 
where module_id=@Module_id
AND ((@Module_id=1 AND answer IN (1,11) ) OR (@Module_id!=1 AND answer IN (1)))
AND (AuditType_id=(Select ID from tbl_audit_type Where audit_type like '5S%'))
GROUP BY module_id

select @closed_NC= Count(*) from tbl_AuditResult 
where module_id=@Module_id
AND ((@Module_id=1 AND answer IN (1,11) ) OR (@Module_id!=1 AND answer IN (1)))
AND (AuditType_id=(Select ID from tbl_audit_type Where audit_type like '5S%'))
AND review_status=1
GROUP BY module_id

select @open_NC= Count(*) from tbl_AuditResult 
where module_id=@Module_id
AND ((@Module_id=1 AND answer IN (1,11) ) OR (@Module_id!=1 AND answer IN (1)))
AND (AuditType_id=(Select ID from tbl_audit_type Where audit_type like '5S%'))
AND (review_status<>1 OR review_status is null)
GROUP BY module_id

Select @tot_audit=Count(*) from (Select distinct audit_id from tbl_AuditResult where module_id=@Module_id 
AND (AuditType_id=(Select ID from tbl_audit_type Where audit_type like '5S%'))
) t

END
ELSE
BEGIN
select @tot_answer= Count(*) from tbl_AuditResult 
where module_id=@Module_id
AND ((@Module_id=1 AND answer IN (0,1,11,2) ) OR (@Module_id!=1 AND answer IN (0,1)))
GROUP BY module_id

select @no_answer=Count(*) from tbl_AuditResult 
where module_id=@Module_id
AND ((@Module_id=1 AND answer IN (1,11) ) OR (@Module_id!=1 AND answer IN (1)))
GROUP BY module_id

select @closed_NC= Count(*) from tbl_AuditResult 
where module_id=@Module_id
AND ((@Module_id=1 AND answer IN (1,11) ) OR (@Module_id!=1 AND answer IN (1)))
AND review_status=1
GROUP BY module_id

select @open_NC= Count(*) from tbl_AuditResult 
where module_id=@Module_id
AND ((@Module_id=1 AND answer IN (1,11) ) OR (@Module_id!=1 AND answer IN (1)))
AND (review_status<>1 OR review_status is null)
GROUP BY module_id

Select @tot_audit=Count(*) from (Select distinct audit_id from tbl_AuditResult where module_id=@Module_id) t


END

set @monthly_score=@no_answer*100/@tot_answer
Set @pending=9
 set @relative=10.5

 SELECT ISNULL(@open_NC,0) open_NC, ISNULL(@closed_NC,0) closed_NC, ISNULL(@monthly_score,0) monthly_score, 
 ISNULL(@tot_audit,0) tot_audit, ISNULL(@pending,0) pending, ISNULL(@relative,0) relative_change

END

