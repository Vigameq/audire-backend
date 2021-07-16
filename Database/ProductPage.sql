

Create PROCEDURE [dbo].[sp_getProductListforEdit](@p_user_id		INT)
AS
BEGIN
	DECLARE @l_count 			INT;
	DECLARE @l_location_id 			INT;
	DECLARE @l_global_admin			VARCHAR(1);
	DECLARE @l_local_admin			VARCHAR(1);


	SELECT @l_global_admin = ISNULL(global_admin_flag,'N'),
		@l_local_admin = ISNULL(site_admin_flag,'N'),
		@l_location_id = location_id
	FROM   tbl_user_master
	WHERE  user_id = @p_user_id;
	print @l_global_admin
	print @l_local_admin
	print @l_location_id
	
	SELECT  rm.region_id,
			rm.region_name,
			cm.country_id,
			cm.country_name,
			lm.location_id,
			lm.location_name,
			lne.line_id,
			lne.line_name,
			lne.line_code,
			dbo.getPartsForLine(lne.line_id) product_code
	FROM   tbl_region_master rm,
			tbl_country_master cm,
			tbl_location_master lm,
			tbl_line_master lne
	WHERE  lne.region_id = rm.region_id
	AND    lne.country_id = cm.country_id
	AND    lne.location_id = lm.location_id
	AND		(
			(ISNULL(@l_local_admin,'N') = 'Y' AND lm.location_id = @l_location_id) OR
			(ISNULL(@l_global_admin,'N') = 'Y')
			)
	AND   lne.line_id IN (select rel.line_id from tbl_line_product_relationship rel where rel.line_id =  lne.line_id
						  and ISNULL(end_date, DateAdd(day, 1, getdate())) > getdate() 
						  ) 
	and ISNULL(end_date , dateadd(day,1,getdate())) > getdate()	  
	ORDER BY line_name;

END;



GO

CREATE FUNCTION [dbo].[getPartsForLine](@p_line_id INT)
RETURNS NVARCHAR(max) AS
BEGIN
 RETURN(SELECT SUBSTRING(
  (SELECT ', ' + pm.product_code
  FROM tbl_line_product_relationship rel, tbl_product_master pm
  WHERE rel.product_id = pm.product_id
  AND   rel.line_id = @p_line_id
  AND   ISNULL(end_date, DATEADD(day, 1, getdate()) ) >= getdate()
  ORDER BY pm.product_code
  FOR XML PATH('')),3,200000));
END;


GO

CREATE TYPE [dbo].[PartsTableType] AS TABLE(
	[region] [varchar](100) NULL,
	[country] [varchar](100) NULL,
	[location] [varchar](100) NULL,
	[lineName] [varchar](100) NULL,
	[PartNumber] [varchar](max) NULL
)
GO



Create PROCEDURE [dbo].[sp_DelPart](
								@p_line_id					INT,
								@p_product_id				int=NULL,
								@l_err_code				int OUTPUT,
								@l_err_message			varchar(100) OUTPUT

								)
AS
	SET NOCOUNT ON;
	
BEGIN
	DECLARE @l_count			int;
	DECLARE @l_count1			int;
	DECLARE @l_product_id		INT;
	
	SET @l_err_code = 0;
	SET @l_err_message = 'Initializing';
	
	UPDATE tbl_line_product_relationship
	SET    end_date = getdate()
	WHERE  line_id = @p_line_id
	AND    product_id = ISNULL(@p_product_id, product_id);

	SET @l_err_code = 0;
	SET @l_err_message = 'Parts Deleted Successfully';
	
	SELECt * from (select @l_err_code err_code, @l_err_message err_message) a;
END


GO




CREATE PROCEDURE [dbo].[sp_getLocationId](@p_location_code		varchar(10),
							@p_location_name		varchar(100),
							@l_location_id			INT		output	)

