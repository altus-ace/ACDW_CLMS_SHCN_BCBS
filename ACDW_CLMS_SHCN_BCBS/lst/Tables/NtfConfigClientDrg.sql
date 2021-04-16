CREATE TABLE [lst].[NtfConfigClientDrg] (
    [NtfConfigClientDrgKey] INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]           VARCHAR (100) NULL,
    [CreatedDate]           DATE          CONSTRAINT [DF_NtfConfigClientDrg_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]             VARCHAR (50)  CONSTRAINT [DF_NtfConfigClientDrg_CreatedBY] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]       DATE          CONSTRAINT [DF_NtfConfigClientDrg_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]         VARCHAR (50)  CONSTRAINT [DF_NtfConfigClientDrg_LastUpdatedBY] DEFAULT (suser_sname()) NOT NULL,
    [ClientKey]             INT           NOT NULL,
    [NtfType]               VARCHAR (10)  NOT NULL,
    [DrgCode]               VARCHAR (10)  NOT NULL,
    [NtfFollupDays]         INT           NOT NULL,
    [NtfFollupUpAnchorDate] VARCHAR (10)  NOT NULL,
    PRIMARY KEY CLUSTERED ([NtfConfigClientDrgKey] ASC),
    CONSTRAINT [CK_NtfConfigClientDrg_NtfFollowUpAnchorDate] CHECK ([NtfFollupUpAnchorDate]='discharged' OR [NtfFollupUpAnchorDate]='received'),
    CONSTRAINT [CK_NtfConfigClientDrg_NtfType] CHECK ([NtfType]='PP' OR [NtfType]='MH' OR [NtfType]='ER' OR [NtfType]='IP')
);

