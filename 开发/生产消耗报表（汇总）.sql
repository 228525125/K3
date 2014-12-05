/*有成本对象，本月有完工产品的物料领用 */
--drop procedure report_scxhhz_1  drop procedure report_scxhhz_1_count

create procedure report_scxhhz_1 
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #temp(
FBillNo nvarchar(255) default('')
,FDate nvarchar(255) default('')
,FStatus nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpth nvarchar(255) default('')               
,cpdw nvarchar(255) default('')           
,cpph nvarchar(255) default('')           
,jhsl decimal(28,2) default(0)          
,wldm nvarchar(255) default('')           
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')           
,wldw nvarchar(255) default('')           
,tlsl decimal(28,2) default(0)           --本月入库产品关联任务单的全部投料
,llsl decimal(28,2) default(0)           --本月入库产品关联任务单的全部领料 
,blsl decimal(28,2) default(0)           --本月入库产品关联任务单的补料
,bfsl decimal(28,2) default(0)           --本月入库产品关联任务单的报废
,rksl decimal(28,2) default(0)           --本月入库产品关联任务单的入库产品
,zzpsl decimal(28,2) default(0)          --在制品数量
,byll decimal(28,2) default(0)           --本月入库产品关联领料
,byrk decimal(28,2) default(0)           --本月入库产品
,wldj decimal(28,2) default(0)
,fhck nvarchar(255) default('')           --发货仓库
)

create table #Data(
FBillNo nvarchar(255) default('')
,FDate nvarchar(255) default('')
,FStatus nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpth nvarchar(255) default('')               
,cpdw nvarchar(255) default('')           
,cpph nvarchar(255) default('')           
,jhsl decimal(28,2) default(0)          
,wldm nvarchar(255) default('')           
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')           
,wldw nvarchar(255) default('')           
,tlsl decimal(28,2) default(0)           
,llsl decimal(28,2) default(0)          
,blsl decimal(28,2) default(0)   
,bfsl decimal(28,2) default(0)          
,rksl decimal(28,2) default(0)          
,zzpsl decimal(28,2) default(0)       
,byll decimal(28,2) default(0)       
,byrk decimal(28,2) default(0)
,wldj decimal(28,2) default(0)
,fhck nvarchar(255) default('')           
)

create table #tmp(               --销售无税价，算产值用
       FDate nvarchar(10) null,
       FItemID nvarchar(255) null
)

insert into #tmp(FDate,FItemID
)
select Convert(char(10),max(v1.FDate),120) as FDate,u1.FItemID from ICSale v1 INNER JOIN ICSaleEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 group by u1.FItemID order by v1.FDate


