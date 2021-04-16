CREATE TABLE [lst].[LIST_Disch_Disposition] (
    [CreatedDate]            DATETIME       DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              VARCHAR (50)   DEFAULT (suser_sname()) NOT NULL,
    [LastUpdated]            DATETIME       DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]          VARCHAR (50)   DEFAULT (suser_sname()) NOT NULL,
    [SrcFileName]            VARCHAR (50)   NULL,
    [lstDischDispositionKey] INT            IDENTITY (1, 1) NOT NULL,
    [DataDate]               DATE           NOT NULL,
    [Disch_Disp_Code]        VARCHAR (10)   NULL,
    [Disch_Disp_CodeValue]   VARCHAR (100)  NULL,
    [Disch_Disp_Description] VARCHAR (1000) NULL,
    [Version]                VARCHAR (50)   NULL,
    [ACTIVE]                 CHAR (1)       DEFAULT ('Y') NULL,
    [EffectiveDate]          DATE           DEFAULT (getdate()) NULL,
    [ExpirationDate]         DATE           DEFAULT ('2099-12-31') NULL,
    [Disch_Disp_CodePadded]  VARCHAR (10)   NULL
);

