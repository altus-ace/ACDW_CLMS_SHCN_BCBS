
--SELECT * FROM (
--	SELECT DISTINCT
--		p.PatientID, p.MemberEffectiveDate, p.MemberTerminateDate ,p.AttributedPrimaryCareProviderNPI, p.DataDate, p.CreateDate 
--		,c.ProgramIndicator
--		,CASE WHEN l.SourceValue IS NULL THEN 0 ELSE 1 END as PlanMatchFlg
--		,CASE WHEN plu.AttribNPI IS NULL THEN 0 ELSE 1 END as NPIMatchFlg
--		,DATEDIFF(mm,p.MemberEffectiveDate,CAST(DATEADD(YEAR,DATEDIFF(YEAR, -1, p.MemberEffectiveDate ), -1) AS DATE))+1 as MbrMths
--		,CONCAT(YEAR(p.DataDate),CONVERT(CHAR(2), p.DataDate,101)) as LoadYYYYMM 
--		,ROW_NUMBER() OVER (PARTITION BY p.PatientId, 2, p.MemberEffectiveDate ORDER BY p.MembershipKey DESC) as rn 
--	FROM [adi].[Steward_BCBS_Membership] p 
--	LEFT JOIN [adi].[Steward_BCBS_MemberCrosswalk] c
--		ON p.PatientID		= c.PatientID
--		AND p.DataDate		= c.DataDate
--		AND c.Indicator834	= 'Y'
--	LEFT JOIN (SELECT DISTINCT ClientKey, SourceValue, EffectiveDate, ExpirationDate FROM lst.lstPlanMapping WHERE TargetSystem = 'ACDW') l ON c.ProgramIndicator = l.SourceValue
--	LEFT JOIN ACECAREDW.adw.tvf_GetFromProviderRoster (20) plu ON p.AttributedPrimaryCareProviderNPI  = plu.AttribNPI 
--	WHERE p.PatientID IS NOT NULL 
--		AND l.clientkey = 20
--		AND p.DataDate BETWEEN l.EffectiveDate AND l.ExpirationDate		
--		--AND p.DataDate BETWEEN plu.EffectiveDate AND plu.ExpirationDate	
--) n WHERE n.rn = 1

--DROP TABLE dbo.z_tmp_AttribMembers
--CREATE TABLE dbo.z_tmp_AttribMembers (
--	 URN					INT	IDENTITY NOT NULL
--	,adiKey				INT
--	,ClientMemberKey	VARCHAR(50)
--	,ClientKey			INT
--	,EffDate				DATE
--	,LoadDate			DATE
--	,ActiveFlg			INT DEFAULT 1
--	,PlanMatchFlg		INT
--	,NPIMatchFlg		INT
--	,InsertRunId		VARCHAR(10)
--	,UpdateRunId		VARCHAR(10)
--	,CreateDate			DATE DEFAULT getdate()
--	,CreateBy			VARCHAR(50) DEFAULT suser_sname())	 


CREATE PROCEDURE adw.z_CreateBCBSMembers
AS

DECLARE @MELoadDateTable	TABLE(
	 URN					INT	IDENTITY NOT NULL
	,MELoadDate			DATE	 
	,NumOfRecs			INT)
INSERT INTO @MELoadDateTable
	(MELoadDate,NumOfRecs)
SELECT DISTINCT CONVERT(date,p.DataDate), COUNT(*) FROM [adi].[Steward_BCBS_Membership] p 
	--JOIN lst.lstPlanMapping l ON p.plan_name = l.TargetValue
	--JOIN adw.tvf_GetFromProviderRoster (12) plu ON p.NPID  = plu.AttribNPI
WHERE YEAR(p.DataDate) >= 2020 
	--AND l.clientkey = 12
	--AND DataDate BETWEEN l.EffectiveDate AND l.ExpirationDate
	--AND DataDate BETWEEN plu.EffectiveDate AND plu.ExpirationDate
	--AND L.TargetSystem = 'ACDW'
GROUP BY CONVERT(date,p.DataDate) ORDER BY CONVERT(date,p.DataDate) 

--SELECT * FROM @MELoadDateTable
DECLARE @SQL				NVARCHAR(3000)
DECLARE @i					INT	= 1
DECLARE @rTotal			BIGINT = 0
DECLARE @RowCnt			BIGINT = 0

SELECT @RowCnt = count(0) FROM @MELoadDateTable
WHILE @i <= @RowCnt
BEGIN
DECLARE @MELoadDate		VARCHAR(20)	= (SELECT MELoadDate FROM @MELoadDateTable WHERE URN = @i)
DECLARE @InsertRunID		VARCHAR(10)	= (SELECT CONCAT('I',URN) FROM @MELoadDateTable WHERE URN = @i)
DECLARE @UpdateRunID		VARCHAR(10)	= (SELECT CONCAT('U',URN) FROM @MELoadDateTable WHERE URN = @i)

