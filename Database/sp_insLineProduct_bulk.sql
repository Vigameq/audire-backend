USE [Audire_db]
GO
/****** Object:  StoredProcedure [dbo].[sp_insLineProduct_bulk]    Script Date: 12/11/2019 4:23:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_insLineProduct_bulk](@p_add_edit_flag		VARCHAR(10),
												@p_parts_table		PartsTableType READONLY
) AS

BEGIN
CREATE TABLE #p_parts_table(region VARCHAR(100),country VARCHAR(100),location VARCHAR(100),lineName VARCHAR(100),PartNumber VARCHAR(MAX))
	INSERT INTO #p_parts_table
	select *  from @p_parts_table
	--select * INTO temp_parts  from @p_parts_table
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

