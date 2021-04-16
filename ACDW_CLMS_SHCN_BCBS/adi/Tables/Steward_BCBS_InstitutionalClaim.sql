﻿CREATE TABLE [adi].[Steward_BCBS_InstitutionalClaim] (
    [InstitutionalClaimKey]             INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]                       VARCHAR (100) NULL,
    [CreateDate]                        DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]                          VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [OriginalFileName]                  VARCHAR (100) NULL,
    [LastUpdatedBy]                     VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]                   DATETIME      DEFAULT (sysdatetime()) NULL,
    [DataDate]                          DATE          NULL,
    [ClaimRecordID]                     VARCHAR (3)   NULL,
    [PatientID]                         DECIMAL (18)  NULL,
    [SubscriberID]                      VARCHAR (30)  NULL,
    [MemberFirstName]                   VARCHAR (35)  NULL,
    [MemberMiddleInitial]               VARCHAR (35)  NULL,
    [MemberLastName]                    VARCHAR (35)  NULL,
    [MemberBirthDate]                   DATE          NULL,
    [MemberGender]                      CHAR (1)      NULL,
    [MemberAddressLine1]                VARCHAR (55)  NULL,
    [MemberAddressLine2]                VARCHAR (55)  NULL,
    [MemberCity]                        VARCHAR (28)  NULL,
    [MemberState]                       CHAR (2)      NULL,
    [MemberZip]                         CHAR (9)      NULL,
    [ClaimID]                           VARCHAR (30)  NULL,
    [ClaimHeaderStatusCode]             CHAR (1)      NULL,
    [AdjustmentSeqNumber]               DECIMAL (4)   NULL,
    [Inpatient_OutpatientCode]          CHAR (2)      NULL,
    [ServiceFromDate]                   DATE          NULL,
    [ServiceToDate]                     DATE          NULL,
    [FacilityName_BillingProviderName]  VARCHAR (75)  NULL,
    [BillingProviderNPI]                CHAR (10)     NULL,
    [ServicingProviderTIN]              CHAR (9)      NULL,
    [HLServicingProviderNPI]            CHAR (10)     NULL,
    [HLServicingProviderFirstName]      VARCHAR (35)  NULL,
    [HLServicingProviderMiddle]         VARCHAR (35)  NULL,
    [HLServicingProviderLastName]       VARCHAR (35)  NULL,
    [HLServicingProviderAddress1]       VARCHAR (55)  NULL,
    [HLServicingProviderStreetAddress]  VARCHAR (55)  NULL,
    [HLServicingProviderCity]           VARCHAR (28)  NULL,
    [HLServicingProviderState]          CHAR (2)      NULL,
    [HLServicingProviderZip]            CHAR (9)      NULL,
    [HLServicingProviderPhoneNumber]    CHAR (10)     NULL,
    [HLServicingProviderTaxonomyCode]   CHAR (10)     NULL,
    [TypeBillCode]                      CHAR (2)      NULL,
    [FrequencyCode]                     CHAR (1)      NULL,
    [DischargeStatusCode]               CHAR (2)      NULL,
    [DRGCode]                           CHAR (3)      NULL,
    [ICDVersionCode]                    CHAR (2)      NULL,
    [HLPrimaryDiagnosisCode]            CHAR (10)     NULL,
    [HLDiagnosisCode2]                  CHAR (10)     NULL,
    [HLDiagnosisCode3]                  CHAR (10)     NULL,
    [HLDiagnosisCode4]                  CHAR (10)     NULL,
    [HLDiagnosisCode5]                  CHAR (10)     NULL,
    [HLDiagnosisCode6]                  CHAR (10)     NULL,
    [HLDiagnosisCode7]                  CHAR (10)     NULL,
    [HLDiagnosisCode8]                  CHAR (10)     NULL,
    [HLDiagnosisCode9]                  CHAR (10)     NULL,
    [HLDiagnosisCode10]                 CHAR (10)     NULL,
    [HLDiagnosisCode11]                 CHAR (10)     NULL,
    [HLDiagnosisCode12]                 CHAR (10)     NULL,
    [ProcedureCode1]                    CHAR (7)      NULL,
    [ProcedureCode2]                    CHAR (7)      NULL,
    [ProcedureCode3]                    CHAR (7)      NULL,
    [ProcedureCode4]                    CHAR (7)      NULL,
    [ProcedureCode5]                    CHAR (7)      NULL,
    [HLBilledAmount]                    DECIMAL (11)  NULL,
    [HLPaidAmount]                      DECIMAL (11)  NULL,
    [ClaimLinenumber]                   DECIMAL (4)   NULL,
    [ClaimLineStatusCode]               CHAR (1)      NULL,
    [LLServicingProviderNPI]            CHAR (10)     NULL,
    [LLServicingProviderFirstName]      CHAR (35)     NULL,
    [LLServicingProviderMiddle]         CHAR (35)     NULL,
    [LLServicingProviderLastName]       CHAR (35)     NULL,
    [LLPrimaryDiagnosisCode]            CHAR (10)     NULL,
    [LLDiagnosisCode2]                  CHAR (10)     NULL,
    [LLDiagnosisCode3]                  CHAR (10)     NULL,
    [LLDiagnosisCode4]                  CHAR (10)     NULL,
    [LLDiagnosisCode5]                  CHAR (10)     NULL,
    [LLDiagnosisCode6]                  CHAR (10)     NULL,
    [LLDiagnosisCode7]                  CHAR (10)     NULL,
    [LLDiagnosisCode8]                  CHAR (10)     NULL,
    [LLDiagnosisCode9]                  CHAR (10)     NULL,
    [LLDiagnosisCode10]                 CHAR (10)     NULL,
    [LLDiagnosisCode11]                 CHAR (10)     NULL,
    [LLDiagnosisCode12]                 CHAR (10)     NULL,
    [RevenueCode]                       CHAR (4)      NULL,
    [HCPCS_CPTCode]                     CHAR (6)      NULL,
    [HCPCS_CPTModifierCode1]            CHAR (2)      NULL,
    [HCPCS_CPTModifierCode2]            CHAR (2)      NULL,
    [LLBilledAmount]                    DECIMAL (11)  NULL,
    [LLPaidAmount]                      DECIMAL (11)  NULL,
    [ServiceQuantity]                   DECIMAL (5)   NULL,
    [LLDateService]                     DATE          NULL,
    [LLPaidDate]                        DATE          NULL,
    [ServicingProviderSpecialtyCode]    VARCHAR (3)   NULL,
    [ServicingProviderSpecialtyDescrip] VARCHAR (75)  NULL,
    [Status]                            CHAR (1)      NULL,
    [ClmsEomLoadStatus]                 TINYINT       DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([InstitutionalClaimKey] ASC)
);

