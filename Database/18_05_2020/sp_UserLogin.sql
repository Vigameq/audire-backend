USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_UserLogin]    Script Date: 05-06-2020 14:32:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
				--global_admin_flag,
				--site_admin_flag,
				region_id,
				region_name,
				country_id,
				country_name,
				location_id,
				location_name,
				module_id,
				profile_pic,
				role_access,
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
					um.module_id,
					um.profile_pic,
					(Select role_access from tbl_role_master where Role_id= um.role_id) role_access,
					--SUBSTRING(( SELECT ',' + module from tbl_Module_master where module_id in (Select Item from dbo.SplitString(um.module_id,',')) FOR XML PATH('')), 2 , 9999) As template,
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
				AND (um.start_date is null OR um.start_date<=GETDATE())		
				AND (um.end_date is null OR um.end_date>=GETDATE())		
			) t
			
			select * from tbl_module_master mm JOIN (Select Item from dbo.SplitString((SELECT module_id FROm tbl_user_master WHERE username = @username
				AND   passwd = @password
				AND (end_date is null OR end_date>=GETDATE())
				AND (start_date is null OR start_date<=GETDATE())),',')) t2 ON mm.module_id=t2.Item
			
				
	END;
	ELSE
	BEGIN

		SET @l_err_code = 2000;
		SET @l_err_message = 'Username or Password is incorrect';

		
		SELECT * FROM (SELECT @l_err_code err_code, @l_err_message err_message) a 
		

	END;
END