AS  
BEGIN
	DECLARE @l_count 			INT;
	
	SELECT @l_count = count(*)  
	FROM   tbl_location_master
	WHERE  UPPER(ISNULL(location_code,'*')) = UPPER(ISNULL(@p_location_code,'*'))
	AND    UPPER(location_name) = UPPER(@p_location_name);
	
	IF @l_count = 0 
		-- exec Inslocation NULL, @p_location_code, @p_location_name;
		Set @l_location_id = 0;
	ELSE
		SELECT @l_location_id	= location_id 
		FROM   tbl_location_master
		WHERE  UPPER(ISNULL(location_code,'*')) = UPPER(ISNULL(@p_location_code,'*'))
		AND    UPPER(location_name) = UPPER(@p_location_name);
		
END
GO


CREATE PROCEDURE [dbo].[sp_getProductId](@p_product_code		varchar(100),
							@p_product_name		varchar(100),
							@l_product_id			INT		output	)

AS  
BEGIN
	DECLARE @l_count 			INT;
	
	SELECT @l_count = count(*)  
	FROM   tbl_product_master
	WHERE  UPPER(ISNULL(product_code,'*')) = UPPER(ISNULL(@p_product_code,'*'));
	
	IF @l_count = 0 
		exec sp_saveProduct NULL, @p_product_code;
	
	SELECT @l_product_id	= product_id 
	FROM   tbl_product_master
	WHERE  UPPER(ISNULL(product_code,'*')) = UPPER(ISNULL(@p_product_code,'*'));
		
END


GO




CREATE PROCEDURE [dbo].[sp_getRegionId](@p_region_code		varchar(10),
							@p_region_name		varchar(100),
							@l_region_id		int output)
 
AS  
BEGIN
	DECLARE @l_count 			INT;

	SELECT @l_count = count(*)  
	FROM   tbl_region_master
	WHERE  UPPER(ISNULL(region_code,'*')) = UPPER(ISNULL(@p_region_code,'*'))
	AND    UPPER(region_name) = UPPER(@p_region_name);
	
	IF @l_count = 0 
		exec sp_InsRegion  NULL, @p_region_code, @p_region_name;

	
	SELECT @l_region_id	= region_id 
	FROM   tbl_region_master
	WHERE  UPPER(ISNULL(region_code,'*')) = UPPER(ISNULL(@p_region_code,'*'))
	AND    UPPER(region_name) = UPPER(@p_region_name);

END



GO


CREATE PROCEDURE [dbo].[sp_InsRegion](		@p_region_id			int,
								@p_region_code			VARCHAR(10),
								@p_region_name			VARCHAR(100)
								)
AS
	SET NOCOUNT ON;
	
BEGIN
	DECLARE @l_count 			INT;
	DECLARE @l_region_id		INT;
	DECLARE @l_country_id		INT;
	DECLARE @l_location_id		INT;
	DECLARE @l_line_id			INT;
	DECLARE @l_product_id		INT;
	
	
	IF @p_region_id IS NOT NULL AND @p_region_id != 0 
			UPDATE tbl_region_master
			SET region_code = @p_region_code,
				region_name = @p_region_name
			WHERE region_id = @p_region_id;
	ELSE
		BEGIN	
			SELECT @l_count = count(*)  
			FROM   tbl_region_master
			WHERE  UPPER(ISNULL(region_code,'*')) = UPPER(ISNULL(@p_region_code,'*'))
			AND    UPPER(region_name) = UPPER(@p_region_name);
	
		IF @l_count = 0 
			BEGIN
				IF @p_region_name IS NOT NULL AND @p_region_name != '' 
					INSERT INTO tbl_region_master (region_code, region_name) VALUES (@p_region_code, @p_region_name);
			END;
		END;

	
END

GO




CREATE PROCEDURE [dbo].[sp_getCountryId](@p_country_code	varchar(10),
							@p_country_name		varchar(100),
							@l_country_id		INT		output	)
AS  
BEGIN
	DECLARE @l_count 			INT;
	
	SELECT @l_count = count(*)  
	FROM   tbl_country_master
	WHERE  UPPER(ISNULL(country_code,'*')) = UPPER(ISNULL(@p_country_code,'*'))
	AND    UPPER(country_name) = UPPER(@p_country_name);
	
	IF @l_count = 0 
		exec sp_Inscountry NULL, @p_country_code, @p_country_name;

	
	SELECT @l_country_id	= country_id 
	FROM   tbl_country_master
	WHERE  UPPER(ISNULL(country_code,'*')) = UPPER(ISNULL(@p_country_code,'*'))
	AND    UPPER(country_name) = UPPER(@p_country_name);
		
