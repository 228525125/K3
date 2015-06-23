--drop procedure list_wwjy drop procedure list_wwjy_count

create procedure list_wwjy 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@status nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,sjsl decimal(28,2) default(0)          
,jysl decimal(28,2) default(0)
,hgsl decimal(28,2) default(0)
,bhgsl decimal(28,2) default(0)
,gfsl decimal(28,2) default(0)
,lfsl decimal(28,2) default(0)
,jssl decimal(28,2) default(0)
,wlph nvarchar(20) default('')
,jgdw nvarchar(20) default('')
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,sjsl decimal(28,2) default(0)          
,jysl decimal(28,2) default(0)
,hgsl decimal(28,2) default(0)
,bhgsl decimal(28,2) default(0)
,gfsl decimal(28,2) default(0)
,lfsl decimal(28,2) default(0)
,jssl decimal(28,2) default(0)
,wlph nvarchar(20) default('')
,jgdw nvarchar(20) default('')
)

Insert Into #temp(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,sjsl,jysl,hgsl,bhgsl,gfsl,lfsl,jssl,wlph,jgdw
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,v1.FInterID,v1.FBillNo,
o.FBillNo as FSourceBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
v1.FSendUpQty as 'sjsl',v1.FCheckQty as 'jysl',v1.FPassQty as 'hgsl',v1.FNotPassQty as 'bhgsl',v1.FForOpScrapQty as 'gfsl',v1.FForMatScrapQty as 'lfsl',v1.FReceiptQty as 'jssl',v1.FBatchNo as 'wlph',t4.FName as 'jgdw'
FROM ICQCBill v1 
LEFT JOIN t_supplier t4 ON v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN ICMO o ON v1.FICMOInterID=o.FInterID
where 1=1 
AND (v1.FTranType=715 AND v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or o.FBillNo like '%'+ @query +'%' or v1.FSHSubcOutInterID like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or v1.FBatchNo like '%'+@query+'%' or v1.FICMOInterID like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,sjsl,jysl,hgsl,bhgsl,gfsl,lfsl,jssl,wlph,jgdw)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,sjsl,jysl,hgsl,bhgsl,gfsl,lfsl,jssl,wlph,jgdw)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,hgsl)
Select '合计',sum(v1.FPassQty) as 'hgsl'
FROM ICQCBill v1 
LEFT JOIN t_supplier t4 ON v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN ICMO o ON v1.FICMOInterID=o.FInterID
where 1=1 
AND (v1.FTranType=715 AND v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or o.FBillNo like '%'+ @query +'%' or v1.FSHSubcOutInterID like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or v1.FBatchNo like '%'+@query+'%' or v1.FICMOInterID like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--
create procedure list_wwjy_count 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@status nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,sjsl decimal(28,2) default(0)          
,jysl decimal(28,2) default(0)
,hgsl decimal(28,2) default(0)
,bhgsl decimal(28,2) default(0)
,gfsl decimal(28,2) default(0)
,lfsl decimal(28,2) default(0)
,jssl decimal(28,2) default(0)
,wlph nvarchar(20) default('')
,jgdw nvarchar(20) default('')
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,sjsl decimal(28,2) default(0)          
,jysl decimal(28,2) default(0)
,hgsl decimal(28,2) default(0)
,bhgsl decimal(28,2) default(0)
,gfsl decimal(28,2) default(0)
,lfsl decimal(28,2) default(0)
,jssl decimal(28,2) default(0)
,wlph nvarchar(20) default('')
,jgdw nvarchar(20) default('')
)

Insert Into #temp(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,sjsl,jysl,hgsl,bhgsl,gfsl,lfsl,jssl,wlph,jgdw
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,v1.FInterID,v1.FBillNo,
o.FBillNo as FSourceBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
v1.FSendUpQty as 'sjsl',v1.FCheckQty as 'jysl',v1.FPassQty as 'hgsl',v1.FNotPassQty as 'bhgsl',v1.FForOpScrapQty as 'gfsl',v1.FForMatScrapQty as 'lfsl',v1.FReceiptQty as 'jssl',v1.FBatchNo as 'wlph',t4.FName as 'jgdw'
FROM ICQCBill v1 
LEFT JOIN t_supplier t4 ON v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN ICMO o ON v1.FICMOInterID=o.FInterID
where 1=1 
AND (v1.FTranType=715 AND v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or o.FBillNo like '%'+ @query +'%' or v1.FSHSubcOutInterID like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or v1.FBatchNo like '%'+@query+'%' or v1.FICMOInterID like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,sjsl,jysl,hgsl,bhgsl,gfsl,lfsl,jssl,wlph,jgdw)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,sjsl,jysl,hgsl,bhgsl,gfsl,lfsl,jssl,wlph,jgdw)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,hgsl)
Select '合计',sum(v1.FPassQty) as 'hgsl'
FROM ICQCBill v1 
LEFT JOIN t_supplier t4 ON v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN ICMO o ON v1.FICMOInterID=o.FInterID
where 1=1 
AND (v1.FTranType=715 AND v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or o.FBillNo like '%'+ @query +'%' or v1.FSHSubcOutInterID like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or v1.FBatchNo like '%'+@query+'%' or v1.FICMOInterID like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end



execute list_wwjy '','2011-08-01','2011-08-31','','null',''

execute list_wwjy_count '','2011-08-01','2011-08-31','','null',''


execute list_wwjy_count 'WORK011866','2000-01-01','2099-12-31','','null','null'




select * from ICQCBill where FBillNo='SIPQC003265'

select v1.* FROM ICQCBill v1 
--INNER JOIN ICQCBillEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
WHERE v1.FTranType=715 AND v1.FCancellation = 0 and FBillNo='SIPQC002108'


select * from rss.dbo.wwzc_wwjysqd where FSourceInterID=2502 and FSourceEntryID=2284




22717

select * FROM ICQCBill v1 
where 1=1
AND (v1.FTranType=715 AND v1.FCancellation = 0)
AND FBillNo in ('SIPQC008165')


update ICQCBill set FNote='' where 1=1 AND (FTranType=715 AND FCancellation = 0) and FBillNo='SIPQC008165'





