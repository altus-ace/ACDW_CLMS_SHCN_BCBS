﻿CREATE TABLE [dbo].[tmp_AHR_HL7_Population] (
    [ID]                INT           IDENTITY (100000, 1) NOT NULL,
    [ACE_ID]            NUMERIC (20)  NULL,
    [SUBSCRIBER_ID]     VARCHAR (50)  NULL,
    [FIRSTNAME]         VARCHAR (100) NULL,
    [LASTNAME]          VARCHAR (100) NULL,
    [GENDER]            VARCHAR (1)   NULL,
    [DOB]               DATE          NULL,
    [TIN]               VARCHAR (50)  NULL,
    [NPI]               VARCHAR (50)  NULL,
    [EMR_ID]            VARCHAR (25)  NULL,
    [EMR_NPI]           VARCHAR (50)  NULL,
    [EMR_FIRST_NAME]    VARCHAR (50)  NULL,
    [EMR_MI]            VARCHAR (1)   NULL,
    [EMR_LAST_NAME]     VARCHAR (50)  NULL,
    [EMR_CLIENT_ID]     VARCHAR (50)  NULL,
    [EMR_CLIENT_NAME]   VARCHAR (50)  NULL,
    [EMR_ALT_CLIENT_ID] VARCHAR (50)  NULL,
    [EMR_PRACTICE_TIN]  VARCHAR (50)  NULL,
    [AttribNPI]         VARCHAR (10)  NULL,
    [AttribTIN]         VARCHAR (10)  NULL,
    [LOADDATE]          DATE          DEFAULT (sysdatetime()) NULL,
    [LOADEDBY]          VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [CreatedDate]       DATETIME      DEFAULT (getdate()) NULL,
    [CreatedBy]         VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]   DATETIME      DEFAULT (getdate()) NULL,
    [LastUpdatedBy]     VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [AdiKey]            INT           NULL,
    [SrcFileName]       VARCHAR (100) NULL,
    [AdiTableName]      VARCHAR (100) NULL
);

