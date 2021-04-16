﻿CREATE TABLE [adw].[Claims_Details] (
    [ClaimsDetailsKey]             INT             IDENTITY (1, 1) NOT NULL,
    [CLAIM_NUMBER]                 VARCHAR (50)    NULL,
    [SUBSCRIBER_ID]                VARCHAR (50)    NULL,
    [SEQ_CLAIM_ID]                 VARCHAR (50)    NULL,
    [LINE_NUMBER]                  SMALLINT        NULL,
    [SUB_LINE_CODE]                VARCHAR (50)    NULL,
    [DETAIL_SVC_DATE]              DATE            NULL,
    [SVC_TO_DATE]                  DATE            NULL,
    [PROCEDURE_CODE]               VARCHAR (50)    NULL,
    [MODIFIER_CODE_1]              VARCHAR (20)    NULL,
    [MODIFIER_CODE_2]              VARCHAR (20)    NULL,
    [MODIFIER_CODE_3]              VARCHAR (20)    NULL,
    [MODIFIER_CODE_4]              VARCHAR (20)    NULL,
    [REVENUE_CODE]                 SMALLINT        NULL,
    [PLACE_OF_SVC_CODE1]           VARCHAR (10)    NULL,
    [PLACE_OF_SVC_CODE2]           VARCHAR (10)    NULL,
    [PLACE_OF_SVC_CODE3]           VARCHAR (10)    NULL,
    [QUANTITY]                     NUMERIC (12, 2) NULL,
    [BILLED_AMT]                   MONEY           NULL,
    [PAID_AMT]                     MONEY           NULL,
    [NDC_CODE]                     VARCHAR (20)    NULL,
    [RX_GENERIC_BRAND_IND]         VARCHAR (50)    NULL,
    [RX_SUPPLY_DAYS]               VARCHAR (50)    NULL,
    [RX_DISPENSING_FEE_AMT]        MONEY           NULL,
    [RX_INGREDIENT_AMT]            MONEY           NULL,
    [RX_FORMULARY_IND]             VARCHAR (50)    NULL,
    [RX_DATE_PRESCRIPTION_WRITTEN] DATE            NULL,
    [RX_DATE_PRESCRIPTION_FILLED]  DATE            NULL,
    [PRESCRIBING_PROV_TYPE_ID]     VARCHAR (10)    NULL,
    [PRESCRIBING_PROV_ID]          VARCHAR (20)    NULL,
    [BRAND_NAME]                   VARCHAR (50)    NULL,
    [DRUG_STRENGTH_DESC]           VARCHAR (50)    NULL,
    [GPI]                          VARCHAR (50)    NULL,
    [GPI_DESC]                     VARCHAR (50)    NULL,
    [CONTROLLED_DRUG_IND]          VARCHAR (50)    NULL,
    [COMPOUND_CODE]                VARCHAR (50)    NULL,
    [SrcAdiTableName]              VARCHAR (100)   NULL,
    [SrcAdiKey]                    INT             NOT NULL,
    [LoadDate]                     DATETIME        NOT NULL,
    [CreatedDate]                  DATETIME        DEFAULT (sysdatetime()) NOT NULL,
    [CreatedBy]                    VARCHAR (50)    DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]              DATETIME        DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]                VARCHAR (50)    DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ClaimsDetailsKey] ASC)
);


GO
CREATE TRIGGER [adw].[ClaimsDetails_AfterUpdate]
ON [adw].[Claims_Details]
AFTER UPDATE 
AS
   UPDATE adw.Claims_Details
   SET LastUpdatedDate = SYSDATETIME()
	, LastUpdatedBy   = SYSTEM_USER
   FROM Inserted i
   WHERE adw.Claims_Details.ClaimsDetailsKey = i.ClaimsDetailsKey;
