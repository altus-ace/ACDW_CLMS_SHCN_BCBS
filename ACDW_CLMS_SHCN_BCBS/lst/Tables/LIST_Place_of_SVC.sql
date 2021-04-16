CREATE TABLE [lst].[LIST_Place_of_SVC] (
    [CreatedDate]                  DATETIME       DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                    VARCHAR (50)   DEFAULT (suser_sname()) NOT NULL,
    [LastUpdated]                  DATETIME       DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]                VARCHAR (50)   DEFAULT (suser_sname()) NOT NULL,
    [SrcFileName]                  VARCHAR (50)   NULL,
    [lstPlaceOfSvcKey]             INT            IDENTITY (1, 1) NOT NULL,
    [DataDate]                     DATE           NOT NULL,
    [Place_of_Service_Code]        VARCHAR (10)   NULL,
    [Place_of_Service_Name]        VARCHAR (100)  NULL,
    [Place_of_Service_Description] VARCHAR (1000) NULL,
    [Version]                      VARCHAR (50)   NULL,
    [ACTIVE]                       CHAR (1)       DEFAULT ('Y') NULL,
    [EffectiveDate]                DATE           DEFAULT (getdate()) NULL,
    [ExpirationDate]               DATE           DEFAULT ('2099-12-31') NULL
);