Insert Into #Data(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk,wldj,fhck
)
select a.FBillNo,Convert(char(10),a.FCheckDate,120) as FDate,case when a.FStatus=0 then '计划' when a.FStatus=5 then '确认' when a.FStatus=1 then '下达' when a.FStatus=3 then '结案' else '' end as FStatus,
i1.FNumber as 'cpdm',i1.FName as 'cpmc',i1.FModel as 'cpgg',i1.FHelpCode as 'cpth',mu1.FName as 'cpdw',a.FGMPBatchNo as 'cpph',isnull(a.FQty,0) as 'jhsl', 
i2.FNumber as 'wldm',i2.FName as 'wlmc',i2.FModel as 'wlgg',mu2.FName as 'wldw',c.FAuxQtyPick as 'tlsl',isnull(c.FAuxStockQty,0) as 'llsl',isnull(c.FAuxQtySupply,0) as 'blsl',isnull(c.FDiscardAuxQty,0) as 'bfsl',isnull(g.FQty,0) as 'rksl',
isnull(c.FWIPAuxQTY,0) as 'zzpsl',isnull(f.FQty,0) as 'byll',isnull(e.FQty,0) as 'byrk',isnull(h.FPrice,0) as 'wldj',isnull(h.FName,s.FName) as 'fhck'
from ICMO a
LEFT JOIN PPBOM b ON   b.FICMOInterID = a.FInterID  AND a.FInterID<>0
LEFT JOIN PPBOMEntry c ON c.FInterID = b.FInterID  AND b.FInterID<>0 
LEFT JOIN t_ICItem i1 on a.FItemID=i1.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=a.FUnitID
LEFT JOIN t_ICItem i2 on c.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu2 on mu2.FItemID=c.FUnitID
LEFT JOIN t_stock s on c.FStockID=s.FItemID
INNER JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by u1.FICMOBillNo,u1.FItemID
) e on a.FBillNo=e.FICMOBillNo and a.FItemID=e.FItemID
INNER JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
group by u1.FICMOBillNo,u1.FItemID
) g on a.FBillNo=g.FICMOBillNo and a.FItemID=g.FItemID
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty,MAX(u1.FPrice) as FPrice,MAX(s.FName) as FName from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
LEFT JOIN t_stock s on s.FItemID=u1.FSCStockID
where v1.FTranType=24 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by u1.FICMOBillNo,u1.FItemID
) f on a.FBillNo=f.FICMOBillNo and c.FItemID=f.FItemID
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,MAX(u1.FPrice) as FPrice,MAX(s.FName) as FName from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
LEFT JOIN t_stock s on s.FItemID=u1.FSCStockID
where v1.FTranType=24 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
group by u1.FICMOBillNo,u1.FItemID
) h on a.FBillNo=h.FICMOBillNo and c.FItemID=h.FItemID
where 1=1
--AND (a.FBillNo like '%'+@query+'%' or i1.FNumber like '%'+@query+'%' or i1.FName like '%'+@query+'%'
--or i1.FModel like '%'+@query+'%' or a.FGMPBatchNo like '%'+@query+'%')
--AND a.FStatus like '%'+@status+'%'
order by a.FBillNo

/*if @orderby='null'
exec('Insert Into #Data(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk)select * from #temp')
else
exec('Insert Into #Data(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk)select * from #temp order by '+ @orderby+' '+ @ordertype)*/

create table #temp2(
cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpth nvarchar(255) default('')               
,cpdw nvarchar(255) default('')           
,byrk decimal(28,2) default(0)
)

Insert Into #temp2 (cpdm,cpmc,cpgg,cpth,cpdw,byrk)
select i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName,sum(u1.FQty) as FQty
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN ICMO a on u1.FICMOBillNo=a.FBillNo
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName

create table #temp3(
cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpth nvarchar(255) default('')                        
,jgdj decimal(28,2) default(0)           --加工费单价
,wwjgf decimal(28,2) default(0)          --本月入库产品关联任务单的外协加工费
)

Insert Into #temp3 (cpdm,cpmc,cpgg,cpth,jgdj
)
select i.FNumber,i.FName,i.FModel,i.FHelpCode,AVG(FUnitPrice) as FUnitPrice     --这里不能直接取加工费，因为会重复计算   sum(u1.FAmount)
FROM ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN ICMO a on u1.FICMOBillNo=a.FBillNo
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
INNER JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by u1.FICMOBillNo,u1.FItemID
) e on a.FBillNo=e.FICMOBillNo and a.FItemID=e.FItemID 
where 1=1
group by i.FNumber,i.FName,i.FModel,i.FHelpCode


