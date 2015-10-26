--及时库存（带炉号、标准）
--drop procedure list_jskc_lhbz drop procedure list_jskc_lhbz_count

create procedure list_jskc_lhbz
@query varchar(50)
as
begin
Set Nocount on
Create Table #Data(
wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,wlph nvarchar(255) default('')
,ckmc nvarchar(255) default('')
,jldw nvarchar(20) default('')
,kcsl decimal(28,4) default(0)
)

Create Table #TempInventory( 
                            [FBrNo] [varchar] (10)  NOT NULL ,
                            [FItemID] [int] NOT NULL ,
                            [FBatchNo] [varchar] (200)  NOT NULL ,
                            [FMTONo] [varchar] (200)  NOT NULL ,
                            [FStockID] [int] NOT NULL ,
                            [FQty] [decimal](28, 10) NOT NULL ,
                            [FBal] [decimal](20, 2) NOT NULL ,
                            [FStockPlaceID] [int] NULL ,
                            [FKFPeriod] [int] NOT NULL Default(0),
                            [FKFDate] [varchar] (255)  NOT NULL ,
                            [FMyKFDate] [varchar] (255), 
                            [FStockTypeID] [Int] NOT NULL,
                            [FQtyLock] [decimal](28, 10) NOT NULL,
                            [FAuxPropID] [int] NOT NULL,
                            [FSecQty] [decimal](28, 10) NOT NULL
                             )
Insert Into #TempInventory Select u1.FBrNo,u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FStockID,u1.FQty,u1.FBal,u1.FStockPlaceID,
u1.FKFPeriod,ISNULL(u1.FKFDate,''),ISNULL(u1.FKFDate,''),500,u1.FQtyLock,u1.FAuxPropID,u1.FSecQty From ICInventory u1 where u1.FQty<>0 

Insert Into #TempInventory Select u1.FBrNo,u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FStockID,u1.FQty,u1.FBal,u1.FStockPlaceID,
u1.FKFPeriod,ISNULL(u1.FKFDate,''),ISNULL(u1.FKFDate,''),u1.FStockTypeID,0,u1.FAuxPropID,u1.FSecQty From POInventory u1 where u1.FQty<>0 

Insert Into #Data(wldm,wlmc,wlgg,wlph,ckmc,jldw,kcsl
)
Select t1.FNumber AS FMaterialNumber,t1.FName as FMaterialName,t1.FModel as FMaterialModel,u1.FBatchNo,t2.FName as FStockName,t3.FName as FBUUnitName,ROUND(u1.FQty,t1.FQtydecimal) as FBUQty
From #TempInventory u1
 left join t_ICItem t1 on u1.FItemID = t1.FItemID
left join t_Stock t2 on u1.FStockID=t2.FItemID
left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR 
Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
 and t1.FDeleted=0 
 AND t2.FTypeID in (500,20291,20293)

Order By t1.FNumber,u1.FBatchNo,u1.FMTONo 

Select a.*,case when b.lh is null or b.lh = '' then c.lh else b.lh end as lh,b.bz from #Data a
LEFT JOIN(select b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0  group by b.FBatchNo) b on a.wlph=b.ph
LEFT JOIN(select ph,max(lh) as lh from rss.dbo.pclh where ph is not null group by ph) c on a.wlph=c.ph
WHERE 1=1
AND (a.wldm like '%'+@query+'%' or a.wlmc like '%'+@query+'%' or a.wlgg like '%'+@query+'%' or a.wlph like '%'+@query+'%' or b.lh like '%'+@query+'%' or b.bz like '%'+@query+'%' or c.lh like '%'+@query+'%')
end

execute list_jskc_lhbz 'PH'

--count--
create procedure list_jskc_lhbz_count
@query varchar(50)
as
begin
Set Nocount on
Create Table #Data(
wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,wlph nvarchar(255) default('')
,ckmc nvarchar(255) default('')
,jldw nvarchar(20) default('')
,kcsl decimal(28,4) default(0)
)

Create Table #TempInventory( 
                            [FBrNo] [varchar] (10)  NOT NULL ,
                            [FItemID] [int] NOT NULL ,
                            [FBatchNo] [varchar] (200)  NOT NULL ,
                            [FMTONo] [varchar] (200)  NOT NULL ,
                            [FStockID] [int] NOT NULL ,
                            [FQty] [decimal](28, 10) NOT NULL ,
                            [FBal] [decimal](20, 2) NOT NULL ,
                            [FStockPlaceID] [int] NULL ,
                            [FKFPeriod] [int] NOT NULL Default(0),
                            [FKFDate] [varchar] (255)  NOT NULL ,
                            [FMyKFDate] [varchar] (255), 
                            [FStockTypeID] [Int] NOT NULL,
                            [FQtyLock] [decimal](28, 10) NOT NULL,
                            [FAuxPropID] [int] NOT NULL,
                            [FSecQty] [decimal](28, 10) NOT NULL
                             )
