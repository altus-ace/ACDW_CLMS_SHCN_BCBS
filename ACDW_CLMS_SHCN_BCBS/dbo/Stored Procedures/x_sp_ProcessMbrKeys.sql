

CREATE PROCEDURE dbo.x_sp_ProcessMbrKeys
(   
	 @SrcTblName				VARCHAR(100)		
	,@SrcLoadDate				DATE		
   ,@TgtTblName				VARCHAR(100)	
)
AS
BEGIN
-- Declare Global Variables for mapping
DECLARE @LoadDate									VARCHAR(50)		= '[DataDate]'
DECLARE @SrcMbrTbl								VARCHAR(50)		= '[adi].[Steward_BCBS_Membership]'
DECLARE @SrcMbrTblKey							VARCHAR(50)		= '[MembershipKey]'
DECLARE @SrcMbrPlanTable						VARCHAR(50)		= '[adi].[Steward_BCBS_MemberCrosswalk]'
DECLARE @SrcMbrPlanKey							VARCHAR(50)		= '[MemberCrosswalkKey]'
DECLARE @SrcMbrPlanCode							VARCHAR(50)		= 'ProgramIndicator'
DECLARE @MbrPlanJoinOn							VARCHAR(100)	= 'ON	m.PatientID = p.PatientID AND	m.DataDate = p.DataDate'
DECLARE @MbrPlanJoinWhere						VARCHAR(100)	= 'p.Indicator834 = ' + char(39) + 'Y' + char(39) 
DECLARE @ClientMbrKey							VARCHAR(50)		= '[PatientID]'
DECLARE @AttribNPI								VARCHAR(50)		= '[AttributedPrimaryCareProviderNPI]'
DECLARE @AttribTIN								VARCHAR(50)		= 'N/A'
DECLARE @AndWhere									VARCHAR(50)		= ' '
DECLARE @UpdateJoin								VARCHAR(100)	= 'ON		a.ClientMemberKey = b.PatientID ' 
DECLARE @RecParameters							VARCHAR(500)	= CONCAT(@LoadDate,'||',@SrcMbrTbl, '||',@SrcMbrPlanTable,'||', @UpdateJoin)
DECLARE @ProcedureName							VARCHAR(50)		= 'dbo.x_sp_ProcessMbrKeys'
DECLARE @tmpMbrPlan								VARCHAR(50)		= 'dbo.z_tmp_MbrPlan'
DECLARE @tmpTgtTblName							VARCHAR(50)		= 'dbo.z_tmp_MbrKeyTbl'
-- Get Distinct Values for LoadDate.  RecStatus (New, Existing)
DECLARE @SQLLoadDate								NVARCHAR(max);
SET @SQLLoadDate	 = '
		DROP TABLE ' + @tmpTgtTblName	 + '
		CREATE TABLE ' + @tmpTgtTblName	 + ' ( 
			 URN											INT IDENTITY NOT NULL 
			,SrcLoadDate								DATE 
			,SrcTblKey									INT
			,ClientMemberKey							VARCHAR(50)
			,AttribNPI									VARCHAR(50)
			,AttribTIN									VARCHAR(50)
			,MbrPlan										VARCHAR(50)
			,PlanTblKey									INT
			,RecStatus									VARCHAR(1) DEFAULT ' + char(39) + 'N' + char(39) +'
			,RecLoadID									VARCHAR(10)
			,RecUpdateID								VARCHAR(10)
			,RecStatusDate								DATE DEFAULT (sysdatetime())
			,CreateDate									DATE DEFAULT (sysdatetime())
			,CreateBy									VARCHAR(50) DEFAULT (suser_sname()))
		DROP TABLE dbo.z_tmp_LoadDates
		CREATE TABLE dbo.z_tmp_LoadDates  ( 
			 URN											INT IDENTITY NOT NULL 
			,LoadDate									DATE 
			,RecStatus									VARCHAR(1) DEFAULT ' + char(39) + 'N' + char(39) +'
			,Note											VARCHAR(50)
			,Parameters									VARCHAR(500) DEFAULT ' + char(39) + @RecParameters + char(39) + '
			,CreateDate									DATE DEFAULT (sysdatetime())
			,CreateBy									VARCHAR(50) DEFAULT (suser_sname()))
		INSERT INTO dbo.z_tmp_LoadDates (LoadDate) 
		SELECT DISTINCT ' + @LoadDate + ' FROM ' + @SrcMbrTbl + ' ORDER BY ' + @LoadDate + ' ASC '
EXEC dbo.sp_executesql @SQLLoadDate

