CREATE TABLE [adi].[BCBSPatientPhoneNumber] (
    [BCBSPatientPhoneNumberKey] INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]               VARCHAR (100) NOT NULL,
    [CreateDate]                DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [CreateBy]                  VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]           DATETIME      DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]             VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [DataDate]                  DATE          NOT NULL,
    [PatientPolicyidNumber]     VARCHAR (50)  NULL,
    [PatientFirstName]          VARCHAR (50)  NULL,
    [PatientLastName]           VARCHAR (50)  NULL,
    [PatientHomePhone]          VARCHAR (15)  NULL,
    [PatientMobilePhone]        VARCHAR (15)  NULL,
    PRIMARY KEY CLUSTERED ([BCBSPatientPhoneNumberKey] ASC)
);