SET NOCOUNT ON;
SET @SQL='
IF OBJECT_ID(N'+ char(39) + 'tempdb..#tmpTable' + char(39) + ') IS NOT NULL
DROP TABLE #tmpTable
SELECT * INTO #tmpTable FROM (
SELECT p.MembershipKey as AdiKey, p.PatientID as ClientMemberKey, 20 as ClientKey, p.MemberEffectiveDate as EffDate
	,CASE WHEN l.SourceValue IS NULL THEN 0 ELSE 1 END as PlanMatchFlg
	,CASE WHEN plu.AttribNPI IS NULL THEN 0 ELSE 1 END as NPIMatchFlg
	,convert(date,p.DataDate) as LoadDate
	,ROW_NUMBER() OVER (PARTITION BY p.PatientId, 2, p.MemberEffectiveDate ORDER BY p.MembershipKey DESC) as rn 
	FROM [adi].[Steward_BCBS_Membership] p 
	LEFT JOIN [adi].[Steward_BCBS_MemberCrosswalk] c
		ON p.PatientID		= c.PatientID
		AND p.DataDate		= c.DataDate
		AND c.Indicator834	= ' + char(39) + 'Y' + char(39) + '
	LEFT JOIN (SELECT DISTINCT ClientKey, SourceValue, EffectiveDate, ExpirationDate FROM lst.lstPlanMapping WHERE TargetSystem = ' + char(39) + 'ACDW' + char(39) + ') l ON c.ProgramIndicator = l.SourceValue
	LEFT JOIN ACECAREDW.adw.tvf_GetFromProviderRoster (20) plu ON p.AttributedPrimaryCareProviderNPI  = plu.AttribNPI 
	WHERE p.PatientID IS NOT NULL 
		AND l.clientkey = 20
		AND p.DataDate BETWEEN l.EffectiveDate AND l.ExpirationDate		
) m WHERE rn = 1 
UPDATE dbo.z_tmp_AttribMembers 
SET ActiveFlg = 0,
	UpdateRunID = ' + char(39) + @UpdateRunID + char(39) + '
FROM dbo.z_tmp_AttribMembers m
JOIN #tmpTable j
	ON		m.ClientMemberKey = j.ClientMemberKey
	AND	m.ClientKey			= j.ClientKey
	AND	m.EffDate			= j.EffDate
INSERT INTO dbo.z_tmp_AttribMembers (adiKey,ClientMemberKey,ClientKey,EffDate,LoadDate,InsertRunID,PlanMatchFlg,NPIMatchFlg)
SELECT p.adiKey, p.ClientMemberKey, 20, p.EffDate, convert(date,p.LoadDate), ' + char(39) +  @InsertRunID + char(39) + ',PlanMatchFlg,NPIMatchFlg  
FROM #tmpTable p
'

--PRINT @SQL
EXEC dbo.sp_executesql @SQL
SET @rTotal	+= @i
SET @i= @i + 1
END

/***
EXEC adw.z_CreateBCBSMembers

SELECT * FROM dbo.z_tmp_AttribMembers

select LoadDate, count(adiKey) as CntRec from dbo.z_tmp_AttribMembers where ActiveFlg = 1 AND YEAR(EffDate) = 2020 group by LoadDate
truncate table dbo.z_tmp_AttribMembers
drop table #tmpCalTbl
------------------
SELECT adi.memberid as ClientMemberKey
	,adi.EffectiveDate as EffDate
	,m.PlanMatchFlg
	,m.NPIMatchFlg
	--,CASE WHEN adi.TermDate IS NULL THEN DATEDIFF(mm,adi.Effectivedate,CAST(DATEADD(YEAR,DATEDIFF(YEAR, -1, adi.Effdate), -1) AS DATE))+1 ELSE DATEDIFF(mm,adi.Effdate,adi.TermDate)+1 END as MbrMths
	--,CASE WHEN adi.TermDate IS NULL THEN CAST(DATEADD(YEAR,DATEDIFF(YEAR, -1, adi.Effectivedate), -1) AS DATE) ELSE adi.TermDate END as TermDate
	,DATEDIFF(mm,adi.Effectivedate,CAST(DATEADD(YEAR,DATEDIFF(YEAR, -1, adi.Effectivedate), -1) AS DATE))+1 as MbrMths
	,CAST(DATEADD(YEAR,DATEDIFF(YEAR, -1, adi.Effectivedate), -1) AS DATE) as TermDate
--INTO #tmpCalTbl
FROM ACDW_CLMS_CIGNA_MA.adi.tmp_CignaMAMembership adi
JOIN dbo.z_tmp_AttribMembers m
ON		adi.MbrKey		= m.adiKey

declare @months table(mth int)
insert into @months values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)

declare @calendar table(yr int,mth int)
insert into @calendar
select distinct year(EffDate),mth
from #tmpCalTbl cross join @months
union
select distinct year(TermDate),mth
from #tmpCalTbl cross join @months

SELECT EffMbrYear, EffMbrMonth, count(DISTINCT ClientMemberKey) as CntMbr
FROM (
	select t.ClientMemberKey, t.EffDate, t.TermDate, y.yr [EffMbrYear], y.mth [EffMbrMonth] 
	from #tmpCalTbl t
	inner join @calendar y on year(EffDate) = yr or year(TermDate) = yr
	where (mth >= month(EffDate) and mth <= month(TermDate) and year(EffDate) = year(TermDate))
	or (year(EffDate) < year(TermDate)) 
	and (year(EffDate) = yr and mth >= month(EffDate) --All months of start year
	or (year(TermDate) = yr and mth <= month(TermDate))) -- All months of end year
	) m
GROUP BY EffMbrYear, EffMbrMonth
ORDER BY EffMbrYear, EffMbrMonth
***/


