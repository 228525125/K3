--销售订单维护，未投料部分，缺陷：同一张订单，同一个品种存在多行记录
--drop procedure portal_list_xsdd 

create procedure portal_list_xsdd 
@query varchar(100),
@begindate varchar(10),
@enddate varchar(10),
@FClosed int,
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FTranType nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,Fdate nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FChangeDate nvarchar(20) default('')
,FVersionNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,bgrq nvarchar(20) default('')
,bgyy nvarchar(1000) default('')
,bgr nvarchar(20) default('')
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)
,wsdj decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,xxs decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)
,jhrq nvarchar(20) default('')
,cpdm nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,jcsl decimal(28,2) default(0)
,jhsl decimal(28,2) default(0)         --订单关联任务单数量
,rksl decimal(28,2) default(0)         --任务单入库数量
,cksl decimal(28,2) default(0)
--,state nvarchar(20) default('')
,kpsl decimal(28,2) default(0)
/*,ckrq nvarchar(20) default('')
,fphsdj nvarchar(20) default('')*/
,aqkc decimal(28,2) default(0)
)

create table #Data(
FTranType nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,Fdate nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FChangeDate nvarchar(20) default('')
,FVersionNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,bgrq nvarchar(20) default('')
,bgyy nvarchar(1000) default('')
,bgr nvarchar(20) default('')
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)
,wsdj decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,xxs decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)
,jhrq nvarchar(20) default('')
,cpdm nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,jcsl decimal(28,2) default(0)
,jhsl decimal(28,2) default(0)         --订单关联任务单数量
,rksl decimal(28,2) default(0)         --任务单入库数量
,cksl decimal(28,2) default(0)
--,state nvarchar(20) default('')
,kpsl decimal(28,2) default(0)
/*,ckrq nvarchar(20) default('')
,fphsdj decimal(28,2) default(0)*/
,aqkc decimal(28,2) default(0)
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


Insert Into #temp(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg
,jldw,fssl,wsdj,hsdj,xxs,hsje,jhrq,cpdm,hywgb,jcsl,jhsl,rksl,cksl/*,state*/,kpsl/*,ckrq,fphsdj*/,aqkc
)
Select v1.FTranType as FTranType,v1.FInterID as FInterID,u1.FEntryID as FEntryID,case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,Convert(char(10),v1.Fdate,120) as Fdate,v1.FBillNo as FBillNo,Convert(char(10),v1.FChangeDate,120) as 
FChangeDate,v1.FVersionNo as FVersionNo,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,t4.FNumber as 'dwdm',t4.FName as 'wldw',FChangeDate as 'bgrq',FChangeCauses as 'bgyy',
u.FDescription as 'bgr',us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',
u1.FPrice as 'wsdj',u1.FPriceDiscount as 'hsdj',u1.FTaxAmt as 'xxs',u1.FAllAmount as 'hsje',Convert(char(10),u1.FDate,120) as 'jhrq',i.FNumber as 'cpdm',
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb',isnull(h.FBUQty,0) as 'jcsl',CASE WHEN isnull(k1.FQty,0)>0 THEN k1.FQty ELSE isnull(k.FQty,0) END as 'jhsl', CASE WHEN isnull(k1.FStockQty,0)>0 THEN k1.FStockQty ELSE isnull(k.FStockQty,0) END as 'rksl',isnull(u1.FAuxStockQty,0) as 'cksl',
/*case when isnull(u1.FQty,0)-isnull(j.FQty,0)>isnull(h.FBUQty,0) then 'N' else 'Y' end as 'state',*/
isnull(u1.FInvoiceQty,0) as 'kpsl'/*,isnull(convert(char(10),j.FDate,120),'') as 'ckrq',isnull(l.FTaxPrice,0) as 'fphsdj'*/,isnull(b.FSecInv,0) as 'aqkc'
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT OUTER JOIN t_Organization t4 ON  v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_user u ON u.FUserID=v1.FChangeUser
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
left join t_ICItemBase b on i.FItemID=b.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
left join (
Select SUM(ROUND(u1.FQty,t1.FQtydecimal)) as FBUQty,t1.FItemID AS FItemID 
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
group by t1.FItemID
) h on u1.FItemID=h.FItemID
LEFT JOIN (
select v1.FItemID,v1.FOrderInterID,isnull(sum(v1.FQty),0) as FQty,isnull(sum(v1.FAuxStockQty),0) as FStockQty 
from ICMO v1
LEFT JOIN t_Department t8 ON v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
group by v1.FItemID,v1.FOrderInterID
) k on k.FItemID = u1.FItemID and v1.FInterID=k.FOrderInterID
LEFT JOIN (
select v1.FOrderInterID,v1.FSourceEntryID,isnull(sum(v1.FQty),0) as FQty,isnull(sum(v1.FAuxStockQty),0) as FStockQty 
from ICMO v1
LEFT JOIN t_Department t8 ON v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
AND v1.FOrderInterID>0 and v1.FSourceEntryID>0
group by v1.FOrderInterID,v1.FSourceEntryID
) k1 on v1.FInterID=k1.FOrderInterID and u1.FEntryID=k1.FSourceEntryID
/*LEFT JOIN(
select FOrderInterID,FOrderEntryID,sum(FQty) as FQty,MIN(a.FDate) as 'FDate' 
from ICStockBill a 
left join ICStockBillEntry b on a.FInterID=b.FInterID 
where a.FTranType=21 AND a.FCancellation = 0 AND a.FCheckerID <>0
group by FOrderInterID,FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as FQty, avg(u1.FTaxPrice) as FTaxPrice 
from ICSale v1 
INNER JOIN ICSaleEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
where v1.FTranType=80 AND v1.FROB=1 AND  v1.FCancellation = 0
group by u1.FOrderInterID,u1.FOrderEntryID
) l on u1.FInterID=l.FOrderInterID and u1.FEntryID=l.FOrderEntryID*/
where 1=1 
AND (v1.FChangeMark=0 
AND ( Isnull(v1.FClassTypeID,0)<>1007100) 
AND ((v1.FDate>='2015-01-01' AND  v1.FDate<='2015-06-30') AND  v1.FCancellation = 0))
--AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or u.FDescription like '%'+@query+'%' 
--or i.FModel like '%'+@query+'%' or i.FNumber like '%'+@query+'%')
order by v1.FDate, v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,jhrq,cpdm,hywgb,jcsl,jhsl,rksl,cksl,kpsl,aqkc)select * from #temp')
else
exec('Insert Into #Data(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,jhrq,cpdm,hywgb,jcsl,jhsl,rksl,cksl,kpsl,aqkc)select * from #temp order by '+ @orderby+' '+ @ordertype)

