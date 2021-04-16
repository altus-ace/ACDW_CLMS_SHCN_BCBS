CREATE TABLE [dbo].[z_tmp_LoadDates] (
    [URN]        INT           IDENTITY (1, 1) NOT NULL,
    [LoadDate]   DATE          NULL,
    [RecStatus]  VARCHAR (1)   DEFAULT ('N') NULL,
    [Note]       VARCHAR (50)  NULL,
    [Parameters] VARCHAR (500) DEFAULT ('[DataDate]||[adi].[Steward_BCBS_Membership]||[adi].[Steward_BCBS_MemberCrosswalk]||ON		a.ClientMemberKey = b.PatientID ') NULL,
    [CreateDate] DATE          DEFAULT (sysdatetime()) NULL,
    [CreateBy]   VARCHAR (50)  DEFAULT (suser_sname()) NULL
);

