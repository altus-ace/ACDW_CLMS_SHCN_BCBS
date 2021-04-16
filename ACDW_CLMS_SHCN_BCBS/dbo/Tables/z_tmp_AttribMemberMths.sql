CREATE TABLE [dbo].[z_tmp_AttribMemberMths] (
    [URN]             INT          IDENTITY (1, 1) NOT NULL,
    [ClientKey]       INT          NULL,
    [ClientMemberKey] VARCHAR (50) NULL,
    [AttribNPI]       VARCHAR (15) NULL,
    [EffectiveDate]   DATE         NULL,
    [CreateDate]      DATE         DEFAULT (getdate()) NULL,
    [CreateBy]        VARCHAR (50) DEFAULT (suser_sname()) NULL
);

