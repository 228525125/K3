--drop procedure list_jskc

create procedure list_jskc 
as 
begin
SET NOCOUNT ON 
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

create table #temp(
wldm nvarchar(20) default('')          
,wlmc nvarchar(100) default('')          
,wlgg nvarchar(100) default('')
,wlph nvarchar(100) default('')
,jldw nvarchar(20) default('')
,kcsl decimal(28,2) default(0)
,cfck nvarchar(20) default('')
)

Insert Into #temp(wldm,wlmc,wlgg,wlph,jldw,kcsl,cfck
)
Select t1.FNumber AS FMaterialNumber,t1.FName as FMaterialName,t1.FModel 
as FMaterialModel,u1.FBatchNo ,t3.FNumber as FBUUnitNumber,ROUND(u1.FQty,t1.FQtydecimal) as FBUQty,t2.FName as FStockName
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
and t2.FItemID <> '4527'             --∑œ∆∑£®π§∑œ£©ø‚
and t2.FItemID <> '4528'             --ø…¿˚”√ø‚
and t2.FItemID <> '4739'             --∑µπ§∑µ–ﬁø‚
and t2.FItemID <> '5272'             --¡œ∑œø‚
and t2.FItemID <> '5888'             --∑‚¥Êø‚
and left(t1.FNumber,2) in ('02','05','07','06')
 Order By t1.FNumber,u1.FBatchNo,u1.FMTONo 

select a.FNumber,a.FName,a.FModel,a.FHelpCode,b.wlph,c.FName as FUName,b.kcsl,d.FSecInv,cfck 
from t_ICItem a 
left join #temp b on a.FNumber=b.wldm
left join t_MeasureUnit c on a.FUnitID=c.FMeasureUnitID
left join t_ICItemBase d on a.FItemID=d.FItemID 
where a.FDeleted=0
and a.FModel like '%PS'
order by a.FNumber
end

exec list_jskc