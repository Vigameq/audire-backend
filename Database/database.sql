USE [master]
GO
/****** Object:  Database [Audire_db]    Script Date: 6/21/2019 10:13:57 AM ******/
CREATE DATABASE [Audire_db]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Audire_db', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Audire_db.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Audire_db_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Audire_db_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Audire_db] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Audire_db].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Audire_db] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Audire_db] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Audire_db] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Audire_db] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Audire_db] SET ARITHABORT OFF 
GO
ALTER DATABASE [Audire_db] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Audire_db] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Audire_db] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Audire_db] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Audire_db] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Audire_db] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Audire_db] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Audire_db] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Audire_db] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Audire_db] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Audire_db] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Audire_db] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Audire_db] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Audire_db] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Audire_db] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Audire_db] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Audire_db] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Audire_db] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Audire_db] SET RECOVERY FULL 
GO
ALTER DATABASE [Audire_db] SET  MULTI_USER 
GO
ALTER DATABASE [Audire_db] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Audire_db] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Audire_db] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Audire_db] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Audire_db', N'ON'
GO
USE [Audire_db]
GO
/****** Object:  User [knsuser]    Script Date: 6/21/2019 10:13:57 AM ******/
CREATE USER [knsuser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [kns]    Script Date: 6/21/2019 10:13:57 AM ******/
CREATE USER [kns] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLocations]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetLocations](@p_user_id		INT=null)
AS
BEGIN
	
	DECLARE @l_location_id 			INT;
	DECLARE @l_global_admin			VARCHAR(1);
	DECLARE @l_local_admin			VARCHAR(1);


	SELECT @l_global_admin = ISNULL(global_admin_flag,'N'),
		@l_local_admin = ISNULL(site_admin_flag,'N'),
		@l_location_id = location_id
	FROM   tbl_user_master
	WHERE  user_id = @p_user_id;

	SELECT DISTINCT loc.location_id,
	country_id,
	region_id,
		location_code,
		location_name,
		[dbo].[Getshift](loc.location_id) as Shift_no
		, shift1_start_time
		,shift1_end_time
		, shift2_start_time
		,shift2_end_time
		, shift3_start_time
		,shift3_end_time
	FROM   tbl_location_master loc
	WHERE   ( @l_global_admin = 'Y' OR loc.location_id = @l_location_id)
	ORDER BY location_name ;

END;