select d1.cpdm,d1.cpmc,d1.cpgg,d1.cpth,d1.cpdw,d1.byrk,i.FPrice as 'xswsdj',llwwjgf=d1.byrk*d4.jgdj,d4.jgdj,d2.wldm,d2.wlmc,d2.wlgg,d2.wldw,d2.tlsl,d2.llsl,d2.byll,d2.blsl,d2.bfsl,d3.byxh,d2.llxh,d2.wldj,llxhje=d2.llxh*d2.wldj,d2.fhck   --byll : 本月有入库数量的产品领料 ；byxh ：本月入库产品关联本月物料领用
from #temp2 d1
LEFT JOIN (
select cpdm,wldm,wlmc,wlgg,wldw,sum(tlsl) as 'tlsl',sum(llsl) as 'llsl',sum(byll) as 'byll',sum(blsl) as 'blsl',sum(bfsl) as 'bfsl',llxh=sum(tlsl)/sum(jhsl)*sum(byrk),MAX(wldj) as 'wldj',MAX(fhck) as 'fhck'
from #Data group by cpdm,wldm,wlmc,wlgg,wldw
) d2 on d1.cpdm=d2.cpdm
LEFT JOIN (
select i2.FNumber as 'cpdm',i1.FNumber as 'wldm',sum(u1.FQty) as byxh from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
INNER JOIN cbCostObj o on u1.FCostOBJID=o.FItemID AND u1.FCostOBJID<>0
LEFT JOIN t_ICItem i1 on u1.FItemID=i1.FItemID
LEFT JOIN t_ICItem i2 on o.FStdProductID=i2.FItemID
where v1.FTranType=24 AND v1.FCancellation = 0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by i2.FNumber,i1.FNumber
) d3 on d1.cpdm=d3.cpdm and d2.wldm=d3.wldm
LEFT JOIN #temp3 d4 on d1.cpdm=d4.cpdm
LEFT JOIN (select i.FNumber,min(u1.FPrice) as FPrice,min(FTaxPrice) as FTaxPrice from ICSale v1 INNER JOIN ICSaleEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 INNER JOIN #tmp t on v1.FDate=t.FDate and u1.FItemID=t.FItemID LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID group by i.FNumber) i on d1.cpdm=i.FNumber
end

--------count--------

create procedure report_scxhhz_1_count 
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #temp(
FBillNo nvarchar(255) default('')
,FDate nvarchar(255) default('')
,FStatus nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpth nvarchar(255) default('')               
,cpdw nvarchar(255) default('')           
,cpph nvarchar(255) default('')           
,jhsl decimal(28,2) default(0)          
,wldm nvarchar(255) default('')           
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')           
,wldw nvarchar(255) default('')           
,tlsl decimal(28,2) default(0)           --本月入库产品关联任务单的全部投料
,llsl decimal(28,2) default(0)           --本月入库产品关联任务单的全部领料 
,blsl decimal(28,2) default(0)           --本月入库产品关联任务单的补料
,bfsl decimal(28,2) default(0)           --本月入库产品关联任务单的报废
,rksl decimal(28,2) default(0)           --本月入库产品关联任务单的入库产品
,zzpsl decimal(28,2) default(0)          
,byll decimal(28,2) default(0)           --本月入库产品关联领料
,byrk decimal(28,2) default(0)           --本月入库产品
)

create table #Data(
FBillNo nvarchar(255) default('')
,FDate nvarchar(255) default('')
,FStatus nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpth nvarchar(255) default('')               
,cpdw nvarchar(255) default('')           
,cpph nvarchar(255) default('')           
,jhsl decimal(28,2) default(0)          
,wldm nvarchar(255) default('')           
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')           
,wldw nvarchar(255) default('')           
,tlsl decimal(28,2) default(0)           
,llsl decimal(28,2) default(0)          
,blsl decimal(28,2) default(0)   
,bfsl decimal(28,2) default(0)          
,rksl decimal(28,2) default(0)          
,zzpsl decimal(28,2) default(0)       
,byll decimal(28,2) default(0)       
,byrk decimal(28,2) default(0)
)

