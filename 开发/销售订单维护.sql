--drop procedure list_xsdd drop procedure list_xsdd_count

create procedure list_xsdd 
@query varchar(100),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
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
Select top 2000 v1.FTranType as FTranType,v1.FInterID as FInterID,u1.FEntryID as FEntryID,case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,Convert(char(10),v1.Fdate,120) as Fdate,v1.FBillNo as FBillNo,Convert(char(10),v1.FChangeDate,120) as 
FChangeDate,v1.FVersionNo as FVersionNo,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,t4.FNumber as 'dwdm',t4.FName as 'wldw',FChangeDate as 'bgrq',FChangeCauses as 'bgyy',
u.FDescription as 'bgr',us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',
u1.FPrice as 'wsdj',u1.FPriceDiscount as 'hsdj',u1.FTaxAmt as 'xxs',u1.FAllAmount as 'hsje',Convert(char(10),u1.FDate,120) as 'jhrq',i.FNumber as 'cpdm',
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb',isnull(h.FBUQty,0) as 'jcsl',isnull(k.FQty,0) as 'jhsl',isnull(u1.FAuxStockQty,0) as 'cksl',
case when isnull(u1.FQty,0)-isnull(j.FQty,0)>isnull(h.FBUQty,0) then 'N' /*when isnull(u1.FQty,0)-isnull(j.FQty,0)>(isnull(h.FBUQty,0)+isnull(k.FQty,0)) then 'state002' */else 'Y' end as 'state',
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
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or u.FDescription like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or u1.FPriceDiscount like '%'+@query+'%' or u1.FAllAmount like '%'+@query+'%' or i.FNumber like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,jhrq,cpdm,hywgb,jcsl,jhsl,cksl,state,kpsl,ckrq,fphsdj,aqkc)select * from #temp')
else
exec('Insert Into #Data(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,jhrq,cpdm,hywgb,jcsl,jhsl,cksl,state,kpsl,ckrq,fphsdj,aqkc)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FTranType,fssl,xxs,hsje)
Select '合计',sum(u1.FQty) as 'fssl',sum(u1.FTaxAmt) as xxs, sum(u1.FAllAmount) as hsje
from SEOrder v1 INNER JOIN SEOrderEntry 
u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT OUTER JOIN t_Organization t4 ON  v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_user u ON u.FUserID=v1.FChangeUser
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND (v1.FChangeMark=0 
AND ( Isnull(v1.FClassTypeID,0)<>1007100) 
AND ((v1.FDate>=@begindate AND  v1.FDate<=@enddate) AND  v1.FCancellation = 0))
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or u.FDescription like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or u1.FPriceDiscount like '%'+@query+'%' or u1.FAllAmount like '%'+@query+'%' or i.FNumber like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select * from #Data
--select * from #Data where FCloseStatus='' and hywgb='' order by (fssl-cksl)-(jcsl+jhsl),jhrq DESC
end



------------count--------------
create procedure list_xsdd_count 
@query varchar(100),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10)
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
Select top 2000 v1.FTranType as FTranType,v1.FInterID as FInterID,u1.FEntryID as FEntryID,case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,Convert(char(10),v1.Fdate,120) as Fdate,v1.FBillNo as FBillNo,Convert(char(10),v1.FChangeDate,120) as 
FChangeDate,v1.FVersionNo as FVersionNo,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,t4.FNumber as 'dwdm',t4.FName as 'wldw',FChangeDate as 'bgrq',FChangeCauses as 'bgyy',
u.FDescription as 'bgr',us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',
u1.FPrice as 'wsdj',u1.FPriceDiscount as 'hsdj',u1.FTaxAmt as 'xxs',u1.FAllAmount as 'hsje',Convert(char(10),u1.FDate,120) as 'jhrq',i.FNumber as 'cpdm',
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb',isnull(h.FBUQty,0) as 'jcsl',isnull(k.FQty,0) as 'jhsl',isnull(j.FQty,0) as 'cksl',
case when isnull(u1.FQty,0)-isnull(j.FQty,0)>isnull(h.FBUQty,0) then 'N' /*when isnull(u1.FQty,0)-isnull(j.FQty,0)>(isnull(h.FBUQty,0)+isnull(k.FQty,0)) then 'state002' */else 'Y' end as 'state',
isnull(l.FQty,0) as 'kpsl',isnull(convert(char(10),j.FDate,120),'') as 'ckrq',isnull(l.FTaxPrice,0) as 'fphsdj',isnull(b.FSecInv,0) as 'aqkc'
from SEOrder v1 INNER JOIN SEOrderEntry 
u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
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
select v1.FItemID,sum(v1.FQty) as FQty 
from ICMO v1
LEFT JOIN t_Department t8 ON v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
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
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or u.FDescription like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or u1.FPriceDiscount like '%'+@query+'%' or u1.FAllAmount like '%'+@query+'%' or i.FNumber like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

exec('Insert Into #Data(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,jhrq,cpdm,hywgb,jcsl,jhsl,cksl,state,kpsl,ckrq,fphsdj,aqkc)select * from #temp')

