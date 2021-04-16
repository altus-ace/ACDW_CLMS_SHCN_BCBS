CREATE TABLE [lst].[NtfConfigClientDiag] (
    [NtfConfigClientDiagKey] INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]            VARCHAR (100) NULL,
    [CreatedDate]            DATE          CONSTRAINT [DF_NtfConfigClientDiag_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              VARCHAR (50)  CONSTRAINT [DF_NtfConfigClientDiag_CreatedBY] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]        DATE          CONSTRAINT [DF_NtfConfigClientDiag_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]          VARCHAR (50)  CONSTRAINT [DF_NtfConfigClientDiag_LastUpdatedBY] DEFAULT (suser_sname()) NOT NULL,
    [ClientKey]              INT           NOT NULL,
    [DiagCode]               VARCHAR (10)  NOT NULL,
    [NtfFollupDays]          INT           NOT NULL,
    [NtfFollupUpAnchorDate]  VARCHAR (10)  NOT NULL,
    PRIMARY KEY CLUSTERED ([NtfConfigClientDiagKey] ASC),
    CONSTRAINT [CK_NtfConfigClientDiag_NtfFollowUpAnchorDate] CHECK ([NtfFollupUpAnchorDate]='discharged' OR [NtfFollupUpAnchorDate]='received')
);

