update [dbo].[tbl_Module_master] set module='System Audit' WHERE module_id=1
update [dbo].[tbl_Module_master] set module='Process Audit' WHERE module_id=2
update [dbo].[tbl_Module_master] set module='Product Audit' WHERE module_id=3




CREATE TABLE tbl_process_master(id int IDENTITY(1,1), Process VARCHAR(MAX))
INSERT INTO tbl_process_master 
VALUES('Production'),('Maintainance'),('Purchase'),('Others')


ALTER TABLE tbl_user_master ADD process_id VARCHAR(MAX)
ALTER TABLE tbl_user_master DROP COLUMN module_id
ALTER TABLE tbl_user_master ADD module_id VARCHAR(MAX)
update tbl_user_master set module_id='2,3', process_id='1,3' WHERE user_id=6
update tbl_user_master set module_id='1,2', process_id='2,3'  WHERE user_id=5


INSERT INTO tbl_country_master(region_id,country_name)
VALUES(1,'USA'),(1,'Mexico')

INSERT INTO tbl_location_master(country_id,region_id,location_name,shift1_start_time,shift1_end_time,shift2_start_time,shift2_end_time,shift3_start_time, shift3_end_time,no_of_shifts)
VALUES(2,1,'Portage','09:00:00',	'17:00:00',	'17:00:00',	'01:00:00',	'01:00:00',	'09:00:00'	,3),
(3,1,'Saltillo','09:00:00',	'17:00:00',	'17:00:00',	'01:00:00',	'01:00:00',	'09:00:00'	,3)

insert into tbl_user_master(username,emp_full_name, emp_first_name, emp_last_name, email_id,display_name_flag,location_id,role,global_admin_flag,site_admin_flag, start_date,end_date,role_id,region_id,country_id, Admin_Type,process_id,module_id)
VALUES('anshul','Anshul Sinha','Anshul','Sinha','anshul@knstek.com','N',3,'Role1','','Y','2019-07-03','2020-07-03',1,1,3,'Local','1,2','1,3'),
('bsalla','Bakta Salla','Bakta','Salla','bsalla@knstek.com','N',2,'Role1','Y','','2019-07-03','2020-07-03',1,1,2,'Global','4','1,2,3')


update tbl_user_master SET passwd='05/YBD0F+Gk3mY/1zHUMb/6s4tf7MFN56OiOEOxEHyP+4GN4fiUqQXIixb0cUILh5dPxBr7Pu42tZESjoJlXxMsSwKYOjzYO9u6weOXK9Lg='

GO

CREATE FUNCTION [dbo].[SplitString]
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      Item NVARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT
 
      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
 
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
           
            INSERT INTO @Output(Item)
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END
 
      RETURN
END

GO

ALTER PROCEDURE [dbo].[sp_UserLogin](@username      varchar(100),
								@password  varchar(MAX))
AS
BEGIN

	DECLARE @l_count		INT;
	DECLARE @l_err_code		INT;
	DECLARE @l_err_message	VARCHAR(100);

	SELECT @l_count = count(*)
	FROM   tbl_user_master um
	WHERE um.username = @username
	AND   um.passwd = @password	;


	IF @l_count > 0 
	BEGIN

		SET @l_err_code = 0;
		SET @l_err_message = 'Login Successfull';

		
			SELECT user_id,
				role,
				role_id,
				email_id,
				emp_full_name,
				display_name_flag,
				global_admin_flag,
				site_admin_flag,
				region_id,
				region_name,
				country_id,
				country_name,
				location_id,
				location_name,
				template,
				err_code,
				err_message
			FROM(
				SELECT um.user_id,
					um.role,
					um.role_id,
					um.email_id,
					um.emp_full_name,
					um.display_name_flag,
					um.global_admin_flag,
					um.site_admin_flag,
					um.region_id,
					rm.region_name,
					um.country_id,
					cm.country_name,
					lm.location_id,
					lm.location_name,
					SUBSTRING(( SELECT ',' + module from tbl_Module_master where module_id in (Select Item from dbo.SplitString(um.module_id,',')) FOR XML PATH('')), 2 , 9999) As template,
					@l_err_code err_code,
					@l_err_message err_message
				FROM   tbl_user_master um,
						tbl_location_master lm,
						tbl_country_master cm,
						tbl_region_master rm
				WHERE um.location_id = lm.location_id
				AND   um.region_id = rm.region_id
				AND   um.country_id = cm.country_id
				AND   um.username = @username
				AND   um.passwd = @password
				AND (um.end_date is null OR um.end_date>=GETDATE())		
			) t
				
	END;
	ELSE
	BEGIN

		SET @l_err_code = 2000;
		SET @l_err_message = 'Username or Password is incorrect';

		
		SELECT * FROM (SELECT @l_err_code err_code, @l_err_message err_message) a 
		

	END;
END


GO

update tbl_line_master set region_id=2


ALTER TABLE tbl_line_master ADD module_id VARCHAR(MAX)
update tbl_line_master set module_id='3' WHERE line_id=7
update tbl_line_master set module_id='3' WHERE line_id=6
update tbl_line_master set module_id='2' WHERE line_id=5
update tbl_line_master set module_id='1,2' WHERE line_id=4

GO

