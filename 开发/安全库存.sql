--drop procedure list_aqkc_full drop procedure list_aqkc_count

create procedure list_aqkc_full 
@query varchar(100),
@month int,
@state int,                    -- 1：报警 0：正常
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
,cklj decimal(28,0) default(0)        --累计出库
,yckl decimal(28,0) default(0)        --月平均
,aqkc decimal(28,2) default(0)        --安全库存
,zgkc decimal(28,2) default(0)        --最高库存
,zxdhl decimal(28,2) default(0)       --最小订货量
,rxhl decimal(28,2) default(0)        --日消耗量
,cgzq decimal(28,0) default(0)        --采购周期
,hsdj decimal(28,2) default(0)        --含税单价
,aqkcje decimal(28,2) default(0)      --安全库存金额
,zgkcje decimal(28,2) default(0)      --最高库存金额
,jcsl decimal(28,2) default(0)        --及时库存
,mx decimal(28,2) default(0)       --单月最高消耗量
,ztsl decimal(28,2) default(0)     --预计入库量
,cksl decimal(28,2) default(0)     --预计出库量
,aqkccy decimal(28,2) default(0)   --差异：结存 + 预计入库量 - 安全库存
,syckl decimal(28,0) default(0)     --上月出库量
,byckl decimal(28,0) default(0)     --本月出库量
,wlsx nvarchar(255) default('')    --物料属性
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
,cksl decimal(28,2) default(0)     --预计出库量
,aqkccy decimal(28,2) default(0)   
,syckl decimal(28,0) default(0)
,byckl decimal(28,0) default(0)     --本月出库量
,wlsx nvarchar(255) default('')    --物料属性
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

/*create table #tt(
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
order by FNumber */

