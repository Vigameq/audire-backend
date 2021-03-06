USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_saveProduct]    Script Date: 12/11/2019 4:26:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_saveProduct](		@p_product_id			int,
								@p_product_code			VARCHAR(100)
								)
AS
	SET NOCOUNT ON;
	
BEGIN
	DECLARE @l_count 			INT;
	DECLARE @l_product_id		INT;
	DECLARE @l_country_id		INT;
	DECLARE @l_location_id		INT;
	DECLARE @l_line_id			INT;

	
	
	IF @p_product_id IS NOT NULL AND @p_product_id != 0
			UPDATE tbl_product_master
			SET product_name = @p_product_code
			WHERE product_id = @p_product_id;
	ELSE
		BEGIN	
			SELECT @l_count = count(*)  
			FROM   tbl_product_master
			WHERE UPPER(product_name) = UPPER(@p_product_code);
	
		IF @l_count = 0 
			BEGIN
				IF @p_product_code IS NOT NULL AND @p_product_code != '' 
					INSERT INTO tbl_product_master (product_name) VALUES (@p_product_code);
			END;
		END;

	
END



