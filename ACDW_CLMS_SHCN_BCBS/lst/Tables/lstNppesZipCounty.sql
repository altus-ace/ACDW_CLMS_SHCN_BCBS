CREATE TABLE [lst].[lstNppesZipCounty] (
    [ZipCode]     VARCHAR (15)  NOT NULL,
    [County]      VARCHAR (65)  NOT NULL,
    [City]        VARCHAR (65)  NULL,
    [State]       VARCHAR (25)  NULL,
    [SrcFileName] VARCHAR (100) NULL,
    [FileDate]    DATE          NULL,
    [CreateDate]  DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]    VARCHAR (100) DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([ZipCode] ASC, [County] ASC)
);

