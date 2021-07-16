ALTER PROCEDURE sp_getOpenTasks
(
@p_region_id INT,
@p_country_id INT,
@p_location_id INT,
@p_line_id INT,
@module_id INT,
@p_user_id INT
)
As
--exec sp_getOpenTasks 2,1,1,4,1,7
BEGIN
DECLARE @audit_id INT, @process_id VARCHAR(100)

SELECT @process_id=process_id from tbl_user_master where user_id=@p_user_id

select @audit_id= MAX(audit_id) from tbl_AuditResult 
WHERE region_id=ISNULL(@p_region_id,region_id) 
AND country_id=ISNULL(@p_country_id, country_id)
AND location_id=ISNULL(@p_location_id, location_id)
AND line_id=@p_line_id
AND module_id=@module_id

Select id answer_id,audit_id,question_id,answer,audit_comment ,audit_images
from tbl_AuditResult 
WHERE audit_id=@audit_id AND answer=1 AND assigned_To in ( Select Item from dbo.SplitString(@process_id,','))

END

GO

CREATE TYPE [dbo].[AnsReviewsTableType] AS TABLE(
	[answer_id] [int] NULL,
	[review_closed_on] [varchar](50) NULL,
	[review_closed_status] [int] NULL,
	[review_comments] [nvarchar](MAX) NULL,
	[review_image_file_name] [varchar](1000) NULL
)
GO
ALTER PROCEDURE [dbo].[sp_InsAuditReview]
(
@audit_id int,
@p_line_id int,
@module_id int,
@p_user_id int,
@deviceID VARCHAR(MAX),
@ReviewTable AnsReviewsTableType READONLY,
@l_err_code				int OUTPUT,
@l_err_message			varchar(MAX) OUTPUT
)
AS
BEGIN

DECLARE @score float

BEGIN	

SET @l_err_code = 0;
	SET @l_err_message = 'Initializing';
	IF EXISTS(Select * from tbl_AuditResult WHERE audit_id=@audit_id)
	BEGIN
		UPDATE t 
			SET t.review_status=t2.review_closed_status,
			t.review_comment=t2.review_comments,
			t.reviewed_date=CONVERT(Datetime, t2.review_closed_on, 105),
			t.reviewed_by=@p_user_id,
			t.reviewed_on=@deviceID
		FROM tbl_AuditResult t join @ReviewTable t2 
			ON t.audit_id=@audit_id AND t.id=t2.answer_id

		SET @l_err_code = 0;
		SET @l_err_message = 'Audit review is done successfully';

	END
	ELSE
		SET @l_err_code = @audit_id;
		SET @l_err_message = 'Error : Audit id is required for Audit review.';

	END
	
END
GO