END

GO


CREATE PROCEDURE [dbo].[sp_InsCountry](		@p_country_id			int,
								@p_country_code			VARCHAR(10),
								@p_country_name			VARCHAR(100)
								)
AS
	SET NOCOUNT ON;
	
BEGIN
	DECLARE @l_count 			INT;
	DECLARE @l_country_id		INT;
	DECLARE @l_location_id		INT;
	DECLARE @l_line_id			INT;
	DECLARE @l_product_id		INT;
	
	
	IF @p_country_id IS NOT NULL AND @p_country_id != 0
			UPDATE tbl_country_master
			SET country_code = @p_country_code,
				country_name = @p_country_name
			WHERE country_id = @p_country_id;
	ELSE
		BEGIN	
			SELECT @l_count = count(*)  
			FROM   tbl_country_master
			WHERE  UPPER(ISNULL(country_code,'*')) = UPPER(ISNULL(@p_country_code,'*'))
			AND    UPPER(country_name) = UPPER(@p_country_name);
	
		IF @l_count = 0 
			BEGIN
				IF @p_country_name IS NOT NULL AND @p_country_name != '' 
					INSERT INTO tbl_country_master (country_code, country_name) VALUES (@p_country_code, @p_country_name);
			END;
		END;

	
END

GO


CREATE PROCEDURE [dbo].[sp_getLineId](		
								@p_region_name			VARCHAR(100),
								@p_region_id			INT,
								@p_country_name			VARCHAR(100),
								@p_country_id			INT,
								@p_location_name		VARCHAR(100),
								@p_location_id			INT,
								@p_line_name			VARCHAR(100),
								@l_line_id				INT OUTPUT)
 
AS  
BEGIN
	DECLARE @l_count 			INT
	DECLARE @l_region_id		INT
	DECLARE @l_country_id		INT
	DECLARE @l_location_id		INT
	DECLARE @err_code			INT, @err_msg VARCHAR(100)
	DECLARE @l_region_name		VARCHAR(100)
	DECLARE @l_country_name		VARCHAR(100)
	DECLARE @l_location_name	VARCHAR(100)
	


	IF @p_region_id IS NOT NULL AND @p_region_id != 0
		BEGIN
			SET @l_region_id = @p_region_id;
			IF @p_region_name IS NULL OR @p_region_name = ''
				SELECT @l_region_name = region_name
				FROM   tbl_region_master 
				WHERE  region_id = @l_region_id;
			ELSE
				SET @l_region_name = @p_region_name;
		END;
	ELSE
		EXEC sp_getRegionId  NULL, @p_region_name, @l_region_id = @l_region_id OUTPUT;

	
	IF @p_country_id IS NOT NULL  AND @p_country_id != 0
		BEGIN
			SET @l_country_id = @p_country_id;
			IF @p_country_name IS NULL OR @p_country_name = ''
				SELECT @l_country_name = country_name
				FROM   tbl_country_master 
				WHERE  country_id = @l_country_id;
			ELSE
				SET @l_country_name = @p_country_name;
		END;
	ELSE
		EXEC sp_getCountryId  NULL, @p_country_name, @l_country_id = @l_country_id OUTPUT;

	
	IF @p_location_id IS NOT NULL  AND @p_location_id != 0
		BEGIN
			SET @l_location_id = @p_location_id;
			IF @p_location_name IS NULL OR @p_location_name = ''
				SELECT @l_location_name = location_name
				FROM   tbl_location_master 
				WHERE  location_id = @l_location_id;
			ELSE
				SET @l_location_name = @p_location_name;
		END;
	ELSE
		EXEC sp_getLocationId NULL, @p_location_name, @l_location_id = @l_location_id OUTPUT;

	
	
	SELECT @l_count = count(*)  
	FROM   tbl_line_master
	WHERE  UPPER(line_name) = UPPER(@p_line_name)
	AND    location_id = @l_location_id
	AND    country_id = @l_country_id
	AND    region_id = @l_region_id;
	
	IF @l_count = 0 
		EXEC sp_InsLine NULL, @l_region_name,
				@l_country_name,
				@l_location_name,
				NULL,
				@p_line_name,
				NULL,
				@err_code OUTPUT,
				@err_msg OUTPUT

	
	SELECT @l_line_id	= line_id 
	FROM   tbl_line_master
	WHERE  UPPER(line_name) = UPPER(@p_line_name)
	AND    location_id = @l_location_id
	AND    country_id = @l_country_id
	AND    region_id = @l_region_id;
	
	
		RETURN @l_line_id;
	
