CREATE TABLE [lst].[lstBenePlan] (
    [lstBenePlanKey]  INT           IDENTITY (1, 1) NOT NULL,
    [ClientKey]       INT           NOT NULL,
    [BenePlanName]    VARCHAR (100) NOT NULL,
    [BenePlanCode]    VARCHAR (15)  NOT NULL,
    [CreatedDate]     DATETIME2 (7) CONSTRAINT [DF_lstBenePlan_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  CONSTRAINT [DF_lstBenePlan_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) CONSTRAINT [DF_lstBenePlan_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  CONSTRAINT [DF_lstBenePlan_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([lstBenePlanKey] ASC)
);

