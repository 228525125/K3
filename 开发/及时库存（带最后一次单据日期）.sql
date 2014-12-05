--drop procedure list_jskc_zx

create procedure list_jskc_zx
@ckmc varchar(50)
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
Select t1.FNumber as FMaterialNumber,t1.FName as FMaterialName,t1.FModel as FMaterialModel,u1.FBatchNo,t2.FName as FStockName,t3.FName as FBUUnitName,ROUND(u1.FQty,t1.FQtydecimal) as FBUQty
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

select a.wldm,a.wlmc,a.wlgg,a.jldw,a.wlph,a.ckmc,sum(a.kcsl) as 'kcsl',max(b.FDate) as 'FDate' 
from #data a 
left join t_ICItem i on a.wldm=i.FNumber
left join (select FItemID,max(a.FDate) as FDate from ICStockBill a left join ICStockBillEntry b on b.FInterID=a.FInterID group by FItemID) b on i.FItemID=b.FItemID
where 1=1
and a.ckmc like @ckmc
group by a.wldm,a.wlmc,a.wlgg,a.jldw,a.ckmc,a.wlph
order by a.ckmc,a.wldm
end

exec list_jskc_zx '³ÉÆ·¿â'


