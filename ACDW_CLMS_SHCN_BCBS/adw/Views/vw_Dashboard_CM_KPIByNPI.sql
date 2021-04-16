
/***
11.05.20 SN Removed the pmpm calc for ('601','602','603','604','605','606','607')
***/

CREATE VIEW [adw].[vw_Dashboard_CM_KPIByNPI]
AS (
	SELECT										-- For Non Quality KPI_IDs
	    m.AttribTIN							as	[PracticeTIN]
	   ,m.AttribTINName						as [PracticeName]
	   ,CONVERT(VARCHAR(11), m.AttribNPI)	as [NPI]							
	   ,m.AttribNPIName						as [ProviderName]
	   ,m.NPIChapter						as [Chapter]
	   ,m.KPIEffYear						as	[KPIEffYear]
	   ,m.KPIEffMth							as [KPIEffMth]
	   ,m.EffectiveAsofDate					as [EffectiveAsOfDate]
		,m.KPI_ID
	   ,ISNULL(ss.MeasureDesc,m.KPI)		as KPI		--
		,ISNULL(mm.KPIValue,0)				as MbrMths
	 	,ISNULL(ip.KPIValue,0)				as IPAdmits
		,ISNULL(awv.KPIValue*100,0)			as AWV
		,ISNULL(awvpcp.KPIValue*100,0)		as AWVPCP
	 	,ISNULL(tme.KPIValue,0)				as TME
		,ISNULL((CASE WHEN m.KPI_ID IN ('200','201','203','205','300','301','302','303','304','305','306','307','308','309','310','311','312','321') 
			THEN CONVERT(int,CAST(m.KPIValue as float)/mm.KPIValue*1000,0)											-- PerK
			WHEN m.KPI_ID IN ('204') THEN CONVERT(int,CAST(m.KPIValue as float)/ip.KPIValue*100,0)			-- Pct
			WHEN m.KPI_ID IN ('400') THEN CONVERT(int,CAST(awv.KPIValue as float)/mm.KPIValue*100,0)		-- Pct
			WHEN m.KPI_ID IN ('401') THEN CONVERT(int,CAST(awvpcp.KPIValue as float)/awv.KPIValue*100,0)	-- Pct
			WHEN m.KPI_ID IN ('620') THEN CONVERT(int,m.KPIValue*100,0)												-- Value
			--WHEN m.KPI_ID IN ('601','602','603','604','605','606','607') THEN CONVERT(int,CAST(tme.KPIValue as float)/mm.KPIValue*100,0)
			ELSE m.KPIValue END ),0)		as Metric
		,m.KPIValue								as Raw
	   ,ISNULL(ss.Score_A,0)				as KPITarget
	FROM [adw].[vw_Dashboard_ME_KPIByNPI] m
	LEFT JOIN [adw].[vw_Dashboard_ME_KPIByNPI] mm
	ON		mm.KPIEffYear		= m.KPIEffYear
		AND	mm.KPIEffMth		= m.KPIEffMth
		AND	mm.AttribNPI		= m.AttribNPI
		AND	mm.KPI_ID			= '109'
	LEFT JOIN [adw].[vw_Dashboard_ME_KPIByNPI] awv
		ON		awv.KPIEffYear		= m.KPIEffYear
		AND	awv.KPIEffMth		= m.KPIEffMth
		AND	awv.AttribNPI		= m.AttribNPI
		AND	awv.KPI_ID			= m.KPI_ID
		AND	awv.KPI_ID			= '400'
	LEFT JOIN [adw].[vw_Dashboard_ME_KPIByNPI] awvpcp
		ON		awvpcp.KPIEffYear		= m.KPIEffYear
		AND	awvpcp.KPIEffMth	= m.KPIEffMth
		AND	awvpcp.AttribNPI	= m.AttribNPI
		AND	awvpcp.KPI_ID		= m.KPI_ID
		AND	awvpcp.KPI_ID		= '401'
	LEFT JOIN [adw].[vw_Dashboard_ME_KPIByNPI] tme
		ON		tme.KPIEffYear		= m.KPIEffYear
		AND	tme.KPIEffMth		= m.KPIEffMth
		AND	tme.AttribNPI		= m.AttribNPI
		AND	tme.KPI_ID			= m.KPI_ID
		AND	tme.KPI_ID			= '601'
	LEFT JOIN [adw].[vw_Dashboard_ME_KPIByNPI] ip
		ON		ip.KPIEffYear		= m.KPIEffYear
		AND	ip.KPIEffMth		= m.KPIEffMth
		AND	ip.AttribNPI		= m.AttribNPI
		AND	ip.KPI_ID			= '200'
	LEFT JOIN [adw].[vw_Dashboard_ME_KPIByNPI] pmpm
		ON		pmpm.KPIEffYear	= m.KPIEffYear
		AND	pmpm.KPIEffMth		= m.KPIEffMth
		AND	pmpm.AttribNPI		= m.AttribNPI
		AND	pmpm.KPI_ID			= '620'
	LEFT JOIN [lst].[lstScoringSystem] ss
		ON		ss.MeasureID		= m.KPI_ID
		AND	ss.ClientKey		= 16
		AND	ss.ScoringType		= 'KPI'
		AND	getdate()			BETWEEN ss.EffectiveDate AND ss.ExpirationDate
	WHERE m.KPIEffYear			= (SELECT MAX(KPIEffYear) FROM [adw].[vw_Dashboard_ME_KPIByNPI] WHERE KPI_ID = 109)
		AND  m.KPI_ID				< 621
		AND  m.KPIEffMth			= (SELECT MAX(KPIEffMth) FROM [adw].[vw_Dashboard_ME_KPIByNPI] WHERE KPIEffYear = (SELECT MAX(KPIEffYear) FROM [adw].[vw_Dashboard_ME_KPIByNPI] WHERE KPI_ID = 109) AND  KPI_ID = 109)
		AND  m.KPI_ID				NOT IN (102,103,405,406,407,500,501,502,510,700)
	UNION
	SELECT							-- For Quality KPI_IDs
	    m.AttribTIN							as	[PracticeTIN]
	   ,m.AttribTINName						as [PracticeName]
	   ,m.AttribNPI							as [NPI]							
	   ,m.AttribNPIName						as [ProviderName]
	   ,m.NPIChapter							as [Chapter]
	   ,m.KPIEffYear							as	[KPIEffYear]
	   ,m.KPIEffMth							as [KPIEffMth]
	   ,m.EffectiveAsofDate					as [EffectiveAsOfDate]
		,m.KPI_ID
	   ,ISNULL(ss.MeasureDesc,m.KPI)						as KPI		--
		,0											as MbrMths
	 	,0											as IPAdmits
		,0											as AWV
		,0											as AWVPCP
	 	,0											as TME
		,m.KPIValue								as Metric
		,m.KPIValue								as Raw
	   ,ISNULL(ss.Score_A,0)				as KPITarget
	FROM [adw].[vw_Dashboard_ME_KPIByNPI] m
	LEFT JOIN [lst].[lstScoringSystem] ss
		ON		ss.MeasureID		= m.KPI_ID
		AND	ss.ClientKey		= 16
		AND	ss.ScoringType		= 'KPI'
		AND	getdate()			BETWEEN ss.EffectiveDate AND ss.ExpirationDate
	WHERE m.KPIEffYear			= (SELECT MAX(KPIEffYear) FROM [adw].[vw_Dashboard_ME_KPIByNPI] WHERE KPI_ID = 500)
		AND  m.KPIEffMth			= (SELECT MAX(KPIEffMth) FROM [adw].[vw_Dashboard_ME_KPIByNPI] WHERE KPIEffYear = (SELECT MAX(KPIEffYear) FROM [adw].[vw_Dashboard_ME_KPIByNPI] WHERE KPI_ID = 500) AND  KPI_ID = 500)
		AND  m.KPI_ID				IN (102,103,405,406,407,500,501,502,510,700)
)