END



GO



CREATE PROCEDURE [dbo].[sp_InsLine](  @p_line_id    int,
        @p_region_name   VARCHAR(100),
        @p_country_name   VARCHAR(100),
        @p_location_name  VARCHAR(100),
        @p_line_code   varchar(100)= NULL,
        @p_line_name   VARCHAR(100),
        @p_distribution_list   VARCHAR(max),
        @l_err_code    int OUTPUT,
        @l_err_message   varchar(100) OUTPUT
        )
AS
 SET NOCOUNT ON;
 
BEGIN
 DECLARE @l_count    INT;
 DECLARE @l_region_id  INT;
 DECLARE @l_country_id  INT;
 DECLARE @l_location_id  INT;
 DECLARE @l_line_id   INT;
 
 EXEC sp_getRegionId  NULL, @p_region_name, @l_region_id = @l_region_id OUTPUT;
 EXEC sp_getCountryId  NULL, @p_country_name, @l_country_id = @l_country_id OUTPUT;
 EXEC sp_getLocationId NULL, @p_location_name, @l_location_id = @l_location_id OUTPUT;
 SET @l_err_code = 0;
 SET @l_err_message = 'Initializing';
/*
 SELECT  @l_mail_to_list = email_list
 FROM   mh_lpa_distribution_list
 WHERE location_id = 0
 AND   UPPER(list_type) = UPPER('At New Line Addition');
*/
 IF @p_line_id IS NOT NULL AND @p_line_id != 0
 BEGIN
  UPDATE tbl_line_master
  SET    location_id = @l_location_id,
    country_id = @l_country_id,
    region_id = @l_region_id,
    line_code = @p_line_code,
    line_name = @p_line_name,
    distribution_list = @p_distribution_list
  WHERE   line_id = @p_line_id;
  SET @l_err_code = 0;
   SET @l_err_message = 'Updated Successfully';
   
 END 
 ELSE
  BEGIN
 
   SELECT @l_count = count(*)  
   FROM   tbl_line_master
   WHERE  UPPER(line_name) = UPPER(@p_line_name)
   AND    location_id = @l_location_id
   AND    country_id = @l_country_id
   AND    region_id = @l_region_id;
 
   IF @l_count = 0 AND @p_line_name IS NOT NULL AND @p_line_name != ''
   BEGIN
    INSERT INTO tbl_line_master (
      location_id,
      country_id,
      region_id,
      line_code,
      line_name,
      distribution_list
     ) VALUES (
      @l_location_id,
      @l_country_id,
      @l_region_id,
      @p_line_code,
      @p_line_name,
      @p_distribution_list
     );
    SET @l_err_code = 0;
    SET @l_err_message = 'Inserted Successfully';
   END
   ELSE
   BEGIN
    SELECT @l_count = count(*)  
    FROM   tbl_line_master
    WHERE  UPPER(line_name) = UPPER(@p_line_name)
    AND    location_id = @l_location_id
    AND    country_id = @l_country_id
    AND    region_id = @l_region_id
    AND    end_date IS NOT NULL;
    IF @l_count > 0
     UPDATE tbl_line_master
     SET    end_date = NULL, 
       distribution_list = @p_distribution_list
     WHERE  UPPER(line_name) = UPPER(@p_line_name)
     AND    location_id = @l_location_id
     AND    country_id = @l_country_id
     AND    region_id = @l_region_id
     AND    end_date IS NOT NULL;

   END;
  END;
 
END
GO



