--drop procedure report_scxh drop procedure report_scxh_count

create procedure report_scxh 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(10)
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
,tlsl decimal(28,2) default(0)           
,llsl decimal(28,2) default(0) 
,blsl decimal(28,2) default(0)   
,bfsl decimal(28,2) default(0)          
,rksl decimal(28,2) default(0)          
,zzpsl decimal(28,2) default(0)   
,byll decimal(28,2) default(0)       --本月对应成本对象的材料领用，只限本月入库
,byrk decimal(28,2) default(0)
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

Insert Into #temp(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk
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
where v1.FTranType=24 AND v1.FCancellation = 0
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by u1.FICMOBillNo,u1.FItemID
) f on a.FBillNo=f.FICMOBillNo and c.FItemID=f.FItemID
where 1=1
--AND a.FCheckDate>=@begindate AND  a.FCheckDate<=@enddate
AND (a.FBillNo like '%'+@query+'%' or i1.FNumber like '%'+@query+'%' or i1.FName like '%'+@query+'%'
or i1.FModel like '%'+@query+'%' or a.FGMPBatchNo like '%'+@query+'%')
AND a.FStatus like '%'+@status+'%'
order by a.FBillNo

if @orderby='null'
exec('Insert Into #Data(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk)select * from #temp')
else
exec('Insert Into #Data(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FBillNo,jhsl,tlsl,llsl,rksl,byrk)
Select '合计',sum(a.FQty) as 'jhsl',sum(c.FQty) as 'tlsl',sum(c.FAuxStockQty) as 'llsl',sum(g.FQty) as 'rksl',sum(e.FQty) as 'byrk'
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
where v1.FTranType=24 AND v1.FCancellation = 0
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by u1.FICMOBillNo,u1.FItemID
) f on a.FBillNo=f.FICMOBillNo and c.FItemID=f.FItemID
where 1=1
AND (a.FBillNo like '%'+@query+'%' or i1.FNumber like '%'+@query+'%' or i1.FName like '%'+@query+'%'
or i1.FModel like '%'+@query+'%' or a.FGMPBatchNo like '%'+@query+'%')
AND a.FStatus like '%'+@status+'%'
select *,llxh=tlsl/jhsl*byrk from #Data 
end

--count--

create procedure report_scxh_count 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(10)
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
,tlsl decimal(28,2) default(0)           
,llsl decimal(28,2) default(0) 
,blsl decimal(28,2) default(0)   
,bfsl decimal(28,2) default(0)          
,rksl decimal(28,2) default(0)          
,zzpsl decimal(28,2) default(0)   
,byll decimal(28,2) default(0)
,byrk decimal(28,2) default(0)
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

Insert Into #temp(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk
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
where v1.FTranType=24 AND v1.FCancellation = 0
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by u1.FICMOBillNo,u1.FItemID
) f on a.FBillNo=f.FICMOBillNo and c.FItemID=f.FItemID
where 1=1
--AND a.FCheckDate>=@begindate AND  a.FCheckDate<=@enddate
AND (a.FBillNo like '%'+@query+'%' or i1.FNumber like '%'+@query+'%' or i1.FName like '%'+@query+'%'
or i1.FModel like '%'+@query+'%' or a.FGMPBatchNo like '%'+@query+'%')
AND a.FStatus like '%'+@status+'%'
order by a.FBillNo

if @orderby='null'
exec('Insert Into #Data(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk)select * from #temp')
else
exec('Insert Into #Data(FBillNo,FDate,FStatus,cpdm,cpmc,cpgg,cpth,cpdw,cpph,jhsl,wldm,wlmc,wlgg,wldw,tlsl,llsl,blsl,bfsl,rksl,zzpsl,byll,byrk)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FBillNo,jhsl,tlsl,llsl,rksl,byrk)
Select '合计',sum(a.FQty) as 'jhsl',sum(c.FQty) as 'tlsl',sum(c.FAuxStockQty) as 'llsl',sum(g.FQty) as 'rksl',sum(e.FQty) as 'byrk'
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
where v1.FTranType=24 AND v1.FCancellation = 0
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by u1.FICMOBillNo,u1.FItemID
) f on a.FBillNo=f.FICMOBillNo and c.FItemID=f.FItemID
where 1=1
AND (a.FBillNo like '%'+@query+'%' or i1.FNumber like '%'+@query+'%' or i1.FName like '%'+@query+'%'
or i1.FModel like '%'+@query+'%' or a.FGMPBatchNo like '%'+@query+'%')
AND a.FStatus like '%'+@status+'%'
select count(*) from #Data 
end


execute report_scxh '','2013-01-01','2013-06-30','1','null','' 




select * from ICStockBillEntry

select * from ICMO 




