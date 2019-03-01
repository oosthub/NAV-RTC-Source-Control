/*
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SourceControlMonitor]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SourceControlMonitor]
GO

CREATE TABLE [dbo].[SourceControlMonitor] (
	[NavisionAuditID] [int] IDENTITY (1, 1) NOT NULL ,
	[Changed] [datetime] NOT NULL ,
	[User_ID] [nvarchar] (50) NOT NULL ,
	[ObjectType] [int] NOT NULL ,
	[ObjectID] [int] NOT NULL ,
	[ObjectName] [nvarchar] (30) NOT NULL ,
	[DatabaseName] [nvarchar] (10) NOT NULL ,
	[ChangeType] [nchar] (3) NOT NULL ,
	[VersionList] [nvarchar] (80) NULL ,
	[CompanyName] [nvarchar] (30) NULL 
) ON [PRIMARY]
GO
*/


GRANT ALL ON [dbo].[SourceControlMonitor] TO PUBLIC

GO

ALTER TABLE [dbo].[SourceControlMonitor] ADD 
	CONSTRAINT [DF_NavisionAudit_Changed] DEFAULT (getdate()) FOR [Changed]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[upd_Object]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[upd_Object]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[new_Object]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[new_Object]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[del_Object]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[del_Object]
GO



CREATE TRIGGER [upd_Object] ON [dbo].[Object] 
FOR  UPDATE
AS
    SET NOCOUNT ON

	INSERT INTO [SourceControlMonitor] 
		([User_ID],[ObjectType],[ObjectID] ,[ObjectName],[DatabaseName],[ChangeType],[VersionList],[CompanyName])

	SELECT SYSTEM_USER,[Type],[ID],[Name],DB_NAME(),'MOD',[Version List],[Company Name]
		FROM [inserted] where [BLOB Size] > 0

GO

CREATE TRIGGER [new_Object] ON [dbo].[Object] 
FOR INSERT 
AS

    SET NOCOUNT ON

	INSERT INTO [SourceControlMonitor] 
		([User_ID],[ObjectType],[ObjectID] ,[ObjectName],[DatabaseName],[ChangeType],[VersionList],[CompanyName])

	SELECT SYSTEM_USER,[Type],[ID],[Name],DB_NAME(),'ADD',[Version List],[Company Name]
		FROM [inserted] where [BLOB Size] > 0

GO

CREATE TRIGGER [del_Object] ON [dbo].[Object] 
FOR DELETE 
AS

    SET NOCOUNT ON

	INSERT INTO [SourceControlMonitor] 
		([User_ID],[ObjectType],[ObjectID] ,[ObjectName],[DatabaseName],[ChangeType],[VersionList],[CompanyName])

	SELECT SYSTEM_USER,[Type],[ID],[Name],DB_NAME(),'DEL',[Version List],[Company Name]
		FROM [Deleted] where [BLOB Size] > 0


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