--select * from #Data

IF @FClosed=1
select * from #Data where FCloseStatus='Y' or hywgb='Y'
ELSE IF @FClosed=2
select * from #Data where FCloseStatus='' and hywgb=''
ELSE IF @FClosed=3
select * from #Data where FCloseStatus='' and hywgb='' and fssl>jhsl
ELSE
select * from #Data
end



------------count--------------
--drop procedure portal_list_xsdd_count 

create procedure portal_list_xsdd_count 
@query varchar(100),
@begindate varchar(10),
@enddate varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FTranType nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,Fdate nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FChangeDate nvarchar(20) default('')
,FVersionNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,bgrq nvarchar(20) default('')
,bgyy nvarchar(1000) default('')
,bgr nvarchar(20) default('')
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)
,wsdj decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,xxs decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)
,jhrq nvarchar(20) default('')
,cpdm nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,jcsl decimal(28,2) default(0)
,jhsl decimal(28,2) default(0)
,cksl decimal(28,2) default(0)
,state nvarchar(20) default('')
,kpsl decimal(28,2) default(0)
,ckrq nvarchar(20) default('')
,fphsdj nvarchar(20) default('')
,aqkc decimal(28,2) default(0)
)

create table #Data(
FTranType nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,Fdate nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FChangeDate nvarchar(20) default('')
,FVersionNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,bgrq nvarchar(20) default('')
,bgyy nvarchar(1000) default('')
,bgr nvarchar(20) default('')
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)
,wsdj decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,xxs decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)
,jhrq nvarchar(20) default('')
,cpdm nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,jcsl decimal(28,2) default(0)
,jhsl decimal(28,2) default(0)
,cksl decimal(28,2) default(0)
,state nvarchar(20) default('')
,kpsl decimal(28,2) default(0)
,ckrq nvarchar(20) default('')
,fphsdj decimal(28,2) default(0)
,aqkc decimal(28,2) default(0)
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


