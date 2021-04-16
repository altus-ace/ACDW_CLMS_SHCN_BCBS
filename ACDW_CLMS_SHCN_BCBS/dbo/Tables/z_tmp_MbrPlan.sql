CREATE TABLE [dbo].[z_tmp_MbrPlan] (
    [URN]             INT           IDENTITY (1, 1) NOT NULL,
    [MbrLoadDate]     DATE          NULL,
    [MbrKey]          INT           NULL,
    [PatientID]       VARCHAR (50)  NULL,
    [AttribNPI]       VARCHAR (50)  NULL,
    [PlanKey]         INT           NULL,
    [PlanCode]        VARCHAR (50)  NULL,
    [MbrPlanMatchFlg] INT           NULL,
    [Note]            VARCHAR (50)  NULL,
    [RecParameters]   VARCHAR (500) DEFAULT ('[DataDate]||[adi].[Steward_BCBS_Membership]||[adi].[Steward_BCBS_MemberCrosswalk]||ON		a.ClientMemberKey = b.PatientID ') NULL,
    [CreateDate]      DATE          DEFAULT (sysdatetime()) NULL,
    [CreateBy]        VARCHAR (50)  DEFAULT (suser_sname()) NULL
);

