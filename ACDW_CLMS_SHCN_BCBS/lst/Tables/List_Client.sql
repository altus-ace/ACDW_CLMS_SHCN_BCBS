CREATE TABLE [lst].[List_Client] (
    [CreatedDate]                     DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                       VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdated]                     DATETIME      DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]                   VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [SrcFileName]                     VARCHAR (50)  NULL,
    [ClientKey]                       INT           IDENTITY (1, 1) NOT NULL,
    [ClientName]                      VARCHAR (100) NOT NULL,
    [ClientShortName]                 VARCHAR (15)  NOT NULL,
    [CS_Export_LobName]               VARCHAR (20)  CONSTRAINT [DF_LstList_CLIENT_CS_LOB_NAME] DEFAULT ('CS_LOB') NULL,
    [IpDischargeFollupIntervalInDays] TINYINT       DEFAULT ((0)) NOT NULL,
    [ErDischargeFollupIntervalInDays] TINYINT       DEFAULT ((0)) NOT NULL,
    [ACTIVE]                          CHAR (1)      DEFAULT ('Y') NULL,
    [EffectiveDate]                   DATE          DEFAULT (getdate()) NULL,
    [ExpirationDate]                  DATE          DEFAULT ('2099-12-31') NULL,
    PRIMARY KEY CLUSTERED ([ClientKey] ASC)
);

