--DROP TRIGGER IC_ITEM 
--��K3�������ϴ���ʱ����ͼ�ţ���д��ͼ�Ų�ѯϵͳ
CREATE TRIGGER IC_ITEM ON t_ICItemBase    
After INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)
BEGIN
DECLARE @FItemID int
DECLARE @FHelpCode nvarchar(255) 
DECLARE @FName nvarchar(255) 
DECLARE @FModel nvarchar(255) 
DECLARE @FAlias nvarchar(255)
DECLARE @FFullName nvarchar(255)
DECLARE @FNumber nvarchar(255)
DECLARE @FParentID nvarchar(255)
SELECT @FItemID=FItemID,@FAlias=FAlias,@FFullName=FFullName FROM inserted
SELECT @FHelpCode=FHelpCode,@FName=FName,@FModel=FModel,@FNumber=FNumber,@FParentID=FParentID FROM t_ICItemCore where FItemID=@FItemID

/* k3�Դ��˹��� */
/*IF @FHelpCode is not null and @FHelpCode <> ''
IF EXISTS(select * from t_ICItemCore where @FNumber<>FNumber and @FHelpCode=FHelpCode)
	exec('ͼ���ظ����ܱ���')*/

IF @FHelpCode is not null and @FHelpCode <> ''
IF NOT EXISTS(select 1 from rss.dbo.thcx where gsth=@FHelpCode)
	insert rss.dbo.thcx (gsth,cpmc,khth,cpcz,sslb,rq,lc,ip) values (@FHelpCode,@FName,@FModel,@FAlias,@FFullName,convert(char(10),getDate(),120),null,'�Զ�����')

IF @FHelpCode is not null and @FHelpCode <> ''
IF EXISTS(select 1 from rss.dbo.thcx where gsth=@FHelpCode and (cpmc<>@FName or khth<>@FModel or cpcz<>@FAlias or sslb<>@FFullName))
	update rss.dbo.thcx set cpmc=@FName, khth=@FModel, cpcz=@FAlias, sslb=@FFullName where gsth=@FHelpCode

IF EXISTS(select 1 from t_ICItem a where not exists(select 1 from emr.dbo.Department b where a.FNumber=b.code))
Insert Into emr.dbo.Department (id,code,name,auxCode,model,tuhao,disabled,description,level,grade,date,parentId,organizationId)
	select a.FItemID,a.FNumber,a.FName,'',a.FModel,a.FHelpCode,0,'',null,4,getDate(),a.FParentID,1 from t_ICItem a left join emr.dbo.Department b on a.FNumber=b.code where b.code is null        --k3���ļ�����ͬ��

UPDATE a SET a.tuhao=b.FHelpCode from emr.dbo.Department a left join  t_ICItem b on a.code=b.FNumber where a.tuhao<>b.FHelpCode        --���k3�޸���ͼ�ţ��ļ�����ҲҪ�޸�

END 

select FParentID,* FROM t_ICItemCore where FItemID=

/* �������������Ϻ��Զ��Ѱ�ȫ��桢��С��������߿�桢�ɹ����ڸ�Ϊ0*/  
--UPDATE t_ICItem SET FQtyMin=0,FSecInv=0,FHighLimit=0,FFixLeadTime=0 WHERE FItemID=@FItemID

--DROP TRIGGER IC_ITEMBASE
/* �޸ĺ͸��ơ����� ���ᴥ��INSERT������ */
CREATE TRIGGER IC_ITEMBASE ON t_ICItemBase
After INSERT
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)
BEGIN
DECLARE @FItemID int
SELECT @FItemID=FItemID FROM inserted
UPDATE t_ICItemBase SET FSecInv=0,FHighLimit=0 WHERE FItemID=@FItemID
--UPDATE t_ICItem SET FQtyMin=0,FSecInv=0,FHighLimit=0,FFixLeadTime=0 WHERE FItemID=@FItemID
--UPDATE t_ICItemPlan SET FQtyMin=0,FFixLeadTime=0 WHERE FItemID=@FItemID
END


--DROP TRIGGER IC_ITEMPLAN
CREATE TRIGGER IC_ITEMPLAN ON t_ICItemPlan
After INSERT
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)
BEGIN
DECLARE @FItemID int
SELECT @FItemID=FItemID FROM inserted
UPDATE t_ICItemPlan SET FQtyMin=0,FFixLeadTime=0 WHERE FItemID=@FItemID

END


select FQtyMiN,FSecInv,FHighLimit,FFixLeadTime,* from t_ICItem where FNumber='01.01.01.018'


insert rss.dbo.thcx (gsth,cpmc,khth,cpcz,sslb,rq,lc,ip) values ('123123','111','111','111','111',convert(char(10),getDate(),120),null,null)

select * from rss.dbo.thcx where rq='2014-06-30'

delete rss.dbo.thcx where gsth='111222'


select top 10 * from t_ICItemCore

select * from emr.dbo.Department where code='05.07.0502'

select a.tuhao,b.FHelpCode from emr.dbo.Department a left join  t_ICItem b on a.code=b.FNumber where a.tuhao<>b.FHelpCode

--update a set a.tuhao=b.FHelpCode from emr.dbo.Department a left join  t_ICItem b on a.code=b.FNumber where a.tuhao<>b.FHelpCode

select 1 from t_ICItem a where not exists(select 1 from emr.dbo.Department b where a.FNumber=b.code)

IF EXISTS(select 1 from t_ICItem a where not exists(select 1 from emr.dbo.Department b where a.FNumber=b.code))
Insert Into emr.dbo.Department (id,code,name,auxCode,model,tuhao,disabled,description,level,grade,date,parentId,organizationId)
	select a.FItemID,a.FNumber,a.FName,'',a.FModel,a.FHelpCode,0,'',null,4,getDate(),a.FParentID,1 from t_ICItem a left join emr.dbo.Department b on a.FNumber=b.code where b.code is null


@FNumber,@FName,'',@FModel,@FHelpCode,0,'',null,getDate(),1,@FParentID,4

IF NOT EXISTS(select 1 from emr.dbo.Department where code='05.07.0502')
	insert emr.dbo.Department (code,name,auxCode,model,tuhao,disabled,description,level,date,organizationId,parentID,grade) values (@FNumber,@FName,'',@FModel,@FHelpCode,0,'',null,getDate(),1,@FParentID,4)

/*IF NOT EXISTS(select 1 from emr.dbo.Department where code=@FNumber)
	insert emr.dbo.Department (code,name,auxCode,model,tuhao,disabled,description,level,date,organizationId,parentID,grade) values (@FNumber,@FName,'',@FModel,@FHelpCode,0,'',null,getDate(),1,@FParentID,4)    --k3���ļ�����ͬ��*/

