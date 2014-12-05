Create Table #Mutidata (  FIndex int IDENTITY,FEntryID INT, FBomInterid int, FItemID int null, FNeedQty decimal(28,14) default(0) null, FBOMLevel int null, FItemType 
int null, FParentID int default(0)null, FRate   decimal(28,14) default(0) null, FHistory int default(0) null, FHaveMrp smallint default(0) null, FLevelString 
varchar(200) null, FBom int, FMaterielType int  default(371) null,FOperSN Int NULL DEFAULT(0),FOperID int default(0),FRootBOMID int default(0)) 
 Create Table #MutiParentItem(  FIndex int IDENTITY,FEntryID INT default(0), FBomInterid int, FItemID int null, FNeedQty decimal(28,14) default(0) null, FBOMLevel int 
null, FItemType int null,  FParentID int default(0)null, FRate   decimal(28,14) default(0) null, FHistory int default(0) null, FHaveMrp smallint default(0) null, 
FLevelString varchar(200) null , FBom int, FMaterielType int  default(371) null,FOperSN Int NULL DEFAULT(0),FOperID int default(0),FRootBOMID int default(0)) 
 Create Table #Errors ( FIndex int IDENTITY, FType smallint default(0), FErrText nvarchar(355) )

--
Insert into #mutiParentItem (fbominterid,FItemID,FNeedQty,FBOMLevel,FParentID,FItemType,FBom,FRootBOMID) 
Select a.finterid, t1.FItemID,a.fqty, 0,0,(case t5.FID when 
'WG' then 0 when 'ZZ' then 1 when 'WWJG' then 1 else 2 end) FItemtype,t1.FItemID,a.finterid 
From icbom a
 inner join t_ICItem t1 on t1.FItemID = a.fitemid
 left join t_Submessage t5 on t1.FErpClsID = t5.FInterID 
-- where t5.FTypeID = 210 and  a.finterid in (2684,2738)

--
declare @p5 int
set @p5=0
declare @p6 nchar(400)
set 
@p6=N'                                                                                                                                                                                                                                                                                                                                                                                                                
'
exec PlanMutiBomExpand 50,1,'1900-01-01 00:00:00:000','2100-01-01 00:00:00:000',@p5 output,@p6 output
select @p5, @p6

--
select a.FBomInterid,a.FEntryID,a.FLevelString FLevel,d.FEntryKey, b.fnumber FNumber,b.fname FName,isnull(b.FModel,'') FModel, k.FName as FErpClsName,b.FChartNumber 
AS FChartNumber,isnull(c.Fname,'') FUnitID, a.FNeedQty FQty, a.FRate FQtyUnit, d.FScrap,d.FPositionNo,d.FItemSize,d.FItemSuite,d.FMachinePos,isnull(e.Fname,'') 
FMaterielType,(case d.FOperSN when 0 then '' else cast(d.FOperSN as varchar(255)) end) FOperSN,isnull(f.Fname,'') FOperID, isnull(g.FName,'') FStockID,(case 
b.FIsKeyItem when 0 then '·ñ' else 'ÊÇ' end) FIsKeyItem, (case h.FDeleted when 0 then '·ñ' else 'ÊÇ' end)  
FDeleted,d.FNote,d.FNote1,d.FNote2,d.FNote3,isnull(i.fname,'') FUseStatus,a.FitemID EditFitem, CASE WHEN (d.FBeginDay BETWEEN '1900-01-01' AND  '2100-01-01') THEN 0  
WHEN (d.FEndDay BETWEEN '1900-01-01' AND  '2100-01-01' ) THEN 0  WHEN ('1900-01-01' >= d.FBeginDay AND '2100-01-01' <= d.FEndDay) THEN 0 ELSE 1 END AS 
FAlterBackColor, '253, 223, 223' AS FBackColor,  d.FBeginDay,d.FEndDay,d.FPercent,b.FQtyDecimal FInitDecimal,b.FQtyDecimal FQtyDecimal,y.FName,y.FNumber,y.FModel,y.FHelpCode,z.FBomnumber 
from #Mutidata a
 inner join t_icitem b on a.fitemid=b.fitemid
 left outer join t_item c on b.funitid=c.fitemid
 inner join icbomchild d on a.FBomInterid=d.finterid and a.FItemID=d.FItemID and a.FOperID=d.FOperID AND a.FEntryID=d.FEntryID
 left outer join t_submessage e on d.FMaterielType=e.finterid
 left outer join t_submessage f on d.FOperID=f.finterid
 left outer join t_stock g on d.FStockID=g.FItemID
 inner join t_item h on b.fitemid=h.fitemid
 left outer join t_submessage i on b.fusestate=i.finterid
 inner join  t_submessage k on b.FErpClsID = k.FinterID
 inner join icbom z on a.FRootBOMID=z.FInterID
 inner join t_icitem y on z.FItemID=y.FItemID
 where a.FBOMLevel>0  
--and left(b.fnumber,6)='01.01.'
order by a.FRootBOMID,a.FIndex desc


--
DROP TABLE #Mutidata
DROP TABLE #mutiParentItem
DROP TABLE #Errors




select * from icbom where FBOMNumber='BOM001598'

select * from #mutiParentItem

select * from t_icitem where FItemID=6611

select *from #Mutidata order by FRootBOMID,FIndex desc


select * From icbom a
 inner join t_ICItem t1 on t1.FItemID = a.fitemid
 left join t_Submessage t5 on t1.FErpClsID = t5.FInterID 
 where t5.FTypeID = 210 and  a.finterid=2684
