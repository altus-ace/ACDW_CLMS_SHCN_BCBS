CREATE TABLE [adi].[Steward_BCBS_FileSummary] (
    [FileSummaryKey]   INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]      VARCHAR (100) NULL,
    [CreateDate]       DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]         VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [OriginalFileName] VARCHAR (100) NULL,
    [LastUpdatedBy]    VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]  DATETIME      DEFAULT (sysdatetime()) NULL,
    [DataDate]         DATE          NULL,
    [FieldType]        VARCHAR (100) NULL,
    [RecordCount]      INT           NULL,
    [FileName]         VARCHAR (100) NULL,
    [ClaimCount]       INT           NULL,
    PRIMARY KEY CLUSTERED ([FileSummaryKey] ASC)
);