Insert Into #temp(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl,cksl,aqkccy,syckl,byckl,wlsx
)
select a.FNumber as 'wldm',a.FName as 'wlmc',a.FModel as 'wlgg',
a.FHelpCode as 'cpth',m.FName as 'jldw',/*f.FQty as 'cklj',f.FQty/@month as 'yckl',*/0,0,b.FSecInv as 'aqkc',b.FHighLimit as 'zgkc',
d.FQtyMin as 'zxdhl',d.FDailyConsume as 'rxhl',d.FFixLeadTime as 'cgzq',/*isnull(g.FTaxPrice,0) as 'hsdj',isnull(g.FTaxPrice,0)*b.FSecInv as 'aqkcje',isnull(g.FTaxPrice,0)*b.FHighLimit as 'zgkcje',*/0,0,0,
isnull(h.FBUQty,0) as 'jcsl',/*j.mx as 'mx',*/0,isnull(k.FQty,0)/*+isnull(s.FBUQty,0)*/+isnull(r.FQty,0) as 'ztsl',isnull(q.FQty,0)/*+isnull(o.FQty,0)*/ as 'cksl',
/*isnull(h.FBUQty,0)+isnull(k.FQty,0)-isnull(b.FSecInv,0) as 'aqkccy'*/0,/*isnull(p.FQty,0) as 'syckl',isnull(p1.FQty,0) as 'byckl',*/0,0,case when a.FErpClsID=1 then '外购' when a.FErpClsID=2 then '自制' else '' end as 'wlsx'
FROM t_ICItem a 
LEFT JOIN t_ICItemBase b on a.FItemID=b.FItemID 
LEFT JOIN t_Stock c on b.FDefaultLoc=c.FItemID 
LEFT JOIN t_ICItemPlan d on a.FItemID=d.FItemID
LEFT JOIN t_ICItemQuality e on a.FItemID=e.FItemID
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID
--LEFT JOIN (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where datediff(day,FDate,getdate())<(@month*30) and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') and FCancellation = 0 and FCheckerID>0 group by FItemID) f on a.FItemID=f.FItemID
--LEFT JOIN (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where convert(char(10),dateadd(dd,-day(dateadd(month,-1,getdate()))+1,dateadd(month,-1,getdate())),120)<=FDate and convert(char(10),dateadd(ms,-3,DATEADD(mm,DATEDIFF(mm,0,getdate()),0)),120)>=FDate and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') and FCancellation = 0 and FCheckerID>0 group by FItemID) p on a.FItemID=p.FItemID
--LEFT JOIN (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where convert(char(10),dateadd(dd,-day(dateadd(month,0,getdate()))+1,dateadd(month,0,getdate())),120)<=FDate and convert(char(10),getDate(),120)>=FDate and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') and FCancellation = 0 and FCheckerID>0 group by FItemID) p1 on a.FItemID=p1.FItemID
--LEFT JOIN (select c.FNumber as FNumber,AVG(FTaxPrice) as FTaxPrice from ICPurchase a left join ICPurchaseEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FDate>='2010-05-01' and left(c.FNumber,2)<>'05' and left(c.FNumber,2)<>'06' group by c.FNumber) g on a.FNumber=g.FNumber
--LEFT JOIN (select FItemID,max(fssl) as 'mx' from #tt group by FItemID) j on a.FItemID=j.FItemID
LEFT JOIN (
	Select SUM(ROUND(u1.FQty,t1.FQtydecimal)) as FBUQty,t1.FNumber AS FLongNumber 
	From #TempInventory u1
	left join t_ICItem t1 on u1.FItemID = t1.FItemID
	left join t_Stock t2 on u1.FStockID=t2.FItemID
	left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
	left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
	left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
	left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID 
	left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  
	where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
	and t1.FDeleted=0 
	AND t2.FTypeID in (500,20291,20293)
	and t2.FItemID <> '4527'             --废品（工废）库
	and t2.FItemID <> '4528'             --可利用库
	and t2.FItemID <> '4739'             --返工返修库
	and t2.FItemID <> '5272'             --料废库
	and t2.FItemID <> '5888'             --封存库
	group by t1.FNumber
) h on a.FNumber=h.FLongNumber                      --即时库存
LEFT JOIN (
	select b.FItemID,sum(b.FQty) as FQty 
	from t_ICItem a
	inner join (
		select b.FBillNo,b.FItemID,
		case when b.FMRPClosed=0            --如果未行关闭，就取申请单数量
		then case when (b.FQty-isnull(d.FStockQty,0))<0 then 0 else b.FQty-isnull(d.FStockQty,0) end 
		when b.FMRPClosed=1 and e.FQty>0                 --如果行关闭，就取订单数量
		then case when (e.FQty-isnull(d.FStockQty,0))<0 then 0 else e.FQty-isnull(d.FStockQty,0) end
		else 0
		end as FQty 
		from t_ICItem a 
		inner join (select a.FBillNo,a.FStatus,a.FInterID,b.FItemID,sum(b.FQty) as FQty,Max(b.FMRPClosed) as FMRPClosed from POrequest a left join POrequestEntry b on a.FInterID=b.FInterID and a.FInterID<>0 where a.FCancellation = 0 AND a.FMultiCheckLevel1>0 /*AND charindex('SEORD',FNote)=0*//*1： 已审  2：已审且已下推过订单  3：整张关闭  4：如果申请备注销售订单号，则不参与安全库存计算*/ group by a.FBillNo,a.FStatus,a.FInterID,b.FItemID) b on a.FItemID=b.FItemID
		left join (select SUM(a.FAuxStockQty) as FStockQty,a.FSourceBillNo,b.FItemID from vwICBill_26 a left join POOrderEntry b on a.FInterID=b.FInterID and a.FEntryID=b.FEntryID group by a.FSourceBillNo,b.FItemID) d on b.FBillNo=d.FSourceBillNo and b.FItemID=d.FItemID
		left join (select b.FSourceBillNo,b.FItemID,sum(b.FQty) as FQty from POOrder a left join POOrderEntry b on a.FInterID=b.FInterID where a.FCancellation = 0 AND a.FCheckerID>0 AND b.FMRPClosed=0 group by b.FSourceBillNo,b.FItemID) e on e.FSourceBillNo=b.FBillNo and b.FItemID=e.FItemID      --只有行业务关闭才能取消预计入库量，单据关闭不能
	) b on a.FItemID=b.FItemID
	group by b.FItemID
) k on a.FItemID=k.FItemID  --采购订单的数量必须跟入库数量一致，如果采购申请的数量与订单数量不一致，只需手工关闭采购申请  预计入库量
/*LEFT JOIN (
	Select SUM(ROUND(u1.FQty,t1.FQtydecimal)) as FBUQty,t1.FNumber AS FLongNumber 
	From #TempInventory u1
	left join t_ICItem t1 on u1.FItemID = t1.FItemID
	left join t_Stock t2 on u1.FStockID=t2.FItemID
	left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
	left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
	left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
	left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  
	where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
	and t1.FDeleted=0 
	AND t2.FTypeID in (501)
	and t2.FItemID = 4156           --待检仓的代码
	group by t1.FNumber
) s on s.FLongNumber=a.FNumber*/           --待检仓作为在途 ;  2014-07-14：k中包含了待检仓数量，在这种情况下，是以入库才减在途
LEFT JOIN (
	select c.FItemID,case when (sum(c.FQty)-sum(c.FAuxStockQty))>0 then isnull(sum(c.FQty)-sum(c.FAuxStockQty),0) else 0 end as 'FQty'
	from ICMO a
	left join PPBOM b ON   b.FICMOInterID = a.FInterID  AND a.FInterID<>0
	left join PPBOMEntry c ON c.FInterID = b.FInterID  AND b.FInterID<>0 
	where a.FStatus=1      --下达状态
	group by c.FItemID
) o on a.FItemID=o.FItemID       --自制产品预计出库量，投料量-领料量+报废量   
LEFT JOIN (
	select u1.FItemID,case when isnull(sum(u1.FQty),0)-isnull(sum(u1.FStockQty),0)<0 then 0 else isnull(sum(u1.FQty),0)-isnull(sum(u1.FStockQty),0) end as FQty
	from SEOrder v1 
	inner join SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
	where v1.FStatus<>3 and u1.FMrpClosed=0 and v1.FDate>convert(char(10),dateadd(dd,-day(dateadd(month,-6,getdate()))+1,dateadd(month,-6,getdate())),120)
	and v1.FCancellation=0
	group by u1.FItemID
) q on a.FItemID=q.FItemID       --产品预计出库量，订单量 - 出库量 只包括前3个月的订单
LEFT JOIN (
	select v1.FItemID,isnull(sum(v1.FQty),0)-isnull(sum(v1.FStockQty),0) as FQty 
	from ICMO v1
	where 1=1 
	AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
	AND v1.FStatus in (1,5)
	group by v1.FItemID
) r on r.FItemID = a.FItemID        --自制产品预计入库量
WHERE 1=1 
and b.FSecInv<>0             --安全库存不为空
and a.FDeleted=0             --未被删除
--and left(a.FNumber,5) = '02.02'
and (a.FNumber like '%'+@query+'%' or a.FName like '%'+@query+'%' or a.FModel like '%'+@query+'%' or a.FHelpCode like '%'+@query+'%')
order by a.FNumber

if @orderby='null'
exec('Insert Into #Data(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl,cksl,aqkccy,syckl,byckl,wlsx)select * from #temp')
else
exec('Insert Into #Data(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl,cksl,aqkccy,syckl,byckl,wlsx)select * from #temp order by '+ @orderby+' '+ @ordertype)

/*Insert Into  #Data(wldm,aqkcje,zgkcje)
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
and a.FDeleted=0             --未被删除
--and left(a.FNumber,5) = '02.02'      
and (a.FNumber like '%'+@query+'%' or a.FName like '%'+@query+'%' or a.FModel like '%'+@query+'%' or a.FHelpCode like '%'+@query+'%')*/

if 0=@state
select * from #Data
else if 1=@state
select * from #Data where 1=1 and (aqkc-(jcsl+ztsl))>0
else if 2=@state
select * from #Data where 1=1 and (aqkc-(jcsl+ztsl))<=0
Drop Table #TempInventory
end

---count-------

create procedure list_aqkc_count 
@query varchar(100),
@month int,
@state int,                    -- 1：报警 0：正常
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
,cklj decimal(28,0) default(0)        --累计出库
,yckl decimal(28,0) default(0)        --月平均
,aqkc decimal(28,2) default(0)        --安全库存
,zgkc decimal(28,2) default(0)        --最高库存
,zxdhl decimal(28,2) default(0)       --最小订货量
,rxhl decimal(28,2) default(0)        --日消耗量
,cgzq decimal(28,0) default(0)        --采购周期
,hsdj decimal(28,2) default(0)        --含税单价
,aqkcje decimal(28,2) default(0)      --安全库存金额
,zgkcje decimal(28,2) default(0)      --最高库存金额
,jcsl decimal(28,2) default(0)        --及时库存
,mx decimal(28,2) default(0)       --单月最高消耗量
,ztsl decimal(28,2) default(0)     --预计入库量
,cksl decimal(28,2) default(0)     --预计出库量
,aqkccy decimal(28,2) default(0)   --差异：结存 + 预计入库量 - 安全库存
,syckl decimal(28,0) default(0)     --上月出库量
,byckl decimal(28,0) default(0)     --本月出库量
,wlsx nvarchar(255) default('')    --物料属性
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
,cksl decimal(28,2) default(0)     --预计出库量
,aqkccy decimal(28,2) default(0)   
,syckl decimal(28,0) default(0)
,byckl decimal(28,0) default(0)     --本月出库量
,wlsx nvarchar(255) default('')    --物料属性
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

/*create table #tt(
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
order by FNumber */

Insert Into #temp(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl,cksl,aqkccy,syckl,byckl,wlsx
)
select a.FNumber as 'wldm',a.FName as 'wlmc',a.FModel as 'wlgg',
a.FHelpCode as 'cpth',m.FName as 'jldw',/*f.FQty as 'cklj',f.FQty/@month as 'yckl',*/0,0,b.FSecInv as 'aqkc',b.FHighLimit as 'zgkc',
d.FQtyMin as 'zxdhl',d.FDailyConsume as 'rxhl',d.FFixLeadTime as 'cgzq',/*isnull(g.FTaxPrice,0) as 'hsdj',isnull(g.FTaxPrice,0)*b.FSecInv as 'aqkcje',isnull(g.FTaxPrice,0)*b.FHighLimit as 'zgkcje',*/0,0,0,
isnull(h.FBUQty,0) as 'jcsl',/*j.mx as 'mx',*/0,isnull(k.FQty,0)+isnull(r.FQty,0) as 'ztsl',isnull(q.FQty,0)+isnull(o.FQty,0) as 'cksl',
isnull(h.FBUQty,0)+isnull(k.FQty,0)-isnull(b.FSecInv,0) as 'aqkccy',/*isnull(p.FQty,0) as 'syckl',isnull(p1.FQty,0) as 'byckl',*/0,0,case when a.FErpClsID=1 then '外购' when a.FErpClsID=2 then '自制' else '' end as 'wlsx'
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID
left join t_ICItemQuality e on a.FItemID=e.FItemID
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID
--left join (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where datediff(day,FDate,getdate())<(@month*30) and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') and FCancellation = 0 and FCheckerID>0 group by FItemID) f on a.FItemID=f.FItemID
--left join (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where convert(char(10),dateadd(dd,-day(dateadd(month,-1,getdate()))+1,dateadd(month,-1,getdate())),120)<=FDate and convert(char(10),dateadd(ms,-3,DATEADD(mm,DATEDIFF(mm,0,getdate()),0)),120)>=FDate and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') and FCancellation = 0 and FCheckerID>0 group by FItemID) p on a.FItemID=p.FItemID
--left join (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where convert(char(10),dateadd(dd,-day(dateadd(month,0,getdate()))+1,dateadd(month,0,getdate())),120)<=FDate and convert(char(10),getDate(),120)>=FDate and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') and FCancellation = 0 and FCheckerID>0 group by FItemID) p1 on a.FItemID=p1.FItemID
--left join (select c.FNumber as FNumber,AVG(FTaxPrice) as FTaxPrice from ICPurchase a left join ICPurchaseEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FDate>='2010-05-01' and left(c.FNumber,2)<>'05' and left(c.FNumber,2)<>'06' group by c.FNumber) g on a.FNumber=g.FNumber
--left join (select FItemID,max(fssl) as 'mx' from #tt group by FItemID) j on a.FItemID=j.FItemID
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
AND t2.FTypeID in (500,20291,20293)
and t2.FItemID <> '4527'             --废品（工废）库
and t2.FItemID <> '4528'             --可利用库
and t2.FItemID <> '4739'             --返工返修库
and t2.FItemID <> '5272'             --料废库
and t2.FItemID <> '5888'             --封存库
group by t1.FNumber
) h on a.FNumber=h.FLongNumber
LEFT JOIN (
select b.FItemID,sum(b.FQty) as FQty 
from t_ICItem a
inner join (
select b.FBillNo,b.FItemID,
case when b.FMRPClosed=0            --如果未行关闭，就取申请单数量
then case when (b.FQty-isnull(d.FStockQty,0))<0 then 0 else b.FQty-isnull(d.FStockQty,0) end 
when b.FMRPClosed=1 and e.FQty>0                 --如果行关闭，就取订单数量
then case when (e.FQty-isnull(d.FStockQty,0))<0 then 0 else e.FQty-isnull(d.FStockQty,0) end
else 0
end as FQty 
from t_ICItem a 
inner join (select a.FBillNo,a.FStatus,a.FInterID,b.FItemID,sum(b.FQty) as FQty,Max(b.FMRPClosed) as FMRPClosed from POrequest a left join POrequestEntry b on a.FInterID=b.FInterID and a.FInterID<>0 where a.FCancellation = 0 AND a.FMultiCheckLevel1>0 /*1： 已审  2：已审且已下推过订单  3：整张关闭*/ group by a.FBillNo,a.FStatus,a.FInterID,b.FItemID) b on a.FItemID=b.FItemID
left join (select SUM(a.FAuxStockQty) as FStockQty,a.FSourceBillNo,b.FItemID from vwICBill_26 a left join POOrderEntry b on a.FInterID=b.FInterID and a.FEntryID=b.FEntryID group by a.FSourceBillNo,b.FItemID) d on b.FBillNo=d.FSourceBillNo and b.FItemID=d.FItemID
left join (select b.FSourceBillNo,b.FItemID,sum(b.FQty) as FQty from POOrder a left join POOrderEntry b on a.FInterID=b.FInterID where a.FCancellation = 0 AND a.FCheckerID>0 AND a.FStatus<>3 AND b.FMRPClosed=0 group by b.FSourceBillNo,b.FItemID) e on e.FSourceBillNo=b.FBillNo and b.FItemID=e.FItemID 
) b on a.FItemID=b.FItemID
group by b.FItemID
) k on a.FItemID=k.FItemID  --采购订单的数量必须跟入库数量一致，如果采购申请的数量与订单数量不一致，只需手工关闭采购申请
LEFT JOIN (
select c.FItemID,case when (sum(c.FQty)-sum(d.FQty)+sum(f.FQty))>0 then isnull(sum(c.FQty)-sum(d.FQty)+sum(f.FQty),0) else 0 end as 'FQty'
from ICMO a
LEFT JOIN PPBOM b ON   b.FICMOInterID = a.FInterID  AND a.FInterID<>0
LEFT JOIN PPBOMEntry c ON c.FInterID = b.FInterID  AND b.FInterID<>0 
LEFT JOIN t_ICItem i1 on a.FItemID=i1.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=a.FUnitID
LEFT JOIN t_ICItem i2 on c.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu2 on mu2.FItemID=c.FUnitID
LEFT JOIN (
select u1.FSourceBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=24 and v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FSourceBillNo,u1.FItemID
) d on a.FBillNo=d.FSourceBillNo and c.FItemID=d.FItemID   --领料
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FICMOBillNo,u1.FItemID
) e on a.FBillNo=e.FICMOBillNo and a.FItemID=e.FItemID  --入库数量
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0
where v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FICMOBillNo,u1.FItemID
) f on a.FBillNo=f.FICMOBillNo and c.FItemID=f.FItemID  --报废数量
group by c.FItemID
) o on a.FItemID=o.FItemID       --预计入库量，投料量-领料量+报废量
LEFT JOIN (
select u1.FItemID,case when isnull(sum(u1.FQty),0)-isnull(sum(j.FQty),0)<0 then 0 else isnull(sum(u1.FQty),0)-isnull(sum(j.FQty),0) end as FQty
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
left join(
select FOrderBillNo,FItemID,sum(FQty) as FQty,MIN(a.FDate) as 'FDate' 
from ICStockBill a 
left join ICStockBillEntry b on a.FInterID=b.FInterID 
where a.FTranType=21 AND a.FCancellation = 0 AND a.FCheckerID <>0
group by FOrderBillNo,FItemID
) j on v1.FBillNo=j.FOrderBillNo and u1.FItemID=j.FItemID
where v1.FStatus<>3 and v1.FDate>convert(char(10),dateadd(dd,-day(dateadd(month,-3,getdate()))+1,dateadd(month,-3,getdate())),120)
group by u1.FItemID
) q on a.FItemID=q.FItemID       --产品预计出库量，订单量 - 出库量 只包括前3个月的订单
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
) r on r.FItemID = a.FItemID
where 1=1 
and b.FSecInv<>0             --安全库存不为空
and a.FDeleted=0             --未被删除
--and left(a.FNumber,5) = '02.02'
and (a.FNumber like '%'+@query+'%' or a.FName like '%'+@query+'%' or a.FModel like '%'+@query+'%' or a.FHelpCode like '%'+@query+'%')
order by a.FNumber

if @orderby='null'
exec('Insert Into #Data(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl,cksl,aqkccy,syckl,byckl,wlsx)select * from #temp')
else
exec('Insert Into #Data(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl,cksl,aqkccy,syckl,byckl,wlsx)select * from #temp order by '+ @orderby+' '+ @ordertype)

/*Insert Into  #Data(wldm,aqkcje,zgkcje)
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
and a.FDeleted=0             --未被删除
--and left(a.FNumber,5) = '02.02'      
and (a.FNumber like '%'+@query+'%' or a.FName like '%'+@query+'%' or a.FModel like '%'+@query+'%' or a.FHelpCode like '%'+@query+'%')*/

if 0=@state
select count(*) from #Data
else if 1=@state
select count(*) from #Data where 1=1 and (aqkc-(jcsl+ztsl))>0
else if 2=@state
select count(*) from #Data where 1=1 and (aqkc-(jcsl+ztsl))<=0
Drop Table #TempInventory
end

---count----
create procedure list_aqkc_count 
@query varchar(100),
@month int,
@state int,                    -- 1：报警 0：正常
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
,ztsl decimal(28,2) default(0)     --预计入库量
,cksl decimal(28,2) default(0)     --预计出库量
,aqkccy decimal(28,2) default(0)   --差异：结存 + 预计入库量 - 安全库存
,syckl decimal(28,0) default(0)     --上月出库量
,byckl decimal(28,0) default(0)     --本月出库量
,wlsx nvarchar(255) default('')    --物料属性
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
,cksl decimal(28,2) default(0)     --预计出库量
,aqkccy decimal(28,2) default(0)   
,syckl decimal(28,0) default(0)
,byckl decimal(28,0) default(0)     --本月出库量
,wlsx nvarchar(255) default('')    --物料属性
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

Insert Into #temp(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl,cksl,aqkccy,syckl,byckl,wlsx
)
select a.FNumber as 'wldm',a.FName as 'wlmc',a.FModel as 'wlgg',
a.FHelpCode as 'cpth',m.FName as 'jldw',f.FQty as 'cklj',f.FQty/@month as 'yckl',b.FSecInv as 'aqkc',b.FHighLimit as 'zgkc',
d.FQtyMin as 'zxdhl',d.FDailyConsume as 'rxhl',d.FFixLeadTime as 'cgzq',isnull(g.FTaxPrice,0) as 'hsdj',isnull(g.FTaxPrice,0)*b.FSecInv as 'aqkcje',isnull(g.FTaxPrice,0)*b.FHighLimit as 'zgkcje',
isnull(h.FBUQty,0) as 'jcsl',j.mx as 'mx',isnull(k.FQty,0)+isnull(r.FQty,0) as 'ztsl',isnull(q.FQty,0)+isnull(o.FQty,0) as 'cksl',
isnull(h.FBUQty,0)+isnull(k.FQty,0)-isnull(b.FSecInv,0) as 'aqkccy',isnull(p.FQty,0) as 'syckl',isnull(p1.FQty,0) as 'byckl',case when a.FErpClsID=1 then '外购' when a.FErpClsID=2 then '自制' else '' end as 'wlsx'
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID
left join t_ICItemQuality e on a.FItemID=e.FItemID
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID
left join (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where datediff(day,FDate,getdate())<(@month*30) and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') and FCancellation = 0 and FCheckerID>0 group by FItemID) f on a.FItemID=f.FItemID
left join (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where convert(char(10),dateadd(dd,-day(dateadd(month,-1,getdate()))+1,dateadd(month,-1,getdate())),120)<=FDate and convert(char(10),dateadd(ms,-3,DATEADD(mm,DATEDIFF(mm,0,getdate()),0)),120)>=FDate and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') and FCancellation = 0 and FCheckerID>0 group by FItemID) p on a.FItemID=p.FItemID
left join (select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where convert(char(10),dateadd(dd,-day(dateadd(month,0,getdate()))+1,dateadd(month,0,getdate())),120)<=FDate and convert(char(10),getDate(),120)>=FDate and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') and FCancellation = 0 and FCheckerID>0 group by FItemID) p1 on a.FItemID=p1.FItemID
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
AND t2.FTypeID in (500,20291,20293)
and t2.FItemID <> '4527'             --废品（工废）库
and t2.FItemID <> '4528'             --可利用库
and t2.FItemID <> '4739'             --返工返修库
and t2.FItemID <> '5272'             --料废库
and t2.FItemID <> '5888'             --封存库
group by t1.FNumber
) h on a.FNumber=h.FLongNumber
LEFT JOIN (
select b.FItemID,sum(b.FQty) as FQty 
from t_ICItem a
inner join (
select b.FBillNo,b.FItemID,
case when b.FMRPClosed=0            --如果未行关闭，就取申请单数量
then case when (b.FQty-isnull(d.FStockQty,0))<0 then 0 else b.FQty-isnull(d.FStockQty,0) end 
when b.FMRPClosed=1 and e.FQty>0                 --如果行关闭，就取订单数量
then case when (e.FQty-isnull(d.FStockQty,0))<0 then 0 else e.FQty-isnull(d.FStockQty,0) end
else 0
end as FQty 
from t_ICItem a 
inner join (select a.FBillNo,a.FStatus,a.FInterID,b.FItemID,sum(b.FQty) as FQty,Max(b.FMRPClosed) as FMRPClosed from POrequest a left join POrequestEntry b on a.FInterID=b.FInterID and a.FInterID<>0 where a.FCancellation = 0 AND a.FMultiCheckLevel1>0 /*1： 已审  2：已审且已下推过订单  3：整张关闭*/ group by a.FBillNo,a.FStatus,a.FInterID,b.FItemID) b on a.FItemID=b.FItemID
left join (select SUM(a.FAuxStockQty) as FStockQty,a.FSourceBillNo,b.FItemID from vwICBill_26 a left join POOrderEntry b on a.FInterID=b.FInterID and a.FEntryID=b.FEntryID group by a.FSourceBillNo,b.FItemID) d on b.FBillNo=d.FSourceBillNo and b.FItemID=d.FItemID
left join (select b.FSourceBillNo,b.FItemID,sum(b.FQty) as FQty from POOrder a left join POOrderEntry b on a.FInterID=b.FInterID where a.FCancellation = 0 AND a.FCheckerID>0 AND a.FStatus<>3 AND b.FMRPClosed=0 group by b.FSourceBillNo,b.FItemID) e on e.FSourceBillNo=b.FBillNo and b.FItemID=e.FItemID 
) b on a.FItemID=b.FItemID
group by b.FItemID
) k on a.FItemID=k.FItemID  --采购订单的数量必须跟入库数量一致，如果采购申请的数量与订单数量不一致，只需手工关闭采购申请
LEFT JOIN (
select c.FItemID,case when (sum(c.FQty)-sum(d.FQty)+sum(f.FQty))>0 then isnull(sum(c.FQty)-sum(d.FQty)+sum(f.FQty),0) else 0 end as 'FQty'
from ICMO a
LEFT JOIN PPBOM b ON   b.FICMOInterID = a.FInterID  AND a.FInterID<>0
LEFT JOIN PPBOMEntry c ON c.FInterID = b.FInterID  AND b.FInterID<>0 
LEFT JOIN t_ICItem i1 on a.FItemID=i1.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=a.FUnitID
LEFT JOIN t_ICItem i2 on c.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu2 on mu2.FItemID=c.FUnitID
LEFT JOIN (
select u1.FSourceBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=24 and v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FSourceBillNo,u1.FItemID
) d on a.FBillNo=d.FSourceBillNo and c.FItemID=d.FItemID   --领料
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FICMOBillNo,u1.FItemID
) e on a.FBillNo=e.FICMOBillNo and a.FItemID=e.FItemID  --入库数量
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0
where v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FICMOBillNo,u1.FItemID
) f on a.FBillNo=f.FICMOBillNo and c.FItemID=f.FItemID  --报废数量
group by c.FItemID
) o on a.FItemID=o.FItemID       --预计入库量，投料量-领料量+报废量
LEFT JOIN (
select u1.FItemID,case when isnull(sum(u1.FQty),0)-isnull(sum(j.FQty),0)<0 then 0 else isnull(sum(u1.FQty),0)-isnull(sum(j.FQty),0) end as FQty
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
left join(
select FOrderBillNo,FItemID,sum(FQty) as FQty,MIN(a.FDate) as 'FDate' 
from ICStockBill a 
left join ICStockBillEntry b on a.FInterID=b.FInterID 
where a.FTranType=21 AND a.FCancellation = 0 AND a.FCheckerID <>0
group by FOrderBillNo,FItemID
) j on v1.FBillNo=j.FOrderBillNo and u1.FItemID=j.FItemID
where v1.FStatus<>3 and v1.FDate>convert(char(10),dateadd(dd,-day(dateadd(month,-3,getdate()))+1,dateadd(month,-3,getdate())),120)
group by u1.FItemID
) q on a.FItemID=q.FItemID       --产品预计出库量，订单量 - 出库量 只包括前3个月的订单
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
) r on r.FItemID = a.FItemID
where 1=1 
and b.FSecInv<>0             --安全库存不为空
and a.FDeleted=0             --未被删除
--and left(a.FNumber,5) = '02.02'
and (a.FNumber like '%'+@query+'%' or a.FName like '%'+@query+'%' or a.FModel like '%'+@query+'%' or a.FHelpCode like '%'+@query+'%')
order by a.FNumber

if @orderby='null'
exec('Insert Into #Data(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl,cksl,aqkccy,syckl,byckl,wlsx)select * from #temp')
else
exec('Insert Into #Data(wldm,wlmc,wlgg,cpth,jldw,cklj,yckl,aqkc,zgkc,zxdhl,rxhl,cgzq,hsdj,aqkcje,zgkcje,jcsl,mx,ztsl,cksl,aqkccy,syckl,byckl,wlsx)select * from #temp order by '+ @orderby+' '+ @ordertype)

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
and a.FDeleted=0             --未被删除
--and left(a.FNumber,5) = '02.02'      
and (a.FNumber like '%'+@query+'%' or a.FName like '%'+@query+'%' or a.FModel like '%'+@query+'%' or a.FHelpCode like '%'+@query+'%')

if 0=@state
select count(*) from #Data
else if 1=@state
select count(*) from #Data where 1=1 and (aqkc-(jcsl+ztsl))>0
else if 2=@state
select count(*) from #Data where 1=1 and (aqkc-(jcsl+ztsl))<=0
Drop Table #TempInventory
end



execute list_aqkc '','12',0,'null','null'

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




----------------------------
select b.FItemID,case when (b.FCommitQty-isnull(d.FStockQty,0))<0 then 0 else b.FCommitQty-isnull(d.FStockQty,0) end as FQty 
from t_ICItem c
inner join (select b.FItemID,sum(b.FCommitQty) as FCommitQty from POrequest a left join POrequestEntry b on a.FInterID=b.FInterID and a.FInterID<>0 group by b.FItemID) b on a.FItemID=b.FItemID
left join (select SUM(a.FAuxStockQty) as FStockQty,a.FSourceBillNo,b.FItemID from vwICBill_26 a left join POOrderEntry b on a.FInterID=b.FInterID and a.FEntryID=b.FEntryID group by a.FSourceBillNo,b.FItemID) d on a.FBillNo=d.FSourceBillNo and b.FItemID=d.FItemID
where 1=1 
AND a.FCancellation=0 and a.FStatus=3



select b.FItemID,sum(b.FQty) as FQty 
from t_ICItem a
inner join (
select b.FBillNo,b.FItemID,
case when b.FStatus=2 
then case when (b.FCommitQty-isnull(d.FStockQty,0))<0 then 0 else b.FCommitQty-isnull(d.FStockQty,0) end 
when b.FStatus=3
then case when (e.FCommitQty-isnull(d.FStockQty,0))<0 then 0 else e.FCommitQty-isnull(d.FStockQty,0) end
end as FQty 
from t_ICItem a 
inner join (select a.FBillNo,a.FStatus,a.FInterID,b.FItemID,sum(b.FCommitQty) as FCommitQty from POrequest a left join POrequestEntry b on a.FInterID=b.FInterID and a.FInterID<>0 where a.FCancellation=0 and a.FStatus>=2 group by a.FBillNo,a.FStatus,a.FInterID,b.FItemID) b on a.FItemID=b.FItemID
left join (select SUM(a.FAuxStockQty) as FStockQty,a.FSourceBillNo,b.FItemID from vwICBill_26 a left join POOrderEntry b on a.FInterID=b.FInterID and a.FEntryID=b.FEntryID group by a.FSourceBillNo,b.FItemID) d on b.FBillNo=d.FSourceBillNo and b.FItemID=d.FItemID
left join (select b.FSourceBillNo,b.FItemID,sum(b.FCommitQty) as FCommitQty from POOrder a left join POOrderEntry b on a.FInterID=b.FInterID group by b.FSourceBillNo,b.FItemID) e on e.FSourceBillNo=b.FBillNo and b.FItemID=e.FItemID 
) b on a.FItemID=b.FItemID
group by b.FItemID







select * from t_ICItem a 
left join (
select a.FBillNo,a.FInterID,b.FItemID,sum(b.FCommitQty) as FCommitQty from POrequest a left join POrequestEntry b on a.FInterID=b.FInterID and a.FInterID<>0 group by a.FBillNo,a.FInterID,b.FItemID
) b on 


left join POrequest a on b.FItemID=c.FItemID and c.FItemID<>0
left join POrequestEntry b on a.FInterID=b.FInterID and a.FInterID<>0 


select * from POOrder a left join POOrderEntry b on a.FInterID=b.FInterID where 1=1



select * from POrequest a left join POrequestEntry b on a.FInterID=b.FInterID where FBillNo = 'POREQ000023'

select * from vwICBill_26 where FSourceBillNo in (
'POREQ000020',
'POREQ001032'      --JH-1106-78
)



select a.FBillNo,b.FCommitQty,d.FStockQty,b.FItemID,case when (b.FCommitQty-isnull(d.FStockQty,0))<0 then 0 else b.FCommitQty-isnull(d.FStockQty,0) end as FQty 
from POrequest a left join POrequestEntry b on a.FInterID=b.FInterID and a.FInterID<>0 
left join t_ICItem c on b.FItemID=c.FItemID and c.FItemID<>0
left join (select SUM(a.FAuxStockQty) as FStockQty,a.FSourceBillNo,b.FItemID from vwICBill_26 a left join POOrderEntry b on a.FInterID=b.FInterID and a.FEntryID=b.FEntryID group by a.FSourceBillNo,b.FItemID) d on a.FBillNo=d.FSourceBillNo and b.FItemID=d.FItemID
where 1=1 
AND a.FCancellation=0 and a.FStatus=3 
and c.FNumber = '01.01.01.006'


select a.FBillNo,b.FCommitQty,a.FStatus from POrequest a left join POrequestEntry b on a.FInterID=b.FInterID and a.FInterID<>0 left join t_ICItem c on b.FItemID=c.FItemID 
where c.FNumber='01.01.01.006'

select * from 




select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where convert(char(10),dateadd(dd,-day(dateadd(month,-1,getdate()))+1,dateadd(month,-1,getdate())),120)<=FDate and convert(char(10),dateadd(ms,-3,DATEADD(mm,DATEDIFF(mm,0,getdate()),0)),120)>=FDate and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') and FCancellation = 0 and FCheckerID>0 group by FItemID

select FItemID,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where convert(char(10),dateadd(dd,-day(dateadd(month,0,getdate()))+1,dateadd(month,0,getdate())),120)<=FDate and convert(char(10),getDate(),120)>=FDate and (left(FBillNo,4)='SOUT' or left(FBillNo,4)='XOUT') and FCancellation = 0 and FCheckerID>0 group by FItemID

select dateadd(dd,-day(dateadd(month,0,getdate()))+1,dateadd(month,0,getdate()))

select dateadd(ms,-3,DATEADD(mm,DATEDIFF(mm,0,getdate()),0))


select FErpClsID,* from t_ICItem where FNumber='05.08.4502'

update t_ICItem set FErpClsID=1 where FNumber='06.07.0090'





select u1.FItemID,i.FNumber,sum(u1.FQty),sum(j.FQty),case when isnull(sum(u1.FQty),0)-isnull(sum(j.FQty),0)<0 then 0 else isnull(sum(u1.FQty),0)-isnull(sum(j.FQty),0) end as FQty
	from SEOrder v1 
	inner join SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
	left join(
		select FOrderBillNo,FOrderEntryID,sum(FQty) as FQty,MIN(a.FDate) as 'FDate' 
		from ICStockBill a 
		left join ICStockBillEntry b on a.FInterID=b.FInterID 
		where a.FTranType=21 AND a.FCancellation = 0 AND a.FCheckerID <>0
		group by FOrderBillNo,FOrderEntryID
	) j on v1.FBillNo=j.FOrderBillNo and u1.FEntryID=j.FOrderEntryID
	left join t_ICItem i on u1.FItemID=i.FItemID
	where v1.FStatus<>3 and u1.FMrpClosed=0 and v1.FDate>convert(char(10),dateadd(dd,-day(dateadd(month,-3,getdate()))+1,dateadd(month,-3,getdate())),120)
	and i.FNumber='05.05.1002'
	group by u1.FItemID,i.FNumber

select FOrderBillNo,FQty,b.*--,sum(FQty) as FQty,MIN(a.FDate) as 'FDate' 
		from ICStockBill a 
		left join ICStockBillEntry b on a.FInterID=b.FInterID 
		left join t_ICItem i on b.FItemID=i.FItemID
		where a.FTranType=21 AND a.FCancellation = 0 AND a.FCheckerID <>0
		and FOrderBillNo in ('SEORD006324','SEORD006398','SEORD006398','SEORD006540','SEORD006568')
		and i.FNumber = '05.05.1002'
		group by FOrderBillNo,FItemID

select count(FItemID) from t_ICItem where 1=1 and FSecInv<>0  and FDeleted=0




select u1.FItemID,case when isnull(sum(u1.FQty),0)-isnull(sum(u1.FStockQty),0)<0 then 0 else isnull(sum(u1.FQty),0)-isnull(sum(u1.FStockQty),0) end as FQty
	from SEOrder v1 
	inner join SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
	where v1.FStatus<>3 and u1.FMrpClosed=0 and v1.FDate>convert(char(10),dateadd(dd,-day(dateadd(month,-6,getdate()))+1,dateadd(month,-6,getdate())),120)
	and u1.FItemID=10573
	group by u1.FItemID

select * from t_ICItem where FNumber = '05.02.0103'



select v1.FBillNo,u1.FEntryID,u1.FItemID,u1.FQty,u1.FStockQty,u1.FQty,u1.FStockQty
	from SEOrder v1 
	inner join SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
	where v1.FStatus<>3 and u1.FMrpClosed=0 and v1.FDate>convert(char(10),dateadd(dd,-day(dateadd(month,-6,getdate()))+1,dateadd(month,-6,getdate())),120)
	and u1.FItemID=10573


select u1.FInterID,u1.FEntryID,* from SEOrder v1
inner join SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
 where FBillNO='SEORD007298'

FCancellation
