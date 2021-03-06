USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_getUserList]    Script Date: 23-12-2019 11:32:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_getUserList]
AS
BEGIN

SELECT [user_id]
      ,[username]
      ,[passwd]
      ,[emp_full_name]
      ,[display_name_flag]
      ,[email_id]
      ,[location_id]
      ,[role]
      ,[global_admin_flag]
      ,[site_admin_flag]
      ,[start_date]
      ,[end_date]
      ,[role_id]
      ,[region_id]
      ,[country_id]
      ,[emp_first_name]
      ,[emp_last_name]
      ,[Admin_Type]
      ,[process_id]
      ,[module_id]
	  ,STUFF((SELECT ',' + t.module
            FROM (select module from tbl_Module_master where module_id in (select * from dbo.SplitString((select module_id from tbl_user_master where user_id=tu.user_id),','))) t
            FOR XML PATH('')) ,1,1,'') AS module
	  ,STUFF((SELECT ',' + t1.Process
            FROM (select process from tbl_process_master where id in (select * from dbo.SplitString((select process_id from tbl_user_master where user_id=tu.user_id),','))) t1
            FOR XML PATH('')) ,1,1,'') AS process
	,(SELECT l.location_name
            FROM (select location_name from tbl_location_master where location_id in (select location_id from tbl_user_master where location_id=tu.location_id)) l
            ) AS location
  FROM [dbo].[tbl_user_master] tu

END
