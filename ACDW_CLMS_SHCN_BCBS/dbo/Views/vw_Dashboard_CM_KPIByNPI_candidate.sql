





CREATE VIEW [dbo].[vw_Dashboard_CM_KPIByNPI_candidate]
AS (

SELECT  
       m.AttribTIN						as	[PracticeTIN]
      ,m.AttribTINName					as [PracticeName]
      ,m.AttribNPI						as [NPI]							
      ,m.AttribNPIName					as [ProviderName]
      ,m.NPIChapter						as [Chapter]
      ,m.KPIEffYear						as	[KPIEffYear]
      ,m.KPIEffMth						as [KPIEffMonth]
      ,m.EffectiveAsofDate				as [EffectiveAsOfDate]
		,m.KPI_ID
      ,m.KPI
		,ISNULL(mm.KPIValue,0)			as MbrMths
 		,ISNULL(ip.KPIValue,0)			as IPAdmits
		,ISNULL(awv.KPIValue*100,0)		as AWV
		,ISNULL(awvpcp.KPIValue*100,0) as AWVPCP
 		,ISNULL(tme.KPIValue,0)			as TME
		,ISNULL((CASE WHEN m.KPI_ID IN ('200','201','203','205','300','301','302','303','304','305','306','307','308','309','310','311','312','321') 
		THEN CONVERT(int,CAST(m.KPIValue as float)/mm.KPIValue*1000,0)					-- PerK
		WHEN m.KPI_ID IN ('204') THEN CONVERT(int,CAST(m.KPIValue as float)/ip.KPIValue*100,0)		-- Pct
		WHEN m.KPI_ID IN ('400') THEN CONVERT(int,CAST(awv.KPIValue as float)/mm.KPIValue*100,0)		-- Pct
		WHEN m.KPI_ID IN ('401') THEN CONVERT(int,CAST(awvpcp.KPIValue as float)/awv.KPIValue*100,0)	-- Pct
		WHEN m.KPI_ID IN ('601','602','603','604','605','606','607') THEN CONVERT(int,CAST(tme.KPIValue as float)/mm.KPIValue*100,0)
		WHEN m.KPI_ID IN ('502')	THEN CONVERT(INT, QM.SumKpiValue)
		ELSE m.KPIValue END ),0)			as Metric
		,m.KPIValue							as Raw
      ,'0'								as [Target]
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
LEFT JOIN (SELECT [KPI],[AttribNPI],[KPIEffYear], KPIEffMth,SUM([KPIValue]) SumKpiValue
		  FROM [ACDW_CLMS_SHCN_MSSP].[adw].[vw_Dashboard_ME_KPIByNPI]
		  WHERE KPI_ID = '502'
			 and KPIEffYear = '2020'			 
		  GROUP BY KPI, AttribNPI, KPIEffYear, KPIEffMth) QM
		ON		ip.KPIEffYear		= m.KPIEffYear
		AND	ip.KPIEffMth		= m.KPIEffMth
		AND	ip.AttribNPI		= m.AttribNPI
		AND	ip.KPI_ID			= '502'
WHERE m.KPIEffYear		= 2020
AND m.KPI_ID				< 611
AND  m.KPI_ID				= 501
AND  (m.KPIEffMth = 5 OR m.KPIEffMth = 9)

)