Insert Into #Data(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk
)
select a.FBillNo,Convert(char(10),a.FCheckDate,120) as FDate,case when a.FStatus=0 then '计划' when a.FStatus=5 then '确认' when a.FStatus=1 then '下达' when a.FStatus=3 then '结案' else '' end as FStatus,
i1.FNumber as 'cpdm',i1.FName as 'cpmc',i1.FModel as 'cpgg',i1.FHelpCode as 'cpth',mu1.FName as 'cpdw',a.FGMPBatchNo as 'cpph',isnull(a.FQty,0) as 'jhsl', 
i2.FNumber as 'wldm',i2.FName as 'wlmc',i2.FModel as 'wlgg',mu2.FName as 'wldw',c.FAuxQtyPick as 'tlsl',isnull(c.FAuxStockQty,0) as 'llsl',isnull(c.FAuxQtySupply,0) as 'blsl',isnull(c.FDiscardAuxQty,0) as 'bfsl',isnull(g.FQty,0) as 'rksl',
isnull(c.FWIPAuxQTY,0) as 'zzpsl',isnull(f.FQty,0) as 'byll',isnull(e.FQty,0) as 'byrk'
from ICMO a
LEFT JOIN PPBOM b ON   b.FICMOInterID = a.FInterID  AND a.FInterID<>0
LEFT JOIN PPBOMEntry c ON c.FInterID = b.FInterID  AND b.FInterID<>0 
LEFT JOIN t_ICItem i1 on a.FItemID=i1.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=a.FUnitID
LEFT JOIN t_ICItem i2 on c.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu2 on mu2.FItemID=c.FUnitID
INNER JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by u1.FICMOBillNo,u1.FItemID
) e on a.FBillNo=e.FICMOBillNo and a.FItemID=e.FItemID
INNER JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
group by u1.FICMOBillNo,u1.FItemID
) g on a.FBillNo=g.FICMOBillNo and a.FItemID=g.FItemID
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=24 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by u1.FICMOBillNo,u1.FItemID
) f on a.FBillNo=f.FICMOBillNo and c.FItemID=f.FItemID
where 1=1
--AND (a.FBillNo like '%'+@query+'%' or i1.FNumber like '%'+@query+'%' or i1.FName like '%'+@query+'%'
--or i1.FModel like '%'+@query+'%' or a.FGMPBatchNo like '%'+@query+'%')
--AND a.FStatus like '%'+@status+'%'
order by a.FBillNo

/*if @orderby='null'
exec('Insert Into #Data(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk)select * from #temp')
else
exec('Insert Into #Data(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk)select * from #temp order by '+ @orderby+' '+ @ordertype)*/

create table #temp2(
cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpth nvarchar(255) default('')               
,cpdw nvarchar(255) default('')           
,byrk decimal(28,2) default(0)
)

Insert Into #temp2 (cpdm,cpmc,cpgg,cpth,cpdw,byrk)
select i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName,sum(u1.FQty) as FQty 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName

select count(d1.cpdm)--d1.cpdm,cpmc,cpgg,cpth,cpdw,byrk,d2.wldm,d2.wlmc,d2.wlgg,d2.wldw,d2.tlsl,d2.llsl,d2.byll,d2.blsl,d2.bfsl,d3.byxh,d2.llxh   --byxh ：本月入库产品关联物料领用
from #temp2 d1
LEFT JOIN (
select cpdm,wldm,wlmc,wlgg,wldw,sum(tlsl) as 'tlsl',sum(llsl) as 'llsl',sum(byll) as 'byll',sum(blsl) as 'blsl',sum(bfsl) as 'bfsl',llxh=sum(tlsl)/sum(jhsl)*sum(byrk)
from #Data group by cpdm,wldm,wlmc,wlgg,wldw
) d2 on d1.cpdm=d2.cpdm
LEFT JOIN (
select i2.FNumber as 'cpdm',i1.FNumber as 'wldm',sum(u1.FQty) as byxh from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
INNER JOIN cbCostObj o on u1.FCostOBJID=o.FItemID AND u1.FCostOBJID<>0
LEFT JOIN t_ICItem i1 on u1.FItemID=i1.FItemID
LEFT JOIN t_ICItem i2 on o.FStdProductID=i2.FItemID
where v1.FTranType=24 AND v1.FCancellation = 0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by i2.FNumber,i1.FNumber
) d3 on d1.cpdm=d3.cpdm and d2.wldm=d3.wldm
end

----------------------------------------------------------
/*有成本对象，但无完工产品的物料领用*/

--drop procedure report_scxhhz_2  drop procedure report_scxhhz_2_count

