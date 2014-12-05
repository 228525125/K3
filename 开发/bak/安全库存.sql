--drop procedure list_aqkc drop procedure list_aqkc_count

create procedure list_aqkc 
@query varchar(100),
@month int,
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
wldm nvarchar(20) default('')          
,wlmc nvarchar(100) default('')          
,wlgg nvarchar(100) default('')
,cpth nvarchar(100) default('')
,jldw nvarchar(20) default('')
,cklj decimal(28,0) default(0)
,yckl decimal(28,0) default(0)
,aqkc decimal(28,2) default(0)          
,zgkc decimal(28,2) default(0)
,zxdhl decimal(28,2) default(0)
,rxhl decimal(28,2) default(0)
,cgzq decimal(28,0) default(0)
,hsdj decimal(28,2) default(0)
,aqkcje decimal(28,2) default(0)
,zgkcje decimal(28,2) default(0)
,jcsl decimal(28,2) default(0)
,mx decimal(28,2) default(0)       --单月最高消耗量
,ztsl decimal(28,2) default(0)     --在途数量
)

create table #Data(
wldm nvarchar(20) default('')          
,wlmc nvarchar(100) default('')          
,wlgg nvarchar(100) default('')
,cpth nvarchar(100) default('')
,jldw nvarchar(20) default('')
,cklj decimal(28,0) default(0)
,yckl decimal(28,0) default(0)
,aqkc decimal(28,2) default(0)          
,zgkc decimal(28,2) default(0)
,zxdhl decimal(28,2) default(0)
,rxhl decimal(28,2) default(0)
,cgzq decimal(28,0) default(0)
,hsdj decimal(28,2) default(0)
,aqkcje decimal(28,2) default(0)
,zgkcje decimal(28,2) default(0)
,jcsl decimal(28,2) default(0)
,mx decimal(28,2) default(0)
,ztsl decimal(28,2) default(0)
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

create table #tt(
FItemID nvarchar(20) default('')          
,FNumber nvarchar(100) default('')          
,djyf nvarchar(100) default('')
,fssl decimal(28,0) default(0)
)

Insert Into  #tt(FItemID,FNumber,djyf,fssl)
select b.FItemID,c.FNumber,LEFT(CONVERT(varchar(100), FDate, 12),4) as 'djyf',sum(FQty) as 'fssl'
from ICStockBill a 
left join ICStockBillEntry b on a.FInterID=b.FInterID 
left join t_ICItem c on b.FItemID=c.FItemID 
where datediff(day,FDate,getdate())<(12*30) and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') 
group by b.FItemID,FNumber,LEFT(CONVERT(varchar(100), FDate, 12),4) 
order by FNumber 