Insert Into  #Data(FTranType,fssl,xxs,hsje)
Select '合计',sum(u1.FQty) as 'fssl',sum(u1.FTaxAmt) as xxs, sum(u1.FAllAmount) as hsje
from SEOrder v1 INNER JOIN SEOrderEntry 
u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT OUTER JOIN t_Organization t4 ON  v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_user u ON u.FUserID=v1.FChangeUser
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND (v1.FChangeMark=0 
AND ( Isnull(v1.FClassTypeID,0)<>1007100) 
AND ((v1.FDate>=@begindate AND  v1.FDate<=@enddate) AND  v1.FCancellation = 0))
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or u.FDescription like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or u1.FPriceDiscount like '%'+@query+'%' or u1.FAllAmount like '%'+@query+'%' or i.FNumber like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data
end


execute list_xsdd '','2011-10-01','2011-10-31','','null','null'



execute list_xsdd_count '','2011-10-06','2011-10-31',''

execute list_xsdd_count '陈贤','2010-02-01','2010-02-28',2

1127

SEORD000001

SELECT * FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where FOrderBillNo='SEORD000001'

select * from SEOrderEntry




select * from t_Organization







35977

select * from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FBillNo='SEORD002079'

select * from SEOrder where FBillNo='SEORD000006' and FCancellation=0

select FBatchNo from SEOrderEntry


select u1.FOrderInterID,v1.FBillNo,i.FNumber,u1.FOrderBillNo,u1.FOrderEntryID,u1.FQty from ICSale v1 
INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
where v1.FTranType=80 AND v1.FROB=1 AND  v1.FCancellation = 0
and u1.FOrderBillNo='SEORD002272'

select v1.FBillNo,i.FNumber,u1.FEntryID,u1.FInterID 
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
where v1.FBillNo='SEORD002272' AND  v1.FCancellation = 0

select * from SEOrder where FInterID in (
3632
)


select FAreaPS,FStatus from SEOrder a left join SEOrderEntry b on a.FInterID = b.FInterID where a.FBillNo = 'SEORD002828'

select * from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where FBillNo='SEORD002272'



select * from t_user where 


select FReceiveAmountFor_Commit from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID

drop table SEOrder

drop table SEOrderEntry

select * from t_Department

select * from t_Stock


FHeadSelfS0149 = sum(FAllAmount)
SELECT * FROM SEOrder



select v1.FBillNo,u1.FNote,u1.FEntrySelfS0161
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1
--and u1.FEntrySelfS0161 is null
--and u1.FNote is not null and u1.FNote <>''
and v1.FDate >='2014-06-01'
and (u1.FEntrySelfS0161 like '%出库%' 
or u1.FEntrySelfS0161 like '%返工%'
or u1.FEntrySelfS0161 like '%加急%'
or u1.FEntrySelfS0161 like '%一体化%'
or u1.FEntrySelfS0161 like '%实验%'
or u1.FEntrySelfS0161 like '%信息%'
or u1.FEntrySelfS0161 like '%每天%'
or u1.FEntrySelfS0161 like '%换货%'
or u1.FEntrySelfS0161 like '%库存%')



update u1 set u1.FEntrySelfS0161='' 
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1
--and u1.FEntrySelfS0161 is null
--and u1.FNote is not null and u1.FNote <>''
and v1.FDate >='2014-01-01'
and (u1.FEntrySelfS0161 like '%订单%' 
or u1.FEntrySelfS0161 like '%急单%'
or u1.FEntrySelfS0161 like '%合同%'
or u1.FEntrySelfS0161 like '%一体化%'
or u1.FEntrySelfS0161 like '%实验%'
or u1.FEntrySelfS0161 like '%信息%'
or u1.FEntrySelfS0161 like '%每天%'
or u1.FEntrySelfS0161 like '%换货%'
or u1.FEntrySelfS0161 like '%库存%')






select * from SEOrder v1
where v1.FBillNo in (
'SEORD007252',
'SEORD007343',
'SEORD006781',
'SEORD006825',
'SEORD006821',
'SEORD006893',
'SEORD006899',
'SEORD007128',
'SEORD007156',
'SEORD007209',
'SEORD007245',
'SEORD007265',
'SEORD007293',
'SEORD007304',
'SEORD007345',
'SEORD007356',
'SEORD007344',
'SEORD007399',
'SEORD007023'
)
AND  v1.FCancellation = 0

update SEOrder set FEmpID=14667
where FBillNo in (
'SEORD007252',
'SEORD007343',
'SEORD006781',
'SEORD006825',
'SEORD006821',
'SEORD006893',
'SEORD006899',
'SEORD007128',
'SEORD007156',
'SEORD007209',
'SEORD007245',
'SEORD007265',
'SEORD007293',
'SEORD007304',
'SEORD007345',
'SEORD007356',
'SEORD007344',
'SEORD007399',
'SEORD007023'
)
AND  FCancellation = 0


select * from t_user

select * from t_emp

16493





SELECT * 
FROM SEOrder
WHERE FBillNo='SEORD007746'
AND (FChangeMark=0 
AND ( Isnull(FClassTypeID,0)<>1007100) )

UPDATE SEOrder SET FCustID=17662
WHERE FBillNo='SEORD007746'
AND (FChangeMark=0 
AND ( Isnull(FClassTypeID,0)<>1007100) )

select * from SEOutStock 
where FBillNo in ('SEOUT009498','SEOUT009386','SEOUT009413')

update SEOutStock set FCustID=17662
where FBillNo in ('SEOUT009498','SEOUT009386','SEOUT009413')


select * from ICStockBill
where FBillNo in ('XOUT010541')

update ICStockBill set FSupplyID=264
where FBillNo in ('XOUT010541')


select * from t_Organization where FNumber in ('04.006','04.001')


264
17662
