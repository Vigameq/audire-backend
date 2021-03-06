USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_InsAnswers]    Script Date: 20-05-2020 17:59:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[sp_InsAnswers]
(
@audit_id int=null,
@p_region_id int,
@p_country_id int,
@p_location_id int,
@p_line_id int,
@p_product_id int=null,
@module_id int,
@p_user_id int,
@deviceID VARCHAR(MAX),
@p_shift_no INT,
@auditType_id INT,
@part_name VARCHAR(MAX)=null,
@auditor_comment VARCHAR(MAX)=null,
@IsCompleted VARCHAR(10)=null,
@AnswerTable AnswersTableType READONLY
)
AS
BEGIN


DECLARE @audit_number varchar(100), @code VARCHAR(10)

IF(@module_id=1)
SET @code='CO'
ELSE IF(@module_id=2)
SET @code='PR'
ELSE IF(@module_id=3)
SET @code='PA'
ELSE
SET @code='SU'

INSERT INTO [dbo].[tbl_temp_AnsResultsTableType](question_id,Answer,remarks, image_file_name, audit_id)
SELECT question_id,Answer,comment, img_content,@audit_id from @AnswerTable


DECLARE @score float
If(@audit_id is null OR @audit_id=0)
BEGIN
	exec GetMaxAuditId @audit_id output
	--Select @audit_id = MAX(audit_id) FROM tbl_AuditResult
	If(@audit_id is null OR @audit_id=0)
		SET @audit_id=1
	--ELSE SET @audit_id+=1

	SET @audit_number=CONCAT('VIG ',@code,' ', CONVERT(VARCHAR(10),@audit_id))

	INSERT INTO tbl_AuditResult(audit_id, question_id,answer,audit_comment,assigned_To,module_id,region_id,country_id,location_id,line_id,product_id,audit_performed_by,audit_performed_on,audit_performed_date, shift_no, AuditType_id, Part_Name, audit_images,Auditor_Comment, audit_number, IsCompleted)
	SELECT @audit_id,question_id,Answer, comment, assignedTo, @module_id,@p_region_id, @p_country_id,@p_location_id, @p_line_id, @p_product_id,@p_user_id,@deviceID,GETDATE(), @p_shift_no, @auditType_id, @part_name, img_content, @auditor_comment,@audit_number,@IsCompleted FROM @AnswerTable

END
ELSE
BEGIN

	SET @audit_number=CONCAT('VIG ',@code,' ', CONVERT(VARCHAR(10),@audit_id))
IF EXISTS(Select * from tbl_AuditResult WHERE audit_id=@audit_id)
BEGIN
	UPDATE t 
	SET t.answer=t2.Answer,
	t.audit_comment=t2.comment,
	t.assigned_To=t2.assignedTo,
	t.audit_images=ISNULL(t2.img_content,t.audit_images),
	t.IsCompleted=@IsCompleted
	FROM tbl_AuditResult t join @AnswerTable t2 
	ON t.audit_id=@audit_id AND t.question_id=t2.question_id
END
ELSE
BEGIN

INSERT INTO tbl_AuditResult(audit_id, question_id,answer,audit_comment,assigned_To,module_id,region_id,country_id,location_id,line_id,product_id,audit_performed_by,audit_performed_on,audit_performed_date, shift_no, AuditType_id, Part_name,audit_images,Auditor_Comment,audit_number, IsCompleted)
	SELECT @audit_id,question_id,Answer, comment, assignedTo, @module_id,@p_region_id, @p_country_id,@p_location_id, @p_line_id, @p_product_id,@p_user_id,@deviceID,GETDATE(), @p_shift_no, @auditType_id, @part_name,img_content, @auditor_comment, @audit_number, @IsCompleted FROM @AnswerTable

END

END
	
	IF EXISTS(Select * from tbl_AuditResult WHERE audit_id=@audit_id)
	BEGIN
		Select @score=dbo.GetAuditScorebyAudit(@audit_id)
		Select @audit_id audit_id, @score score, 200 err_code, 'Success' err_message
		
		if(@module_id=3)
			
Select  ans.module_id
,typ.ID auditType_id
,typ.Audit_Type
,ans.audit_id
,loc.location_name
,ans.audit_performed_by
,FORMAT(ans.audit_performed_date,'dd-MM-yyyy') Audit_date
,us.emp_full_name
,ans.question_id
,REPLACE(que.question,'&','&amp;') question
,ans.answer
,ans.audit_comment
,pro.Process assignedTo
, dbo.GetAuditScorebyAudit(@audit_id) Score
, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (0,1,11,2)) 'tot_answer'
, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (0)) 'yes_answer'
, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (1)) 'no_answer'
, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (2)) 'NA_answer'
, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (11)) 'Minor_answer'
,FORMAT(DATEADD(MM,3,ans.audit_performed_date) ,'dd-MM-yyyy') dueDate
,que.clause
FROM tbl_AuditResult ans
JOIN tbl_question_master que ON ans.question_id=que.question_id AND ans.module_id=que.module_id  
--AND ans.AuditType_id=que.Audit_type_id
JOIN tbl_location_master loc ON ans.location_id=loc.location_id
LEFT JOIN tbl_process_master pro ON ans.assigned_To=pro.id
JOIN tbl_user_master us ON ans.audit_performed_by=us.user_id
JOIN tbl_audit_type typ ON typ.ID=ans.AuditType_id
WHERE audit_id=@audit_id AND ans.answer is not null
		AND que.module_id=@module_id AND (Audit_type_id=ISNULL(@auditType_id,Audit_type_id)	OR Audit_type_id is null)