CREATE PROCEDURE [dbo].[sp_InsLineProduct](@p_line_product_rel_id	int,
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
	WHERE  upper(product_code) = UPPER(@p_product_code);

	IF @l_product_id IS NULL OR @l_product_id = 0 
		exec sp_saveProduct NULL, @p_product_code;

	SELECT @l_product_id = product_id
	FROM  tbl_product_master pm
	WHERE  upper(product_code) = UPPER(@p_product_code);


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

GO

CREATE PROCEDURE [dbo].[sp_insLineProduct_bulk](@p_add_edit_flag		VARCHAR(10),
												@p_parts_table		PartsTableType READONLY
) AS

BEGIN
CREATE TABLE #p_parts_table(region VARCHAR(100),country VARCHAR(100),location VARCHAR(100),lineName VARCHAR(100),PartNumber VARCHAR(MAX))
	INSERT INTO #p_parts_table
	select *  from @p_parts_table
	select * INTO temp_parts  from @p_parts_table
	update #p_parts_table SET PartNumber=REPLACE(PartNumber,'&','&amp;')

	DECLARE @l_region_name VARCHAR(100), @l_country_name VARCHAR(100), 
			@l_location_name VARCHAR(100), @l_line_name VARCHAR(100), 
			@l_part_number VARCHAR(100);
	DECLARE @l_err_code INT, @l_err_message VARCHAR(1000);
	DECLARE @l_count	INT;
	DECLARE @l_line_id	INT;
	
	SELECT @l_line_id = line_id
	FROM   #p_parts_table p, 
			tbl_line_master lm, 
			tbl_location_master loc
	WHERE  loc.location_id = lm.location_id
	AND    UPPER(p.location) = UPPER(loc.location_name)
	AND    UPPER(p.linename) = UPPER(lm.line_name);

	IF @l_line_id IS NOT NULL AND UPPER(@p_add_edit_flag) <> 'ADD'
	BEGIN
			EXEC dbo.sp_DelPart @l_line_id, NULL, @l_err_code = @l_err_code OUTPUT, @l_err_message = @l_err_message OUTPUT;
	END;

	
	
	

	DECLARE l_line_part_cur CURSOR FOR
							SELECT region,country,location,linename,
							LTRIM(RTRIM(m.n.value('.[1]','varchar(8000)'))) AS PartNumber
							FROM
							(
							SELECT region,country,location,linename,
									CAST('<XMLRoot><RowData>' + REPLACE(PartNumber,',','</RowData><RowData>') + '</RowData></XMLRoot>' AS XML) AS x
							FROM   #p_parts_table
							)t
							CROSS APPLY x.nodes('/XMLRoot/RowData')m(n)

	OPEN l_line_part_cur
	FETCH NEXT FROM l_line_part_cur INTO @l_region_name, @l_country_name, @l_location_name, @l_line_name, @l_part_number;

	-- SELECT @l_count = 
	WHILE @@FETCH_STATUS = 0 
	BEGIN
	
		SELECT @l_count = count(*) 
		FROM tbl_location_master loc,
			 tbl_country_master cm,
			 tbl_region_master rm,
			 tbl_line_master lm
		where UPPER(loc.location_name) = UPPER(@l_location_name)
		AND   UPPER(cm.country_name) = UPPER(@l_country_name)
		AND   UPPER(rm.region_name) = UPPER(@l_region_name)
		AND   UPPER(lm.line_name) = UPPER(@l_line_name)
		AND   lm.location_id = loc.location_id
		ANd   lm.country_id = cm.country_id
		AND   lm.region_id = rm.region_id
		IF @l_count = 0 
		BEGIN
			SET @l_err_code = 100;
			SET @l_err_message = 'Region/Country/Location/Line Combination Does not exist';
			BREAK;
		END;
		ELSE
		BEGIN
			EXEC dbo.sp_InsLineProduct NULL, @l_region_name, @l_country_name, @l_location_name, @l_line_name, @l_part_number, NULL,NULL, @l_err_code = @l_err_code OUTPUT, @l_err_message = @l_err_message OUTPUT;
			FETCH NEXT FROM l_line_part_cur INTO @l_region_name, @l_country_name, @l_location_name, @l_line_name, @l_part_number;
		END;
	END;


	CLOSE l_line_part_cur;
	DEALLOCATE l_line_part_cur;

	SELECT * from (select @l_err_code err_code, @l_err_message err_message) a;

END;

GO