Insert Into #TempInventory Select u1.FBrNo,u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FStockID,u1.FQty,u1.FBal,u1.FStockPlaceID,
u1.FKFPeriod,ISNULL(u1.FKFDate,''),ISNULL(u1.FKFDate,''),500,u1.FQtyLock,u1.FAuxPropID,u1.FSecQty From ICInventory u1 where u1.FQty<>0 

Insert Into #TempInventory Select u1.FBrNo,u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FStockID,u1.FQty,u1.FBal,u1.FStockPlaceID,
u1.FKFPeriod,ISNULL(u1.FKFDate,''),ISNULL(u1.FKFDate,''),u1.FStockTypeID,0,u1.FAuxPropID,u1.FSecQty From POInventory u1 where u1.FQty<>0 

Insert Into #Data(wldm,wlmc,wlgg,wlph,ckmc,jldw,kcsl
)
Select t1.FNumber AS FMaterialNumber,t1.FName as FMaterialName,t1.FModel as FMaterialModel,u1.FBatchNo,t2.FName as FStockName,t3.FName as FBUUnitName,ROUND(u1.FQty,t1.FQtydecimal) as FBUQty
From #TempInventory u1
 left join t_ICItem t1 on u1.FItemID = t1.FItemID
left join t_Stock t2 on u1.FStockID=t2.FItemID
left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR 
Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
 and t1.FDeleted=0 
 AND t2.FTypeID in (500,20291,20293)

Order By t1.FNumber,u1.FBatchNo,u1.FMTONo 

Select count(1) from #Data a
LEFT JOIN(select b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0  group by b.FBatchNo) b on a.wlph=b.ph
LEFT JOIN(select ph,max(lh) as lh from rss.dbo.pclh where ph is not null group by ph) c on a.wlph=c.ph
WHERE 1=1
AND (a.wldm like '%'+@query+'%' or a.wlmc like '%'+@query+'%' or a.wlgg like '%'+@query+'%' or a.wlph like '%'+@query+'%' or b.lh like '%'+@query+'%' or b.bz like '%'+@query+'%' or c.lh like '%'+@query+'%')

end

exec list_jskc_lhbz '7444'


exec list_jskc_lhbz_count '3Y836'

select c.FNumber,b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID 
where a.FTranType=702 and a.FCancellation = 0 
AND b.FBatchNo='13H20'
group by c.FNumber,b.FBatchNo

select c.FNumber,b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID 
where a.FTranType=702 and a.FCancellation = 0 
AND c.FNumber = '05.04.0119'
group by c.FNumber,b.FBatchNo





select * from t_ICItem where 







select * from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where v1.FBillNo='IQCR001127'

select c.FNumber,b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0 and  group by c.FNumber,b.FBatchNo

select * from t_ICItem where FNumber='05.08.3014'



exec list_jskc_lhbz 'D0114PB'
exec list_jskc_lhbz 'F9270HE'
exec list_jskc_lhbz'F9340SA'
exec list_jskc_lhbz'F9340SC'
exec list_jskc_lhbz'F9200CS'
exec list_jskc_lhbz'F9340SB'
exec list_jskc_lhbz'F9340SD'
exec list_jskc_lhbz'D0114RZ'
exec list_jskc_lhbz'F9149CW'
exec list_jskc_lhbz'F9275ED'
--exec list_jskc_lhbz'F9275EF'
--exec list_jskc_lhbz'F9275EG'
exec list_jskc_lhbz'G9612EB'
exec list_jskc_lhbz'F9340NE'
exec list_jskc_lhbz'F9347UV'
exec list_jskc_lhbz'F9342MH'
exec list_jskc_lhbz'F9270BK'
exec list_jskc_lhbz'D0114RB'
exec list_jskc_lhbz'F9900SH'


exec list_jskc_lhbz 'F9340UE'
exec list_jskc_lhbz'F9340UH'
exec list_jskc_lhbz'F9340UJ'
exec list_jskc_lhbz'M2801LE'
exec list_jskc_lhbz'F9340VG'
exec list_jskc_lhbz'F9340VH'
exec list_jskc_lhbz'F9385ZB'
exec list_jskc_lhbz'F9385ZD'
exec list_jskc_lhbz'F9385ZF'
exec list_jskc_lhbz'CV1G-'
exec list_jskc_lhbz'CV2P-316/304'
exec list_jskc_lhbz'CV3P-316/304'
exec list_jskc_lhbz'CV5P-316/304'



select * from t_stock


