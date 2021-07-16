--DROP TABLE tbl_AuditResult
CREATE TABLE [dbo].[tbl_AuditResult](
	[id] [int] IDENTITY(1,1) NOT NULL,
	audit_id int NOT NULL,
	[question_id] [int] NULL,
	[answer] [varchar](10) NULL,
	[audit_comment] [varchar](max) NULL,
	[assigned_To] [varchar](100) NULL,
	[audit_images] [varchar](max) NULL,
	[module_id] [int] NULL,
	[region_id] [int] NULL,
	[country_id] [int] NULL,
	[location_id] [int] NULL,
	[line_id] [int] NULL,
	[product_id] [int] NULL,
	[shift_no] [int] NULL,
	[audit_performed_by] [int] NULL,
	[audit_performed_on] [varchar](max) NULL,
	[audit_performed_date] [datetime] NULL,
	[review_status] [varchar](100) NULL,
	[review_comment] [varchar](max) NULL,
	[review_images] [varchar](max) NULL,
	[reviewed_by] [int] NULL,
	[reviewed_on] [varchar](max) NULL,
	[reviewed_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


