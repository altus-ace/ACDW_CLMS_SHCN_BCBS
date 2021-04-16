CREATE TABLE [lst].[lstZipCodes] (
    [Pod]         VARCHAR (15)   NOT NULL,
    [ZipCode]     VARCHAR (20)   NOT NULL,
    [Quadrant]    VARCHAR (50)   NULL,
    [AvgEst]      NUMERIC (4, 2) NULL,
    [Latitude]    NUMERIC (6, 4) NULL,
    [Longitude]   NUMERIC (6, 4) NULL,
    [CreatedDate] DATETIME       CONSTRAINT [DF_lstZipCode_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   VARCHAR (50)   CONSTRAINT [DF_lstZipCode_CreatedBY] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Pod] ASC, [ZipCode] ASC)
);

