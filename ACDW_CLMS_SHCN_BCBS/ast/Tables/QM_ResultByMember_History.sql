CREATE TABLE [ast].[QM_ResultByMember_History] (
    [pstQM_ResultByMbr_HistoryKey] INT           IDENTITY (1, 1) NOT NULL,
    [astRowStatus]                 VARCHAR (20)  NOT NULL,
    [srcFileName]                  VARCHAR (150) NULL,
    [adiTableName]                 VARCHAR (100) NOT NULL,
    [adiKey]                       INT           NOT NULL,
    [LoadDate]                     DATE          NOT NULL,
    [CreateDate]                   DATETIME      CONSTRAINT [DF_QM_bcbsResultByMbr_History_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreateBy]                     VARCHAR (50)  CONSTRAINT [DF_QM_bcbsResultByMbr_History_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]              DATETIME      CONSTRAINT [df_AdwQM_bcbsResultByMember_History_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]                VARCHAR (50)  CONSTRAINT [df_AdwQM_bcbsResultByMember_History_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [ClientKey]                    INT           NOT NULL,
    [ClientMemberKey]              VARCHAR (50)  NOT NULL,
    [QmMsrId]                      VARCHAR (100) NULL,
    [QmCntCat]                     VARCHAR (10)  NOT NULL,
    [QMDate]                       DATE          CONSTRAINT [DF_QM_bcbsResultByMbr_History_QmDate] DEFAULT (CONVERT([date],getdate())) NULL,
    [srcQmDescription]             VARCHAR (400) NULL,
    [srcQmIdentifier]              VARCHAR (20)  NULL,
    [transQmDescriptionRule]       VARCHAR (50)  NULL,
    [transQmIDRule]                VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([pstQM_ResultByMbr_HistoryKey] ASC)
);

