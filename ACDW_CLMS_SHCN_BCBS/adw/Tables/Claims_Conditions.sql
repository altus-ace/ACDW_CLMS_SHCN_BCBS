CREATE TABLE [adw].[Claims_Conditions] (
    [URN]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [SEQ_CLAIM_ID]    VARCHAR (50)  NOT NULL,
    [SUBSCRIBER_ID]   VARCHAR (50)  NOT NULL,
    [CONDNUMBER]      SMALLINT      NOT NULL,
    [CONDITION_CODE]  VARCHAR (20)  NULL,
    [SrcAdiTableName] VARCHAR (100) NULL,
    [SrcAdiKey]       INT           NULL,
    [LoadDate]        DATETIME      NOT NULL,
    [CreatedDate]     DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO
CREATE TRIGGER [adw].[ClaimsConditions_AfterUpdate]
ON [adw].[Claims_Conditions]
AFTER UPDATE 
AS
   UPDATE adw.Claims_Conditions
   SET LastUpdatedDate = SYSDATETIME()
	, LastUpdatedBy   = SYSTEM_USER
   FROM Inserted i
   WHERE adw.Claims_Conditions.URN = i.URN;
