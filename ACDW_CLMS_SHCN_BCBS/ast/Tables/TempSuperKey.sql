CREATE TABLE [ast].[TempSuperKey] (
    [ClmBigKey]       VARCHAR (100) NULL,
    [claimID]         VARCHAR (30)  NULL,
    [PatientID]       DECIMAL (18)  NULL,
    [ServiceFromDate] DATE          NULL,
    [ServiceToDate]   DATE          NULL,
    [ClaimType]       VARCHAR (7)   NOT NULL,
    [datadate]        DATE          NULL
);

