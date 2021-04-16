CREATE TABLE [lst].[lstClinicalPrograms] (
    [lstAhsProgramsKey]  INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]        VARCHAR (100) NOT NULL,
    [DataDate]           DATE          DEFAULT (getdate()) NOT NULL,
    [CreatedDate]        DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]    DATETIME      DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]      VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [EffectiveDate]      DATE          NOT NULL,
    [ExpirationDate]     DATE          NOT NULL,
    [ProgramName]        VARCHAR (50)  NOT NULL,
    [ProgramDescription] VARCHAR (250) NOT NULL,
    [ProgramDesc_Short]  VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([lstAhsProgramsKey] ASC)
);

