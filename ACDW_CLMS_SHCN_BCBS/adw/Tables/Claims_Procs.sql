CREATE TABLE [adw].[Claims_Procs] (
    [URN]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [SEQ_CLAIM_ID]    VARCHAR (50)  NULL,
    [SUBSCRIBER_ID]   VARCHAR (50)  NULL,
    [ProcNumber]      SMALLINT      NULL,
    [ProcCode]        VARCHAR (20)  NULL,
    [ProcDate]        VARCHAR (50)  NULL,
    [LoadDate]        DATETIME      NOT NULL,
    [SrcAdiTableName] VARCHAR (100) NULL,
    [SrcAdiKey]       INT           NOT NULL,
    [CreatedDate]     DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [PK_Claims_Procs] PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO

CREATE TRIGGER [adw].[ClaimsProcs_AfterUpdate]
ON [adw].[Claims_Procs]
AFTER UPDATE 
AS
   UPDATE adw.Claims_Procs
   SET LastUpdatedDate = SYSDATETIME()
	, LastUpdatedBy = SYSTEM_USER
   FROM Inserted i
   WHERE adw.Claims_Procs.URN = i.URN;
