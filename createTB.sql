CREATE TABLE [dbo].[leftUser](
    [lid] [int] NULL,                      ---id
    [wid] [varchar](3) NULL,        --工号   workid
    [workStatus] [bit] NULL,        --是否离职  leave or not
    [aduser] [nvarchar](5) NULL     --ad账号   AD accout
) ON [PRIMARY]
GO


