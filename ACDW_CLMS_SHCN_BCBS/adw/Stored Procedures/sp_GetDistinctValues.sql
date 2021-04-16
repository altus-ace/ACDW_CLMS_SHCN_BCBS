
/***
Creates 2 stored procedures. 
1. adw.sp_GetTableColumns - Gets all column names and distinct values if it is less than @ColValLimit. 
2. adw.sp_GetDistinctValues - Counts number of distinct values in each column, used in adw.sp_GetTableColumns

Results from adw.sp_GetTableColumns.ColValCount = 1 if distinct values are greater than @ColValLimit


***/

--ALTER PROCEDURE adw.sp_AnalyzeTable (@DBCatalog	VARCHAR(75), @DBSchema	VARCHAR(75),  @DBTable	VARCHAR(75), @DBColLimit INT)
--AS
----DECLARE @DBCatalog	VARCHAR(75)
----DECLARE @DBSchema	VARCHAR(75)
----DECLARE @DBTable	VARCHAR(75)
----DECLARE @DBColLimit INT
--GO

--USE ACDW_CLMS_AET_MA
--GO
/*** Create a Stored Procedure to get the ColContents ***/
CREATE PROCEDURE adw.sp_GetDistinctValues
(	
	@TblTable	VARCHAR(75),
	@ColName	VARCHAR(75)
)
AS

DECLARE @SQL	VARCHAR(MAX)
DECLARE @t		VARCHAR(MAX)  = @TblTable
DECLARE @c		VARCHAR(MAX)  = @ColName
SET @SQL = 'SELECT ''' + @t + ''',''' + @c + ''', col, colcnt FROM (SELECT DISTINCT ' + @ColName + ' as col, count(' + @ColName + ') as colcnt FROM ' + @TblTable + ' GROUP BY ' + @ColName + ') a' 
EXEC (@SQL)