CREATE PROCEDURE sp_GetProductsForLine(@p_line_id INT, @module_id INT)
AS
BEGIN

	IF EXISTS(Select Item from dbo.SplitString((SELECT module_id FROM tbl_line_master WHERE line_id=@p_line_id),',') WhERE Item=@module_id)
	BEGIN
		IF EXISTS(SELECT product_id, product_name, @p_line_id line_id FROM tbl_product_master WHERE product_id in (SELECT product_id FROM tbl_line_product_relationship where line_id=@p_line_id))
		BEGIN
			SELECT product_id, product_name, @p_line_id line_id FROM tbl_product_master WHERE product_id in (
			SELECT product_id FROM tbl_line_product_relationship where line_id=@p_line_id)
		END
		ELSE
		BEGIN
			SELECT 0 product_id, 'No product is available for the selected line.' product_name, @p_line_id line_id
		END
	END
	ELSE
	BEGIN
		SELECT 0 product_id, 'Line and module mapping is wrong.' product_name, 0 line_id
	END
END


GO


/****** Object:  Table [dbo].[tbl_question_master]    Script Date: 10/9/2019 1:32:15 PM ******/
DROP TABLE [dbo].[tbl_question_master]
GO

CREATE TABLE [dbo].[tbl_question_master](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[question_id] [int] NOT NULL,
	[section_id] [int] NULL,
	[question] [varchar](1000) NULL,
	[module_id] INT,
 CONSTRAINT [id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


INSERT INTO [dbo].[tbl_question_master] (question_id,question, module_id)
VALUES(1, 'Check all closer evidence of last last product audit & process audit',3),
(2, 'Check effectiveness of countermeasure of previous customer complaint.',3),
(3, 'Safety Content (Mask , Hand Gloves , Goggles & Shoes',3),
(4, '1S & 2 S Activity',3),
(5, 'Work Instruction(WI on its place, understanding of operator according WI, Operator working as per WI or not.',3),
(6, 'Check Sheet (Knowledge of check sheet)',3),
(7, 'Master Sample with expire date.',3),
(8, 'Machine Condition (working condition)',3),
(9, 'Control Parameter Chart',3),
(10, 'Machine Parameter',3),
(11, 'Instrument & Gauge availibilty',3),
(12, 'Calibration (M/c , Gauge & Instruments)',3),
(13, 'Identification Tag',3),
(14, 'FIFO & Tracebility.',3),
(15, 'Material Handling',3),
(16, 'Packing Method.',3),
(17, 'Cp & Cpk of critical Dimn.',3),
(18, 'I st of approval part in work place.',3),
(19, 'Skill level of operator',3),
(20, 'Lux level.',3),
(21, 'Tool & M/c Preventive Record',3),
(22, 'Cohrence ( Refer to conhrence check sheet).',3),
(23, '4 M change status',3),
(1, 'Check all closer evidence of last last product audit & process audit',2),
(2, 'Check effectiveness of countermeasure of previous customer complaint.',2),
(3, 'Safety Content (Mask , Hand Gloves , Goggles & Shoes',2),
(4, '1S & 2 S Activity',2),
(5, 'Work Instruction(WI on its place, understanding of operator according WI, Operator working as per WI or not.',2),
(6, 'Check Sheet (Knowledge of check sheet)',2),
(7, 'Master Sample with expire date.',2),
(8, 'Machine Condition (working condition)',2),
(9, 'Control Parameter Chart',2),
(10, 'Machine Parameter',2),
(11, 'Instrument & Gauge availibilty',2),
(12, 'Calibration (M/c , Gauge & Instruments)',2),
(13, 'Identification Tag',2),
(14, 'FIFO & Tracebility.',2),
(15, 'Material Handling',2),
(16, 'Packing Method.',2),
(17, 'Cp & Cpk of critical Dimn.',2),
(18, 'I st of approval part in work place.',2),
(19, 'Skill level of operator',2),
(20, 'Lux level. for Process Audit',2),
(21, 'Tool & M/c Preventive Record for Process Audit',2),
(22, 'Cohrence ( Refer to conhrence check sheet for Process Audit).',2),
(23, '4 M change status for Process Audit',2),
(1, 'Safety Content (Mask , Hand Gloves , Goggles & Shoes',1),
(2, '1S & 2 S Activity',1),
(3, 'Check Sheet (Knowledge of check sheet)',1),
(4, 'Master Sample with expire date.',1),
(5, 'Machine Condition (working condition)',1),
(6, 'Control Parameter Chart',1),
(7, 'Machine Parameter',1),
(8, 'Instrument & Gauge availibilty',1),
(9, 'Calibration (M/c , Gauge & Instruments)',1),
(10, 'Identification Tag',1),
(11, 'FIFO & Tracebility.',1),
(12, 'Material Handling',1),
(13, 'Packing Method.',1),
(14, 'Cp & Cpk of critical Dimn.',1),
(15, 'I st of approval part in work place.',1),
(16, 'Skill level of operator',1),
(17, 'Lux level.',1),
(18, 'Tool & M/c Preventive Record',1),
(19, 'Cohrence ( Refer to conhrence check sheet).',1),
(20, '4 M change status',1)
GO


CREATE PROCEDURE sp_getQuestionList(
@module_id INT
)
AS
BEGIN
SELECT question_id, question FROM tbl_question_master WHERE module_id=@module_id
END

CREATE PROCEDURE sp_GetProcessList
AS
BEGIN
	select id Process_id, Process process_name from tbl_process_master
END