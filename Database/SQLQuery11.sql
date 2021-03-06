USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_getProductId]    Script Date: 12/11/2019 4:25:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_getProductId](@p_product_code		varchar(100),
							@p_product_name		varchar(100),
							@l_product_id			INT		output	)

AS  
BEGIN
	DECLARE @l_count 			INT;
	
	SELECT @l_count = count(*)  
	FROM   tbl_product_master
	WHERE  UPPER(ISNULL(product_name,'*')) = UPPER(ISNULL(@p_product_code,'*'));
	
	IF @l_count = 0 
		exec sp_saveProduct NULL, @p_product_code;
	
	SELECT @l_product_id	= product_id 
	FROM   tbl_product_master
	WHERE  UPPER(ISNULL(product_name,'*')) = UPPER(ISNULL(@p_product_code,'*'));
		
END