DECLARE @SQLJoinMbrPlan						NVARCHAR(max);
SET @SQLJoinMbrPlan = '
		DROP TABLE ' + @tmpMbrPlan +'
		CREATE TABLE  ' + @tmpMbrPlan + '  ( 
			 URN											INT IDENTITY NOT NULL 
			,MbrLoadDate								DATE 
			,MbrKey										INT
			,PatientID									VARCHAR(50)
			,AttribNPI									VARCHAR(50)
			,PlanKey										INT
			,PlanCode									VARCHAR(50)
			,MbrPlanMatchFlg							INT
			,Note											VARCHAR(50)
			,RecParameters								VARCHAR(500) DEFAULT ' + char(39) + @RecParameters + char(39) + '
			,CreateDate									DATE DEFAULT (sysdatetime())
			,CreateBy									VARCHAR(50) DEFAULT (suser_sname()))
		INSERT INTO   ' + @tmpMbrPlan + '  (MbrLoadDate, MbrKey, PatientID, AttribNPI,PlanKey, PlanCode, MbrPlanMatchFlg, Note, RecParameters) 
		SELECT DISTINCT m.' + @LoadDate + ', m.' + @SrcMbrTblKey + ',m.' + @ClientMbrKey + ',m.' + @AttribNPI + ',p.' + @SrcMbrPlanKey + ',p.' + @SrcMbrPlanCode + ' 
			,CASE WHEN ' + @SrcMbrPlanCode + ' IS NULL THEN 0 ELSE 1 END as MbrPlanMatchFlg
			,' + char(39) + @ProcedureName	+ char(39) + ',' + char(39) + @RecParameters + char(39) + '
		FROM ' + @SrcMbrTbl + ' m LEFT JOIN ' + @SrcMbrPlanTable + ' p ' + @MbrPlanJoinOn + ' WHERE ' + @MbrPlanJoinWhere + '
		'
--PRINT @SQLJoinMbrPlan
EXEC dbo.sp_executesql @SQLJoinMbrPlan

/*** Loop Thru each row and create pivot table ***/
DECLARE @SQLUpdateInsertRec		NVARCHAR(max);
DECLARE @c									INT = 1;
DECLARE @cRTotal							BIGINT = 0;
DECLARE @cRowCnt						BIGINT = 0;

-- get a count of total rows to process 
SELECT @cRowCnt = COUNT(0) FROM dbo.z_tmp_LoadDates;
WHILE  @c <= @cRowCnt
BEGIN
DECLARE @RecLoadDate					VARCHAR(15)	= (SELECT LoadDate FROM dbo.z_tmp_LoadDates WHERE urn = @c)
DECLARE @RecLoadID						VARCHAR(25) = (SELECT CONCAT('ID',urn) FROM dbo.z_tmp_LoadDates WHERE urn = @c)
DECLARE @PrevRecLoadID				VARCHAR(25) = CASE WHEN @c = 1 THEN 'ID0' ELSE (SELECT  CONCAT('ID',urn) FROM dbo.z_tmp_LoadDates WHERE urn = @c-1) END
-- create SQL statement 
SET NOCOUNT ON;
BEGIN
	SET @SQLUpdateInsertRec =	'
		UPDATE ' + @TgtTblName + '
			SET RecStatus = '+ char(39) + 'U' + char(39) +', RecStatusDate = (sysdatetime()), RecUpdateID = ' + char(39) + @RecLoadID + char(39) + ' ' + '
			FROM ' + @TgtTblName + ' a JOIN ' + @tmpMbrPlan + ' b ' + @UpdateJoin + '
			WHERE b.MbrLoadDate =' + char(39) + @RecLoadDate + char(39) + ' ' + @AndWhere + ' 
			AND a.RecLoadID = ' + char(39) + @PrevRecLoadID + char(39) + '
		INSERT INTO ' + @TgtTblName + '
			(SrcLoadDate, SrcTblKey, ClientMemberKey, AttribNPI, MbrPlan, PlanTblKey, RecLoadID)
		SELECT MbrLoadDate, MbrKey, PatientID, AttribNPI, PlanCode, PlanKey,' + char(39) + @RecLoadID  + char(39)+'
			FROM ' + @tmpMbrPlan + ' 
			WHERE MbrLoadDate =' + char(39) + @RecLoadDate + char(39) + ' ' + @AndWhere + ' '
END

	SET @cRTotal += @c
	SET @c = @c + 1 
	--PRINT @SQLUpdateInsertRec 
	EXEC dbo.sp_executesql @SQLUpdateInsertRec 

END
END

/***
EXEC dbo.x_sp_ProcessMbrKeys '[adi].[Steward_BCBS_Membership]','01-01-2021','dbo.z_tmp_MbrKeyTbl'

SELECT DISTINCT SrcLoadDate, RecStatus, count(*) as CntRec FROM dbo.z_tmp_MbrKeyTbl GROUP BY SrcLoadDate, RecStatus ORDER BY SrcLoadDate, RecStatus
SELECT TOP 1000 * FROM dbo.z_tmp_MbrKeyTbl
select top 100 * FROM [adi].[Steward_BCBS_Membership] m WHERE PatientID = '710391787'

DECLARE		@months table(mth int)
INSERT INTO @months values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)

DECLARE		@calendar table(yr int,mth int)
INSERT INTO @calendar
SELECT DISTINCT year(EffDate),mth
FROM #tmpCalTbl cross join @months
UNION
SELECT DISTINCT year(TermDate),mth
FROM #tmpCalTbl cross join @months

SELECT EffMbrYear, EffMbrMonth, count(DISTINCT ClientMemberKey) as CntMbr
FROM (
	SELECT t.ClientMemberKey, t.EffDate, t.TermDate, y.yr [EffMbrYear], y.mth [EffMbrMonth] 
	FROM #tmpCalTbl t
	INNER JOIN @calendar y on year(EffDate) = yr or year(TermDate) = yr
	WHERE (mth >= month(EffDate) and mth <= month(TermDate) and year(EffDate) = year(TermDate))
		OR  (year(EffDate) < year(TermDate)) 
		AND (year(EffDate) = yr and mth >= month(EffDate)						-- All months of start year
		OR  (year(TermDate) = yr and mth <= month(TermDate)))					-- All months of end year
	) m
GROUP BY EffMbrYear, EffMbrMonth
ORDER BY EffMbrYear, EffMbrMonth

***/
