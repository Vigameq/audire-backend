USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_InsLineProduct]    Script Date: 12/11/2019 4:25:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_InsLineProduct](@p_line_product_rel_id	int,
								@p_region_name			VARCHAR(100),
								@p_country_name			VARCHAR(100),
								@p_location_name		VARCHAR(100),
								@p_line_name			VARCHAR(100),
								@p_product_code			VARCHAR(100),
								@p_start_date			date=null,
								@p_end_date				date=null,
								@l_err_code				int OUTPUT,
								@l_err_message			varchar(100) OUTPUT
								)
AS
	SET NOCOUNT ON;
	
BEGIN

/* This procedure needs date overlap validation still */

	DECLARE @l_region_id		INT;
	DECLARE @l_country_id		INT;
	DECLARE @l_location_id		INT;
	DECLARE @l_line_id			INT;
	DECLARE @l_product_id		INT;
	DECLARE @l_count			INT;
	DECLARE @l_count1			INT;
	
	SET @l_err_code = 0;
	SET @l_err_message = 'Initializing';
	
	EXEC sp_getRegionId  NULL, @p_region_name, @l_region_id = @l_region_id OUTPUT;
	EXEC sp_getCountryId  NULL, @p_country_name, @l_country_id = @l_country_id OUTPUT;
	EXEC sp_getLocationId NULL, @p_location_name, @l_location_id = @l_location_id OUTPUT;
	EXEC sp_getProductId @p_product_code, NULL, @l_product_id  = @l_product_id OUTPUT;
 	EXEC sp_getLineId NULL, @l_region_id, NULL, @l_country_id, NULL, @l_location_id, @p_line_name, @l_line_id   = @l_line_id OUTPUT;
	
	SELECT @l_product_id = product_id
	FROM  tbl_product_master pm
	WHERE  upper(product_name) = UPPER(@p_product_code);

	IF @l_product_id IS NULL OR @l_product_id = 0 
		exec sp_saveProduct NULL, @p_product_code;

	SELECT @l_product_id = product_id
	FROM  tbl_product_master pm
	WHERE  upper(product_name) = UPPER(@p_product_code);


	SET @l_err_code = 0;
	SET @l_err_message = 'Initializingi 1';

/*	IF @l_product_id IS NULL OR @l_product_id = 0 
		BEGIN

			EXEC dbo.InsProduct NULL,  @p_product_code;
			EXEC getProductId @p_product_code, NULL, @l_product_id  = @l_product_id OUTPUT;
		END;

	EXEC getLineId @p_region_name, NULL, @p_country_name, NULL, @p_location_name, NULL, @p_line_name, @l_line_id   = @l_line_id OUTPUT;
*/
	IF @p_line_product_rel_id IS NOT NULL AND @p_line_product_rel_id<>0
	
		BEGIN
	SET @l_err_code = 0;
			SET @l_err_message = 'Updated Successfully1';
			UPDATE tbl_line_product_relationship
			SET    product_id = @l_product_id,
					line_id = @l_line_id,
					location_id = @l_location_id,
					country_id = @l_country_id,
					region_id = @l_region_id,
					start_date = @p_start_date,
					end_date = @p_end_date
			WHERE  line_product_rel_id = @p_line_product_rel_id;
			
			SET @l_err_code = 0;
			SET @l_err_message = 'Updated Successfully';
			
		END;
		
	ELSE
		BEGIN
		SET @l_err_code = 0;
			SET @l_err_message = 'INSERTED Successfully';
			SELECT @l_count = count(*)
			FROM   tbl_line_product_relationship
			WHERE  product_id = @l_product_id
			AND	   line_id = @l_line_id
			AND	   location_id = @l_location_id
			AND	   country_id = @l_country_id
			AND	   region_id = @l_region_id;

			IF @l_count = 0 
			BEGIN
			SET @l_err_code = 2;
			SET @l_err_message = @l_product_id;
				INSERT INTO tbl_line_product_relationship
				(
					product_id,
					line_id,
					location_id,
					country_id,
					region_id,
					start_date,
					end_date
				) VALUES (
					@l_product_id,
					@l_line_id,
					@l_location_id,
					@l_country_id,
					@l_region_id,
					ISNULL(@p_start_date,getdate()),
					@p_end_date
				);

				SET @l_err_code = 0;
				SET @l_err_message = 'Inserted Successfully';
			
			END;
			ELSE

			BEGIN
				SELECT @l_count1 = count(*)
				FROM   tbl_line_product_relationship
				WHERE  product_id = @l_product_id
				AND	   line_id = @l_line_id
				AND	   location_id = @l_location_id
				AND	   country_id = @l_country_id
				AND	   region_id = @l_region_id
				AND    end_date IS NOT NULL;

				IF @l_count1 > 0 
					UPDATE tbl_line_product_relationship
					SET    end_date = NULL
					WHERE  product_id = @l_product_id
					AND	   line_id = @l_line_id
					AND	   location_id = @l_location_id
					AND	   country_id = @l_country_id
					AND	   region_id = @l_region_id
					AND    end_date IS NOT NULL;

			END;


		END;

END