create procedure report_scxhhz_2 
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #temp(
cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpth nvarchar(255) default('')               
,cpdw nvarchar(255) default('')           
,cpph nvarchar(255) default('')           
,wldm nvarchar(255) default('')           
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')           
,wldw nvarchar(255) default('')
,byxh decimal(28,2) default(0)
)

Insert Into #temp (cpdm,cpmc,cpgg,cpth,wldm,wlmc,wlgg,wldw,byxh)
select i1.FNumber as 'cpdm',i1.FName as 'cpmc',i1.FModel as 'cpgg',i1.FHelpCode as 'cpth',i2.FNumber as 'wldm',i2.FName as 'wlmc',i2.FModel as 'wlgg',mu1.FName as 'wldw',b.FQty as 'byxh' 
from ICStockBill a 
INNER JOIN ICStockBillEntry b ON a.FInterID = b.FInterID AND b.FInterID <>0
INNER JOIN cbCostObj o on b.FCostOBJID=o.FItemID AND b.FCostOBJID<>0
LEFT JOIN t_ICItem i1 on o.FStdProductID=i1.FItemID
LEFT JOIN t_ICItem i2 on b.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=b.FUnitID
where a.FTranType=24 AND a.FCancellation = 0 AND a.FCheckerID>0 
AND a.FDate>=@begindate AND a.FDate<=@enddate
AND not exists(select u1.FItemID from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate AND o.FStdProductID=u1.FItemID
group by u1.FItemID)

select cpdm,cpmc,cpgg,cpth,wldm,wlmc,wlgg,wldw,sum(byxh) as 'byxh' from #temp group by cpdm,cpmc,cpgg,cpth,wldm,wlmc,wlgg,wldw
end

--------count--------
create procedure report_scxhhz_2_count 
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #temp(
cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpth nvarchar(255) default('')               
,cpdw nvarchar(255) default('')           
,cpph nvarchar(255) default('')           
,wldm nvarchar(255) default('')           
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')           
,wldw nvarchar(255) default('')
,byxh decimal(28,2) default(0)
)

Insert Into #temp (cpdm,cpmc,cpgg,cpth,wldm,wlmc,wlgg,wldw,byxh)
select i1.FNumber as 'cpdm',i1.FName as 'cpmc',i1.FModel as 'cpgg',i1.FHelpCode as 'cpth',i2.FNumber as 'wldm',i2.FName as 'wlmc',i2.FModel as 'wlgg',mu1.FName as 'wldw',b.FQty as 'byxh' 
from ICStockBill a 
INNER JOIN ICStockBillEntry b ON a.FInterID = b.FInterID AND b.FInterID <>0
INNER JOIN cbCostObj o on b.FCostOBJID=o.FItemID AND b.FCostOBJID<>0
LEFT JOIN t_ICItem i1 on o.FStdProductID=i1.FItemID
LEFT JOIN t_ICItem i2 on b.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=b.FUnitID
where a.FTranType=24 AND a.FCancellation = 0 AND a.FCheckerID>0 
AND a.FDate>=@begindate AND a.FDate<=@enddate
AND not exists(select u1.FItemID from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate AND o.FStdProductID=u1.FItemID
group by u1.FItemID)

create table #temp2(
cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpth nvarchar(255) default('')               
,cpdw nvarchar(255) default('')           
,cpph nvarchar(255) default('')           
,wldm nvarchar(255) default('')           
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')           
,wldw nvarchar(255) default('')
,byxh decimal(28,2) default(0)
)

Insert Into #temp2 (cpdm,cpmc,cpgg,cpth,wldm,wlmc,wlgg,wldw,byxh)
select cpdm,cpmc,cpgg,cpth,wldm,wlmc,wlgg,wldw,sum(byxh) as 'byxh' from #temp group by cpdm,cpmc,cpgg,cpth,wldm,wlmc,wlgg,wldw

select count(*) from #temp2
end

----------------------------------------------------------------------------
/*没有成本对象的物料领用*/

--drop procedure report_scxhhz_3  drop procedure report_scxhhz_3_count

