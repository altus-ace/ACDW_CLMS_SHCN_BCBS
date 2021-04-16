CREATE TABLE [lst].[HEDIS_2020_ValueSet] (
    [Value Set Name]      VARCHAR (200) NULL,
    [Value Set OID]       VARCHAR (200) NULL,
    [Value Set Version]   VARCHAR (200) NULL,
    [Code]                VARCHAR (200) NULL,
    [Definition]          VARCHAR (200) NULL,
    [Code System]         VARCHAR (200) NULL,
    [Code System OID]     VARCHAR (200) NULL,
    [Code System Version] VARCHAR (200) NULL,
    [CreatedDate]         DATETIME      DEFAULT (getdate()) NULL,
    [CreatedBy]           VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [LastUpdated]         DATETIME      DEFAULT (getdate()) NULL,
    [LastUpdatedBy]       VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [SrcFileName]         VARCHAR (50)  NULL
);

