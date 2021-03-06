USE [Audire_db]
GO
/****** Object:  UserDefinedFunction [dbo].[getPartsForLine]    Script Date: 12/11/2019 4:20:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[getPartsForLine](@p_line_id INT)
RETURNS NVARCHAR(max) AS
BEGIN
 RETURN(SELECT SUBSTRING(
  (SELECT ', ' + pm.product_name
  FROM tbl_line_product_relationship rel, tbl_product_master pm
  WHERE rel.product_id = pm.product_id
  AND   rel.line_id = 4
  AND   ISNULL(end_date, DATEADD(day, 1, getdate()) ) >= getdate()
  ORDER BY pm.product_code
  FOR XML PATH('')),3,200000));
END;