create procedure report_scxhhz_3 
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #temp(
wldm nvarchar(255) default('')           
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')           
,wldw nvarchar(255) default('')
,byxh decimal(28,2) default(0)
)

Insert Into #temp (wldm,wlmc,wlgg,wldw,byxh)
select i2.FNumber as 'wldm',i2.FName as 'wlmc',i2.FModel as 'wlgg',mu1.FName as 'wldw',b.FQty as 'byxh' 
from ICStockBill a 
INNER JOIN ICStockBillEntry b ON a.FInterID = b.FInterID AND b.FInterID <>0
LEFT JOIN t_ICItem i2 on b.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=b.FUnitID
where a.FTranType=24 AND a.FCancellation = 0 AND a.FCheckerID>0 
AND a.FDate>=@begindate AND a.FDate<=@enddate
AND b.FCostOBJID=0

select wldm,wlmc,wlgg,wldw,sum(byxh) as 'byxh' from #temp group by wldm,wlmc,wlgg,wldw
end

-------count-------
create procedure report_scxhhz_3_count 
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #temp(
wldm nvarchar(255) default('')           
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')           
,wldw nvarchar(255) default('')
,byxh decimal(28,2) default(0)
)

Insert Into #temp (wldm,wlmc,wlgg,wldw,byxh)
select i2.FNumber as 'wldm',i2.FName as 'wlmc',i2.FModel as 'wlgg',mu1.FName as 'wldw',b.FQty as 'byxh' 
from ICStockBill a 
INNER JOIN ICStockBillEntry b ON a.FInterID = b.FInterID AND b.FInterID <>0
LEFT JOIN t_ICItem i2 on b.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=b.FUnitID
where a.FTranType=24 AND a.FCancellation = 0 AND a.FCheckerID>0 
AND a.FDate>=@begindate AND a.FDate<=@enddate
AND b.FCostOBJID=0

create table #temp2(
wldm nvarchar(255) default('')           
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')           
,wldw nvarchar(255) default('')
,byxh decimal(28,2) default(0)
)

Insert Into #temp2 (wldm,wlmc,wlgg,wldw,byxh)
select wldm,wlmc,wlgg,wldw,sum(byxh) as 'byxh' from #temp group by wldm,wlmc,wlgg,wldw

select count(*) from #temp2
end





execute report_scxhhz_1 '2014-02-01','2014-02-28' 

execute report_scxhhz_1_count '2012-05-01','2012-05-31'

execute report_scxhhz_2 '2012-04-01','2012-04-30'

execute report_scxhhz_2_count '2012-04-01','2012-04-30'

execute report_scxhhz_3 '2012-04-01','2012-04-30'

execute report_scxhhz_3_count '2012-04-01','2012-04-30'





Select * From ICTemplate t1,ICTransactionType t2 Where  t1.FID =t2.FTemplateID And t2.FID = 713

select * from ICTransactionType


select v1.FBillNo,i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName,u1.FQty,a.FBillNo,s.FBillNo,sub.*
--,sum(u1.FQty) as FQty
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN ICMO a on u1.FICMOBillNo=a.FBillNo
LEFT JOIN ICShop_SubcInEntry sub ON sub.FICMOBillNo=a.FBillNo
LEFT JOIN ICShop_SubcIn s on sub.FInterID=s.FInterID
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0
AND v1.FDate>='2012-05-01' AND v1.FDate<='2012-05-31'
AND i.FNumber = '05.02.2004'
--group by i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName


select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty,MAX(u1.FPrice) as FPrice,MAX(s.FName) as FName from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
LEFT JOIN t_stock s on s.FItemID=u1.FSCStockID
where v1.FTranType=24 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>='2012-08-03' AND v1.FDate<='2012-08-03'
group by u1.FICMOBillNo,u1.FItemID


select u1.* 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
LEFT JOIN t_stock s on s.FItemID=u1.FSCStockID
where v1.FTranType=24 AND v1.FCancellation = 0 AND v1.FCheckerID>0 

select * from PPBOMEntry