Insert Into #temp(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg
,jldw,fssl,wsdj,hsdj,xxs,hsje,jhrq,cpdm,hywgb,jcsl,jhsl,cksl,state,kpsl,ckrq,fphsdj,aqkc
)
Select v1.FTranType as FTranType,v1.FInterID as FInterID,u1.FEntryID as FEntryID,case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,Convert(char(10),v1.Fdate,120) as Fdate,v1.FBillNo as FBillNo,Convert(char(10),v1.FChangeDate,120) as 
FChangeDate,v1.FVersionNo as FVersionNo,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,t4.FNumber as 'dwdm',t4.FName as 'wldw',FChangeDate as 'bgrq',FChangeCauses as 'bgyy',
u.FDescription as 'bgr',us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',
u1.FPrice as 'wsdj',u1.FPriceDiscount as 'hsdj',u1.FTaxAmt as 'xxs',u1.FAllAmount as 'hsje',Convert(char(10),u1.FDate,120) as 'jhrq',i.FNumber as 'cpdm',
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb',isnull(h.FBUQty,0) as 'jcsl',isnull(k.FQty,0) as 'jhsl',isnull(u1.FAuxStockQty,0) as 'cksl',
case when isnull(u1.FQty,0)-isnull(j.FQty,0)>isnull(h.FBUQty,0) then 'N' else 'Y' end as 'state',
isnull(u1.FInvoiceQty,0) as 'kpsl',isnull(convert(char(10),j.FDate,120),'') as 'ckrq',isnull(l.FTaxPrice,0) as 'fphsdj',isnull(b.FSecInv,0) as 'aqkc'
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT OUTER JOIN t_Organization t4 ON  v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_user u ON u.FUserID=v1.FChangeUser
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
left join t_ICItemBase b on i.FItemID=b.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
left join (
Select SUM(ROUND(u1.FQty,t1.FQtydecimal)) as FBUQty,t1.FItemID AS FItemID 
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
group by t1.FItemID
) h on u1.FItemID=h.FItemID
LEFT JOIN (
select v1.FItemID,isnull(sum(v1.FQty),0)-isnull(sum(w.FQty),0) as FQty 
from ICMO v1
LEFT JOIN t_Department t8 ON v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN (
select u1.FICMOBillNo,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1 AND v1.FTranType=2 AND  v1.FCancellation = 0
group by u1.FICMOBillNo
) w on v1.FBillNo=w.FICMOBillNo
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
AND v1.FStatus in (1,5)
group by v1.FItemID
) k on k.FItemID = u1.FItemID
LEFT JOIN(
select FOrderInterID,FOrderEntryID,sum(FQty) as FQty,MIN(a.FDate) as 'FDate' 
from ICStockBill a 
left join ICStockBillEntry b on a.FInterID=b.FInterID 
where a.FTranType=21 AND a.FCancellation = 0 AND a.FCheckerID <>0
group by FOrderInterID,FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as FQty, avg(u1.FTaxPrice) as FTaxPrice 
from ICSale v1 
INNER JOIN ICSaleEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
where v1.FTranType=80 AND v1.FROB=1 AND  v1.FCancellation = 0
group by u1.FOrderInterID,u1.FOrderEntryID
) l on u1.FInterID=l.FOrderInterID and u1.FEntryID=l.FOrderEntryID
where 1=1 
AND (v1.FChangeMark=0 
AND ( Isnull(v1.FClassTypeID,0)<>1007100) 
AND ((v1.FDate>=@begindate AND  v1.FDate<=@enddate) AND  v1.FCancellation = 0))
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or u.FDescription like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or i.FNumber like '%'+@query+'%')
AND v1.FStatus in (1,2) AND u1.FMrpClosed <> 1                      --没有行关的分录
AND datediff(day,u1.FDate,getDate())<=2
order by u1.FDate

if @orderby='null'
exec('Insert Into #Data(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,jhrq,cpdm,hywgb,jcsl,jhsl,cksl,state,kpsl,ckrq,fphsdj,aqkc)select * from #temp')
else
exec('Insert Into #Data(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,jhrq,cpdm,hywgb,jcsl,jhsl,cksl,state,kpsl,ckrq,fphsdj,aqkc)select * from #temp order by '+ @orderby+' '+ @ordertype)

select count(*) from #Data
end


execute portal_list_xsdd '','2014-12-01','2014-12-31',3,'null','null'

execute portal_list_xsdd_count '','2011-12-29','2099-12-31','null','null'



execute list_xsdd_count '','2011-10-06','2011-10-31',''

execute list_xsdd_count '陈贤','2010-02-01','2010-02-28',2



select FOrderInterID,FPlanOrderInterID,FSourceEntryID,* from ICMO where FBillNo='WORK034989'