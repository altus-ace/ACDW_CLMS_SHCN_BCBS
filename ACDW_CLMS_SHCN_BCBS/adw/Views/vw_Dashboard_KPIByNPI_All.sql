
CREATE VIEW [adw].[vw_Dashboard_KPIByNPI_All]
AS
    -- 
    SELECT [FctFctMEKpiNPIKey]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[AdiKey]
      ,[SrcFileName]
      ,[AdwTableName]
      ,[LoadDate]
      ,[DataDate]
      ,[EffectiveAsOfDate]
      ,[KPI_ID]
      ,[KPI]
      ,substring([KPI],PATINDEX('%-%',[KPI])+1, len([KPI])) as KPIShort
      ,[KPIEffYear]
      ,[KPIEffMth]
      ,[AttribNPI]
      ,[AttribNPIName]
      ,[AttribTIN]
      ,[AttribTINName]
      ,[KPIValue]
      ,[KPIValue2]
      ,NPIChapter
FROM [adw].[FctMEKPIByNPI]
    LEFT JOIN (SELECT DISTINCT PCP_NPI, PCP_POD as NPIChapter
			 FROM lst.List_PCP) c
    ON c.PCP_NPI = [AttribNPI]
;

