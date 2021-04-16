
/*** Alter or Create a Stored Procedure to get the Table and Columns ***/
CREATE PROCEDURE adw.sp_GetTableColumns (@InputTableName VARCHAR(75), @ColValLimit INT)
AS
--DECLARE @dbC VARCHAR(75) = @DBCatalog
--DECLARE @dbS VARCHAR(15) = @DBSchema
--DECLARE @dbT VARCHAR(75) = @DBTable
--DECLARE @dbl INT = @DBColLimit
--DECLARE @table_name VARCHAR(75) = @DBSchema + '.' + @DBTable
DECLARE @table_name VARCHAR(75)
SET @table_name = @InputTableName 
	CREATE TABLE #colcount (
		ColName			VARCHAR(75)
		,DistinctValue	INT
		,TotalValue		INT
		)
	CREATE TABLE #colContent (
		TableName		VARCHAR(75)
		,ColName		VARCHAR(75)
		,ColVal			NVARCHAR(max)
		,ColValCount	INT
		,CreateDate		DATETIME DEFAULT GETDATE()
		,CreateBy		VARCHAR(75) DEFAULT SUSER_SNAME()
		)
	CREATE TABLE #sqlexecs (s VARCHAR(max))
DECLARE @col_name	VARCHAR(max)
	,@sql			NVARCHAR(max)
	,@sql2			NVARCHAR(max)
	,@sql3			NVARCHAR(max)
	,@colname		VARCHAR(max)
	,@vallimit		INT					= @ColValLimit
DECLARE c CURSOR
FOR
	SELECT name
	FROM sys.columns
	WHERE [object_id] = object_id(@table_name)
OPEN c

FETCH NEXT
FROM c
INTO @col_name

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @sql = 'select cn.name, count(distinct ' + @col_name + ') as dct_numrow, count(' + @col_name + ') as tot_numrow from ' + @table_name + ' join (select name from sys.columns where name = ''' + @col_name + ''' and [object_id]=object_id(''' + @table_name + ''')) cn on cn.name = ''' + @col_name + ''' group by cn.name'
		INSERT INTO #sqlexecs
		VALUES (@sql) --uncomment to  view sql selects produced by @sql
		INSERT INTO #colcount
		EXECUTE sp_executesql @sql
	DECLARE @d INT
		,@t INT
	SET @d = (
			SELECT DistinctValue
			FROM #colcount
			WHERE colname = @col_name
			)
	SET @t = (
			SELECT TotalValue
			FROM #colcount
			WHERE colname = @col_name
			)
	IF (@d < @vallimit)
	BEGIN
		INSERT INTO #colContent (TableName,colname,ColVal,ColValCount)
		EXEC adw.sp_GetDistinctValues @table_name,@col_name
	END
	ELSE
	BEGIN
		INSERT INTO #colContent (TableName,colname,ColVal,ColValCount)
		VALUES (@table_name,@col_name,1,1)
	END
	FETCH NEXT
	FROM c
	INTO @col_name
END

CLOSE c

DEALLOCATE c

/*** Display Results ***/
--select * from #sqlexecs 
SELECT * FROM #colcount 
SELECT * FROM #colContent
--DROP TABLE #colcount
--DROP TABLE #colContent
--DROP TABLE #sqlexecs
/***
Usage:
EXEC adw.sp_GetDistinctValues '[adi].[ClaimAetMA]','[subs_zip_cd]'			--For a particular Field
EXEC adw.sp_GetTableColumns '[adi].[ClaimAetMA]',20								--For entire table with Column Limit

DROP PROCEDURE adw.sp_GetDistinctValues
DROP PROCEDURE adw.sp_GetTableColumns
***/