GO
/****** Object:  Table [dbo].[tbl_audit_plan]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_audit_plan](
	[audit_plan_id] [int] IDENTITY(100,1) NOT NULL,
	[to_be_audited_by_user_id] [int] NULL,
	[planned_date] [datetime] NULL,
	[shift_no] [int] NULL,
	[line_product_rel_id] [int] NULL,
	[notification_sent_flag] [varchar](1) NULL,
	[to_be_audited_by_group_id] [int] NULL,
	[planned_date_end] [datetime] NULL,
	[line_id] [int] NULL,
	[location_id] [int] NULL,
 CONSTRAINT [PK_PLANTID] PRIMARY KEY CLUSTERED 
(
	[audit_plan_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_audit_plan_interface]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_audit_plan_interface](
	[location_id] [int] NULL,
	[line_id] [int] NULL,
	[line_name] [varchar](100) NULL,
	[year] [int] NULL,
	[wk1] [varchar](max) NULL,
	[wk2] [varchar](max) NULL,
	[wk3] [varchar](max) NULL,
	[wk4] [varchar](max) NULL,
	[wk5] [varchar](max) NULL,
	[wk6] [varchar](max) NULL,
	[wk7] [varchar](max) NULL,
	[wk8] [varchar](max) NULL,
	[wk9] [varchar](max) NULL,
	[wk10] [varchar](max) NULL,
	[wk11] [varchar](max) NULL,
	[wk12] [varchar](max) NULL,
	[wk13] [varchar](max) NULL,
	[wk14] [varchar](max) NULL,
	[wk15] [varchar](max) NULL,
	[wk16] [varchar](max) NULL,
	[wk17] [varchar](max) NULL,
	[wk18] [varchar](max) NULL,
	[wk19] [varchar](max) NULL,
	[wk20] [varchar](max) NULL,
	[wk21] [varchar](max) NULL,
	[wk22] [varchar](max) NULL,
	[wk23] [varchar](max) NULL,
	[wk24] [varchar](max) NULL,
	[wk25] [varchar](max) NULL,
	[wk26] [varchar](max) NULL,
	[wk27] [varchar](max) NULL,
	[wk28] [varchar](max) NULL,
	[wk29] [varchar](max) NULL,
	[wk30] [varchar](max) NULL,
	[wk31] [varchar](max) NULL,
	[wk32] [varchar](max) NULL,
	[wk33] [varchar](max) NULL,
	[wk34] [varchar](max) NULL,
	[wk35] [varchar](max) NULL,
	[wk36] [varchar](max) NULL,
	[wk37] [varchar](max) NULL,
	[wk38] [varchar](max) NULL,
	[wk39] [varchar](max) NULL,
	[wk40] [varchar](max) NULL,
	[wk41] [varchar](max) NULL,
	[wk42] [varchar](max) NULL,
	[wk43] [varchar](max) NULL,
	[wk44] [varchar](max) NULL,
	[wk45] [varchar](max) NULL,
	[wk46] [varchar](max) NULL,
	[wk47] [varchar](max) NULL,
	[wk48] [varchar](max) NULL,
	[wk49] [varchar](max) NULL,
	[wk50] [varchar](max) NULL,
	[wk51] [varchar](max) NULL,
	[wk52] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_audit_result_conv_tmp]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_audit_result_conv_tmp](
	[audit_id] [int] NULL,
	[line_prod_rel_id] [int] NULL,
	[region_id] [int] NULL,
	[country_id] [int] NULL,
	[location_id] [int] NULL,
	[line_id] [int] NULL,
	[audit_date] [date] NULL,
	[Shift_No] [int] NULL,
	[question_id] [int] NULL,
	[section_id] [int] NULL,
	[answer] [int] NULL,
	[remarks] [varchar](100) NULL,
	[image_file_name] [varchar](1000) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_AuditPlan_Del_Invite]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_AuditPlan_Del_Invite](
	[location_id] [int] NULL,
	[year] [int] NULL,
	[email_id] [varchar](1000) NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[line_name] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_AuditPlanInvite]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_AuditPlanInvite](
	[location_id] [int] NULL,
	[year] [int] NULL,
	[email_id] [varchar](1000) NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[line_name] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_country_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_country_master](
	[country_id] [int] IDENTITY(1,1) NOT NULL,
	[region_id] [int] NULL,
	[country_code] [varchar](10) NULL,
	[country_name] [varchar](100) NULL,
 CONSTRAINT [PK_country_id] PRIMARY KEY CLUSTERED 
(
	[country_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_distribution_list]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_distribution_list](
	[dist_list_id] [int] IDENTITY(100,1) NOT NULL,
	[location_id] [int] NULL,
	[list_type] [varchar](50) NULL,
	[email_list] [varchar](max) NULL,
	[send_notification_to_owner] [varchar](1) NULL,
 CONSTRAINT [PK_dist_list_id] PRIMARY KEY CLUSTERED 
(
	[dist_list_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_group_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_group_master](
	[group_id] [int] IDENTITY(1,1) NOT NULL,
	[location_id] [int] NULL,
	[group_name] [varchar](100) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_group_members]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_group_members](
	[group_member_id] [int] IDENTITY(1,1) NOT NULL,
	[location_id] [int] NULL,
	[group_id] [int] NULL,
	[user_id] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_help_text_language_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_help_text_language_master](
	[Question_id] [int] NULL,
	[English] [nvarchar](1000) NULL,
	[German] [nvarchar](1000) NULL,
	[French] [nvarchar](1000) NULL,
	[Spanish] [nvarchar](1000) NULL,
	[czech] [nvarchar](1000) NULL,
	[Chinese] [nvarchar](1000) NULL,
	[Korean] [nvarchar](1000) NULL,
	[Thai] [nvarchar](1000) NULL,
	[Bosnian] [nvarchar](1000) NULL,
	[Portuguese] [nvarchar](1000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_how_to_check_language_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_how_to_check_language_master](
	[Question_id] [int] NULL,
	[English] [nvarchar](1000) NULL,
	[German] [nvarchar](1000) NULL,
	[French] [nvarchar](1000) NULL,
	[Spanish] [nvarchar](1000) NULL,
	[czech] [nvarchar](1000) NULL,
	[Chinese] [nvarchar](1000) NULL,
	[Korean] [nvarchar](1000) NULL,
	[Thai] [nvarchar](1000) NULL,
	[Bosnian] [nvarchar](1000) NULL,
	[Portuguese] [nvarchar](1000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_language_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_language_master](
	[code] [varchar](100) NULL,
	[english] [nvarchar](1000) NULL,
	[german] [nvarchar](1000) NULL,
	[french] [nvarchar](1000) NULL,
	[spanish] [nvarchar](1000) NULL,
	[czech] [nvarchar](1000) NULL,
	[chinese] [nvarchar](1000) NULL,
	[korean] [nvarchar](1000) NULL,
	[thai] [nvarchar](1000) NULL,
	[bosnian] [nvarchar](1000) NULL,
	[portuguese] [nvarchar](1000) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_line_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_line_master](
	[line_id] [int] IDENTITY(1,1) NOT NULL,
	[location_id] [int] NULL,
	[country_id] [int] NULL,
	[region_id] [int] NULL,
	[line_code] [varchar](100) NULL,
	[line_name] [varchar](100) NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[distribution_list] [varchar](max) NULL,
 CONSTRAINT [PK_line_id] PRIMARY KEY CLUSTERED 
(
	[line_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_line_product_relationship]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_line_product_relationship](
	[line_product_rel_id] [int] IDENTITY(1,1) NOT NULL,
	[product_id] [int] NULL,
	[line_id] [int] NULL,
	[location_id] [int] NULL,
	[country_id] [int] NULL,
	[region_id] [int] NULL,
	[no_of_shifts] [int] NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[notification_sent_flag] [varchar](1) NULL,
 CONSTRAINT [PK_line_product_rel_id] PRIMARY KEY CLUSTERED 
(
	[line_product_rel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_local_answers]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_local_answers](
	[loc_answer_id] [int] IDENTITY(1,1) NOT NULL,
	[audit_id] [int] NULL,
	[audit_plan_id] [int] NULL,
	[audited_by_user_id] [int] NULL,
	[line_product_rel_id] [int] NOT NULL,
	[audit_date] [datetime] NULL,
	[Shift_No] [int] NULL,
	[question_id] [int] NULL,
	[answer] [int] NULL,
	[remarks] [nvarchar](1000) NULL,
	[image_file_name] [varchar](1000) NULL,
	[review_user_id] [int] NULL,
	[review_closed_on] [datetime] NULL,
	[review_closed_status] [int] NULL,
	[review_comments] [nvarchar](1000) NULL,
	[review_image_file_name] [varchar](1000) NULL,
	[notification_sent_flag] [varchar](1) NULL,
	[region_id] [int] NULL,
	[country_id] [int] NULL,
	[location_id] [int] NULL,
	[section_id] [int] NULL,
	[line_id] [int] NULL,
 CONSTRAINT [PK_loc_answer_id] PRIMARY KEY CLUSTERED 
(
	[loc_answer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_local_answers_bak]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_local_answers_bak](
	[loc_answer_id] [int] IDENTITY(1,1) NOT NULL,
	[audit_id] [int] NULL,
	[audit_plan_id] [int] NULL,
	[audited_by_user_id] [int] NULL,
	[line_product_rel_id] [int] NOT NULL,
	[audit_date] [datetime] NULL,
	[Shift_No] [int] NULL,
	[question_id] [int] NULL,
	[answer] [int] NULL,
	[remarks] [varchar](1000) NULL,
	[image_file_name] [varchar](1000) NULL,
	[review_user_id] [int] NULL,
	[review_closed_on] [datetime] NULL,
	[review_closed_status] [int] NULL,
	[review_comments] [varchar](1000) NULL,
	[review_image_file_name] [varchar](1000) NULL,
	[notification_sent_flag] [varchar](1) NULL,
	[region_id] [int] NULL,
	[country_id] [int] NULL,
	[location_id] [int] NULL,
	[section_id] [int] NULL,
	[line_id] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_local_question_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_local_question_master](
	[local_question_id] [int] IDENTITY(10000,1) NOT NULL,
	[location_id] [int] NULL,
	[section_id] [int] NULL,
	[local_question] [varchar](1000) NULL,
	[local_help_text] [varchar](1000) NULL,
	[display_sequence] [int] NULL,
	[how_to_check] [varchar](1000) NULL,
	[na_flag] [varchar](1) NULL,
	[max_no_of_pics_allowed] [int] NULL,
 CONSTRAINT [PK_local_question_id] PRIMARY KEY CLUSTERED 
(
	[local_question_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_local_questions]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_local_questions](
	[question_id] [int] NULL,
	[location_id] [int] NULL,
	[section_id] [int] NULL,
	[display_sequence] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_location_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_location_master](
	[location_id] [int] IDENTITY(1,1) NOT NULL,
	[country_id] [int] NULL,
	[region_id] [int] NULL,
	[location_code] [varchar](10) NULL,
	[location_name] [varchar](100) NULL,
	[shift1_start_time] [time](0) NULL,
	[shift1_end_time] [time](0) NULL,
	[shift2_start_time] [time](0) NULL,
	[shift2_end_time] [time](0) NULL,
	[shift3_start_time] [time](0) NULL,
	[shift3_end_time] [time](0) NULL,
	[no_of_shifts] [int] NULL,
	[timezone_code] [varchar](100) NULL,
	[timezone_desc] [varchar](100) NULL,
	[default_language] [varchar](30) NULL,
 CONSTRAINT [PK_location_id] PRIMARY KEY CLUSTERED 
(
	[location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Module_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Module_master](
	[module_id] [int] IDENTITY(1,1) NOT NULL,
	[module] [varchar](100) NULL,
	[status] [int] NULL,
 CONSTRAINT [PK_module_id] PRIMARY KEY CLUSTERED 
(
	[module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_product_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_product_master](
	[product_id] [int] IDENTITY(1,1) NOT NULL,
	[product_code] [varchar](100) NULL,
	[product_name] [varchar](100) NULL,
 CONSTRAINT [PK_product_id] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Question_language_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Question_language_master](
	[Question_id] [int] NULL,
	[English] [nvarchar](1000) NULL,
	[German] [nvarchar](1000) NULL,
	[French] [nvarchar](1000) NULL,
	[Spanish] [nvarchar](1000) NULL,
	[czech] [nvarchar](1000) NULL,
	[Chinese] [nvarchar](1000) NULL,
	[Korean] [nvarchar](1000) NULL,
	[Thai] [nvarchar](1000) NULL,
	[Bosnian] [nvarchar](1000) NULL,
	[Portuguese] [nvarchar](1000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_question_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_question_master](
	[question_id] [int] IDENTITY(1,1) NOT NULL,
	[section_id] [int] NULL,
	[question] [varchar](1000) NULL,
	[help_text] [varchar](1000) NULL,
	[display_sequence] [int] NULL,
	[how_to_check] [varchar](1000) NULL,
	[na_flag] [varchar](1) NULL,
	[max_no_of_pics_allowed] [int] NULL,
 CONSTRAINT [PK_question_id] PRIMARY KEY CLUSTERED 
(
	[question_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_region_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_region_master](
	[region_id] [int] IDENTITY(1,1) NOT NULL,
	[region_code] [varchar](10) NULL,
	[region_name] [varchar](100) NULL,
 CONSTRAINT [PK_region_id] PRIMARY KEY CLUSTERED 
(
	[region_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_ReminderMail_Info]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_ReminderMail_Info](
	[ID] [int] NULL,
	[ToMailIDs] [varchar](max) NULL,
	[CcMailIDs] [varchar](max) NULL,
	[Subject] [varchar](max) NULL,
	[Body] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_request_profile_changes]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_request_profile_changes](
	[user_id] [int] NULL,
	[request_date] [datetime] NULL,
	[comments] [varchar](1000) NULL,
	[notification_sent_flag] [int] NULL,
	[username] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_role_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_role_master](
	[role_id] [int] IDENTITY(1,1) NOT NULL,
	[rolename] [varchar](100) NULL,
	[no_of_audits_required] [int] NULL,
	[frequency] [varchar](30) NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
 CONSTRAINT [PK_role_id] PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_score_summary]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_score_summary](
	[audit_id] [int] NULL,
	[audit_date] [date] NULL,
	[region_id] [int] NULL,
	[country_id] [int] NULL,
	[location_id] [int] NULL,
	[line_id] [int] NULL,
	[part_id] [int] NULL,
	[sec1_yes_count] [int] NULL,
	[sec1_tot_count] [int] NULL,
	[sec1_score] [float] NULL,
	[sec2_yes_count] [int] NULL,
	[sec2_tot_count] [int] NULL,
	[sec2_score] [float] NULL,
	[sec3_yes_count] [int] NULL,
	[sec3_tot_count] [int] NULL,
	[sec3_score] [float] NULL,
	[sec4_yes_count] [int] NULL,
	[sec4_tot_count] [int] NULL,
	[sec4_score] [float] NULL,
	[sec5_yes_count] [int] NULL,
	[sec5_tot_count] [int] NULL,
	[sec5_score] [float] NULL,
	[sec6_yes_count] [int] NULL,
	[sec6_tot_count] [int] NULL,
	[sec6_score] [float] NULL,
	[total_yes] [int] NULL,
	[total_no] [int] NULL,
	[total_na] [int] NULL,
	[total_score] [float] NULL,
	[q1_answer] [int] NULL,
	[q2_answer] [int] NULL,
	[q3_answer] [int] NULL,
	[q4_answer] [int] NULL,
	[q5_answer] [int] NULL,
	[q6_answer] [int] NULL,
	[q7_answer] [int] NULL,
	[q8_answer] [int] NULL,
	[q9_answer] [int] NULL,
	[q10_answer] [int] NULL,
	[q11_answer] [int] NULL,
	[q12_answer] [int] NULL,
	[q13_answer] [int] NULL,
	[q14_answer] [int] NULL,
	[q15_answer] [int] NULL,
	[q16_answer] [int] NULL,
	[q17_answer] [int] NULL,
	[q18_answer] [int] NULL,
	[q19_answer] [int] NULL,
	[q20_answer] [int] NULL,
	[q21_answer] [int] NULL,
	[q22_answer] [int] NULL,
	[q23_answer] [int] NULL,
	[q24_answer] [int] NULL,
	[q25_answer] [int] NULL,
	[q26_answer] [int] NULL,
	[q27_answer] [int] NULL,
	[q28_answer] [int] NULL,
	[q29_answer] [int] NULL,
	[q30_answer] [int] NULL,
	[update_complete] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_Section_language_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Section_language_master](
	[section_id] [int] NULL,
	[English] [nvarchar](1000) NULL,
	[German] [nvarchar](1000) NULL,
	[French] [nvarchar](1000) NULL,
	[Spanish] [nvarchar](1000) NULL,
	[czech] [nvarchar](1000) NULL,
	[Chinese] [nvarchar](1000) NULL,
	[Korean] [nvarchar](1000) NULL,
	[Thai] [nvarchar](1000) NULL,
	[Bosnian] [nvarchar](1000) NULL,
	[Portuguese] [nvarchar](1000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_section_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_section_master](
	[section_id] [int] IDENTITY(1,1) NOT NULL,
	[section_name] [varchar](100) NULL,
	[display_sequence] [int] NULL,
 CONSTRAINT [PK_section_id] PRIMARY KEY CLUSTERED 
(
	[section_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_temp_AnsResultsTableType]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_temp_AnsResultsTableType](
	[question_id] [int] NULL,
	[answer] [int] NULL,
	[remarks] [nvarchar](1000) NULL,
	[image_file_name] [varchar](1000) NULL,
	[audit_id] [int] NULL,
	[location_id] [int] NULL,
	[line_product_rel_id] [int] NULL,
	[audit_date] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_user_feedback]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_user_feedback](
	[user_id] [int] NULL,
	[rating] [int] NULL,
	[review_date] [datetime] NULL,
	[review_comments] [varchar](1000) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_user_master]    Script Date: 6/21/2019 10:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_user_master](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](100) NULL,
	[passwd] [varchar](max) NULL,
	[emp_full_name] [varchar](1000) NULL,
	[display_name_flag] [varchar](1) NULL,
	[email_id] [varchar](100) NULL,
	[location_id] [int] NULL,
	[role] [varchar](100) NULL,
	[global_admin_flag] [varchar](1) NULL,
	[site_admin_flag] [varchar](1) NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[role_id] [int] NULL,
	[region_id] [int] NULL,
	[country_id] [int] NULL,
	[emp_first_name] [varchar](100) NULL,
	[emp_last_name] [varchar](100) NULL,
	[Admin_Type] [varchar](100) NULL,
 CONSTRAINT [PK_user_id] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_country_master] ON 

GO
INSERT [dbo].[tbl_country_master] ([country_id], [region_id], [country_code], [country_name]) VALUES (1, 2, N'India', N'India')
GO
SET IDENTITY_INSERT [dbo].[tbl_country_master] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_location_master] ON 

GO
INSERT [dbo].[tbl_location_master] ([location_id], [country_id], [region_id], [location_code], [location_name], [shift1_start_time], [shift1_end_time], [shift2_start_time], [shift2_end_time], [shift3_start_time], [shift3_end_time], [no_of_shifts], [timezone_code], [timezone_desc], [default_language]) VALUES (1, 1, 2, NULL, N'Bangalore', CAST(N'09:00:00' AS Time), CAST(N'17:00:00' AS Time), CAST(N'17:00:00' AS Time), CAST(N'01:00:00' AS Time), CAST(N'01:00:00' AS Time), CAST(N'09:00:00' AS Time), 3, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tbl_location_master] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_Module_master] ON 

GO
INSERT [dbo].[tbl_Module_master] ([module_id], [module], [status]) VALUES (1, N'Module A', 1)
GO
INSERT [dbo].[tbl_Module_master] ([module_id], [module], [status]) VALUES (2, N'Module B', 1)
GO
INSERT [dbo].[tbl_Module_master] ([module_id], [module], [status]) VALUES (3, N'Module C', 1)
GO
SET IDENTITY_INSERT [dbo].[tbl_Module_master] OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_region_master] ON 

GO
INSERT [dbo].[tbl_region_master] ([region_id], [region_code], [region_name]) VALUES (1, NULL, N'America')
GO
INSERT [dbo].[tbl_region_master] ([region_id], [region_code], [region_name]) VALUES (2, NULL, N'Asia')
GO
INSERT [dbo].[tbl_region_master] ([region_id], [region_code], [region_name]) VALUES (3, NULL, N'Europe')
GO
INSERT [dbo].[tbl_region_master] ([region_id], [region_code], [region_name]) VALUES (4, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tbl_region_master] OFF
GO
USE [master]
GO
ALTER DATABASE [Audire_db] SET  READ_WRITE 
GO