Insert Into #temp(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl
)
select a.FNumber as 'wldm',a.FName as 'wlmc',a.FModel as 'wlgg',
a.FHelpCode as 'cpth',m.FName as 'jldw',f.FQty as 'cklj',f.FQty/@month as 'yckl',b.FSecInv as 'aqkc',b.FHighLimit as 'zgkc',
d.FQtyMin as 'zxdhl',d.FDailyConsume as 'rxhl',d.FFixLeadTime as 'cgzq',isnull(g.FTaxPrice,0) as 'hsdj',isnull(g.FTaxPrice,0)*b.FSecInv as 'aqkcje',isnull(g.FTaxPrice,0)*b.FHighLimit as 'zgkcje',
isnull(h.FBUQty,0) as 'jcsl',j.mx as 'mx',isnull(k.FQty,0) as 'ztsl'
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID
left join t_ICItemQuality e on a.FItemID=e.FItemID
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID
left join (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where datediff(day,FDate,getdate())<(@month*30) and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') group by FItemID) f on a.FItemID=f.FItemID
left join (select c.FNumber as FNumber,AVG(FTaxPrice) as FTaxPrice from ICPurchase a left join ICPurchaseEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FDate>='2010-05-01' and left(c.FNumber,2)<>'05' and left(c.FNumber,2)<>'06' group by c.FNumber) g on a.FNumber=g.FNumber
left join (select FItemID,max(fssl) as 'mx' from #tt group by FItemID) j on a.FItemID=j.FItemID
left join (
Select SUM(ROUND(u1.FQty,t1.FQtydecimal)) as FBUQty,t1.FNumber AS FLongNumber 
From #TempInventory u1
left join t_ICItem t1 on u1.FItemID = t1.FItemID
left join t_Stock t2 on u1.FStockID=t2.FItemID
left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR 
Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
and t1.FDeleted=0 

-- AND t2.FItemID=340
AND t2.FTypeID in (500,20291,20293)
group by t1.FNumber
) h on a.FNumber=h.FLongNumber
left join (
select b.FItemID,case when (b.FCommitQty-isnull(d.FStockQty,0))<0 then 0 else b.FCommitQty-isnull(d.FStockQty,0) end as FQty 
from POrequest a left join POrequestEntry b on a.FInterID=b.FInterID and a.FInterID<>0 
left join t_ICItem c on b.FItemID=c.FItemID and c.FItemID<>0
left join (select SUM(a.FAuxStockQty) as FStockQty,a.FSourceBillNo,b.FItemID from vwICBill_26 a left join POOrderEntry b on a.FInterID=b.FInterID and a.FEntryID=b.FEntryID group by a.FSourceBillNo,b.FItemID) d on a.FBillNo=d.FSourceBillNo and b.FItemID=d.FItemID
where 1=1 
AND a.FCancellation=0 and a.FStatus=3
) k on a.FItemID=k.FItemID
where 1=1 
and b.FSecInv<>0             --安全库存不为空
--and left(a.FNumber,5) = '02.02'
and (a.FNumber like '%'+@query+'%' or a.FName like '%'+@query+'%' or a.FModel like '%'+@query+'%' or a.FHelpCode like '%'+@query+'%')
order by a.FNumber

if @orderby='null'
exec('Insert Into #Data(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl)select * from #temp')
else
exec('Insert Into #Data(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(wldm,aqkcje,zgkcje)
Select '合计',sum(isnull(g.FTaxPrice,0)*b.FSecInv) as 'aqkcje',sum(isnull(g.FTaxPrice,0)*b.FHighLimit) as 'zgkcje'
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID 
left join t_ICItemQuality e on a.FItemID=e.FItemID 
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID 
left join (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where datediff(day,FDate,getdate())<(@month*30) and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') group by FItemID) f on a.FItemID=f.FItemID
left join (select c.FNumber as FNumber,AVG(FTaxPrice) as FTaxPrice from ICPurchase a left join ICPurchaseEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FDate>='2010-05-01' and left(c.FNumber,2)<>'05' and left(c.FNumber,2)<>'06' group by c.FNumber) g on a.FNumber=g.FNumber
where 1=1 
and b.FSecInv<>0             --安全库存不为空
--and left(a.FNumber,5) = '02.02'      
and (a.FNumber like '%'+@query+'%' or a.FName like '%'+@query+'%' or a.FModel like '%'+@query+'%' or a.FHelpCode like '%'+@query+'%')
select * from #Data 
Drop Table #TempInventory
end

---count----

create procedure list_aqkc_count 
@query varchar(100),
@month int,
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
wldm nvarchar(20) default('')          
,wlmc nvarchar(100) default('')          
,wlgg nvarchar(100) default('')
,cpth nvarchar(100) default('')
,jldw nvarchar(20) default('')
,cklj decimal(28,0) default(0)
,yckl decimal(28,0) default(0)
,aqkc decimal(28,2) default(0)          
,zgkc decimal(28,2) default(0)
,zxdhl decimal(28,2) default(0)
,rxhl decimal(28,2) default(0)
,cgzq decimal(28,0) default(0)
,hsdj decimal(28,2) default(0)
,aqkcje decimal(28,2) default(0)
,zgkcje decimal(28,2) default(0)
,jcsl decimal(28,2) default(0)
)

create table #Data(
wldm nvarchar(20) default('')          
,wlmc nvarchar(100) default('')          
,wlgg nvarchar(100) default('')
,cpth nvarchar(100) default('')
,jldw nvarchar(20) default('')
,cklj decimal(28,0) default(0)
,yckl decimal(28,0) default(0)
,aqkc decimal(28,2) default(0)          
,zgkc decimal(28,2) default(0)
,zxdhl decimal(28,2) default(0)
,rxhl decimal(28,2) default(0)
,cgzq decimal(28,0) default(0)
,hsdj decimal(28,2) default(0)
,aqkcje decimal(28,2) default(0)
,zgkcje decimal(28,2) default(0)
,jcsl decimal(28,2) default(0)
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


Insert Into #temp(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl
)
select a.FNumber as 'wldm',a.FName as 'wlmc',a.FModel as 'wlgg',
a.FHelpCode as 'cpth',m.FName as 'jldw',f.FQty as 'cklj',f.FQty/@month as 'yckl',b.FSecInv as 'aqkc',b.FHighLimit as 'zgkc',
d.FQtyMin as 'zxdhl',d.FDailyConsume as 'rxhl',d.FFixLeadTime as 'cgzq',isnull(g.FTaxPrice,0) as 'hsdj',isnull(g.FTaxPrice,0)*b.FSecInv as 'aqkcje',isnull(g.FTaxPrice,0)*b.FHighLimit as 'zgkcje',
h.FBUQty as 'jcsl'
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID
left join t_ICItemQuality e on a.FItemID=e.FItemID
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID
left join (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where datediff(day,FDate,getdate())<(@month*30) and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') group by FItemID) f on a.FItemID=f.FItemID
left join (select c.FNumber as FNumber,AVG(FTaxPrice) as FTaxPrice from ICPurchase a left join ICPurchaseEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID group by c.FNumber) g on a.FNumber=g.FNumber
left join (
Select SUM(ROUND(u1.FQty,t1.FQtydecimal)) as FBUQty,t1.FNumber AS FLongNumber 
From #TempInventory u1
left join t_ICItem t1 on u1.FItemID = t1.FItemID
left join t_Stock t2 on u1.FStockID=t2.FItemID
left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR 
Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
and t1.FDeleted=0 

-- AND t2.FItemID=340
AND t2.FTypeID in (500,20291,20293)
group by t1.FNumber
) h on a.FNumber=h.FLongNumber
where 1=1 
and b.FSecInv<>0             --安全库存不为空
and (a.FNumber like '%'+@query+'%' or a.FName like '%'+@query+'%' or a.FModel like '%'+@query+'%' or a.FHelpCode like '%'+@query+'%')
order by a.FNumber

if @orderby='null'
exec('Insert Into #Data(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl)select * from #temp')
else
exec('Insert Into #Data(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(wldm,aqkcje,zgkcje)
Select '合计',sum(isnull(g.FTaxPrice,0)*b.FSecInv) as 'aqkcje',sum(isnull(g.FTaxPrice,0)*b.FHighLimit) as 'zgkcje'
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID
left join t_ICItemQuality e on a.FItemID=e.FItemID
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID
left join (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where datediff(day,FDate,getdate())<(@month*30) and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') group by FItemID) f on a.FItemID=f.FItemID
left join (select c.FNumber as FNumber,AVG(FTaxPrice) as FTaxPrice from ICPurchase a left join ICPurchaseEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID group by c.FNumber) g on a.FNumber=g.FNumber
where 1=1 
and b.FSecInv<>0             --安全库存不为空
and (a.FNumber like '%'+@query+'%' or a.FName like '%'+@query+'%' or a.FModel like '%'+@query+'%' or a.FHelpCode like '%'+@query+'%')
select count(*) from #Data 
Drop Table #TempInventory
end



execute list_aqkc '','12','null','null'

execute list_aqkc_count '','null','null'

execute list_aqkc_count '','12','null','null'



select datediff(day,'2011-09-01',getdate())



select FBillNo,c.FNumber as FNumber,FTaxPrice/*AVG(FTaxPrice)*/ as FTaxPrice from ICPurchase a left join ICPurchaseEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where c.FNumber='02.01.0376' --group by c.FNumber



select * from ICPurchase



select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where datediff(day,FDate,getdate())<(12*30) and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') group by FItemID





SET NOCOUNT ON 
create table #tt(
FItemID nvarchar(20) default('')          
,FNumber nvarchar(100) default('')          
,djyf nvarchar(100) default('')
,fssl decimal(28,0) default(0)
)

Insert Into  #tt(FItemID,FNumber,djyf,fssl)
select b.FItemID,c.FNumber,LEFT(CONVERT(varchar(100), FDate, 12),4) as 'djyf',sum(FQty) as 'fssl'
from ICStockBill a 
left join ICStockBillEntry b on a.FInterID=b.FInterID 
left join t_ICItem c on b.FItemID=c.FItemID 
where datediff(day,FDate,getdate())<(12*30) and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') 
group by b.FItemID,FNumber,LEFT(CONVERT(varchar(100), FDate, 12),4) 
order by FNumber 

select FNumber,max(fssl) from #tt group by FNumber order by FNumber