--		UNION
--Select  ans.module_id
--,typ.ID auditType_id
--,typ.Audit_Type
--,ans.audit_id
--,loc.location_name
--,ans.audit_performed_by
--,FORMAT(ans.audit_performed_date,'dd-MM-yyyy') Audit_date
--,us.emp_full_name
--,ans.question_id
--,que.question
--,ans.answer
--,ans.audit_comment
--,pro.Process assignedTo
--, dbo.GetAuditScorebyAudit(@audit_id) Score
--, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (0,1,11,2)) 'tot_answer'
--, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (0)) 'yes_answer'
--, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (1)) 'no_answer'
--, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (2)) 'NA_answer'
--, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (11)) 'Minor_answer'
--,FORMAT(DATEADD(MM,3,ans.audit_performed_date) ,'dd-MM-yyyy') dueDate
--FROM tbl_AuditResult ans
--JOIN tbl_question_master que ON ans.question_id=que.question_id AND ans.module_id=que.module_id  AND ans.AuditType_id=que.Audit_type_id
--JOIN tbl_location_master loc ON ans.location_id=loc.location_id
--LEFT JOIN tbl_process_master pro ON ans.assigned_To=pro.id
--JOIN tbl_user_master us ON ans.audit_performed_by=us.user_id
--JOIN tbl_audit_type typ ON typ.ID=ans.AuditType_id
--WHERE audit_id=@audit_id AND ans.answer is not null
--		AND que.module_id=@module_id 
		ELSE
		Select  ans.module_id
,typ.ID auditType_id
,typ.Audit_Type
,ans.audit_id
,loc.location_name
,ans.audit_performed_by
,FORMAT(ans.audit_performed_date,'dd-MM-yyyy') Audit_date
,us.emp_full_name
,ans.question_id
,REPLACE(que.question,'&','&amp;') question
,ans.answer
,ans.audit_comment
,pro.Process assignedTo
, dbo.GetAuditScorebyAudit(@audit_id) Score
, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (0,1,11,2)) 'tot_answer'
, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (0)) 'yes_answer'
, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (1)) 'no_answer'
, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (2)) 'NA_answer'
, (Select count(*) FROM tbl_AuditResult WHERE audit_id=@audit_id and answer IN (11)) 'Minor_answer'
,FORMAT(DATEADD(MM,3,ans.audit_performed_date) ,'dd-MM-yyyy') dueDate
,que.clause
FROM tbl_AuditResult ans
JOIN tbl_question_master que ON ans.question_id=que.question_id AND ans.module_id=que.module_id  AND ans.AuditType_id=que.Audit_type_id
JOIN tbl_location_master loc ON ans.location_id=loc.location_id
LEFT JOIN tbl_process_master pro ON ans.assigned_To=pro.id
JOIN tbl_user_master us ON ans.audit_performed_by=us.user_id
JOIN tbl_audit_type typ ON typ.ID=ans.AuditType_id
WHERE audit_id=@audit_id AND ans.answer is not null

		
		CREATE TABLE #temp_t(process_id INT,process VARCHAR(100),user_id VARCHAR(MAX),emp_full_name VARCHAR(MAX))
		
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


		INSERT INTO #temp_t(process_id ,process,user_id ,emp_full_name )
		
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
		
		
		DECLARE @assigned_id INT
		DECLARE assigned_cursor CURSOR FOR     
		SELECT distinct assigned_To from tbl_AuditResult  WHERE audit_id=@audit_id AND answer in ('1','11')    
		  
		OPEN assigned_cursor    
		  
		FETCH NEXT FROM assigned_cursor     
		INTO @assigned_id    
		 
		WHILE @@FETCH_STATUS = 0    
		BEGIN    
		  
		  
		Select ans.audit_id
		,m.module
		,typ.Audit_Type
				,loc.location_name
				,us.emp_full_name 'Auditor'
				,ans.question_id
				,que.question
				,ans.audit_comment 'Auditor_comment'
				,STUFF  (       (  
		       SELECT DISTINCT ', ' + CAST(email_id AS VARCHAR(MAX))  
		       FROM tbl_user_master   
		       where user_id in(Select Item from dbo.SplitString(t.user_id,','))
		       FOR XML PATH('')  
		     ),1,1,'' ) to_email_ids,
			 pro.Process
				FROM tbl_AuditResult ans 
				JOIN tbl_question_master que ON ans.question_id=que.question_id AND ans.module_id=que.module_id  AND ans.AuditType_id=que.Audit_type_id
				JOIN tbl_location_master loc ON ans.location_id=loc.location_id
				LEFT JOIN tbl_process_master pro ON ans.assigned_To=pro.id 
				JOIN tbl_user_master us ON ans.audit_performed_by=us.user_id
				JOIN tbl_Module_master m ON m.module_id=ans.module_id
				JOIN tbl_audit_type typ ON typ.ID=ans.AuditType_id
				JOIN #temp_t t ON t.process_id=ans.assigned_To
				WHERE audit_id=@audit_id AND ans.answer in ('1','11') AND ans.assigned_To=@assigned_id
		      
		    FETCH NEXT FROM assigned_cursor     
		INTO @assigned_id    
		   
		END     
		CLOSE assigned_cursor;    
		DEALLOCATE assigned_cursor;    
		DROP TABLE #temp_t

	END
	ELSE
	BEGIN
		SElECT 0 err_code, 'There is error in insertion.' err_message
	END
	
END

