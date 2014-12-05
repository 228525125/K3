--drop procedure list_wwjysqd drop procedure list_wwjysqd_count

create procedure list_wwjysqd 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')     
,jgdw nvarchar(255) default('')    
,hgsl decimal(28,2) default(0)          
,jssl decimal(28,2) default(0)   
,remark nvarchar(20) default('')           
,jyfs nvarchar(20) default('')
,zcsl decimal(28,2) default(0)           
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,jgdw nvarchar(255) default('')             
,hgsl decimal(28,2) default(0)          
,jssl decimal(28,2) default(0)           
,remark nvarchar(20) default('')           
,jyfs nvarchar(20) default('')
,zcsl decimal(28,2) default(0)           
)

Insert Into #temp(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jgdw,hgsl,jssl,remark,jyfs,zcsl
)
Select top 20000 'Y' as FStatus,v1.FInterID,u1.FEntryID,w.FID,
v1.FBillNo as FSourceBillNo,convert(char(10),w.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
w.FQty as 'fssl',u1.FBatchNo as 'wlph',t4.FName as 'jgdw',u1.FQualifiedQty as 'hgsl',u1.FReceiptQty as 'jssl',w.remark,jyfs,u1.FTranOutQty as 'zcsl'
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID 
INNER JOIN rss.dbo.wwzc_wwjysqd w on u1.FInterID=w.FSourceInterID and u1.FEntryID=w.FSourceEntryID 
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND w.FDate>=@begindate AND  w.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jgdw,hgsl,jssl,remark,jyfs,zcsl)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jgdw,hgsl,jssl,remark,jyfs,zcsl)select * from #temp order by '+ @orderby +' '+ @ordertype)

Insert Into  #Data(FBillNo,fssl,hgsl,jssl)
Select '合计',sum(u1.FOperTranOutQty) as 'fssl',sum(u1.FQualifiedQty) as 'hgsl',sum(u1.FReceiptQty) as 'jssl'
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
INNER JOIN rss.dbo.wwzc_wwjysqd w on u1.FInterID=w.FSourceInterID and u1.FEntryID=w.FSourceEntryID 
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND w.FDate>=@begindate AND w.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
select * from #Data 
end

--count--
create procedure list_wwjysqd_count 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')     
,jgdw nvarchar(255) default('')     
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,jgdw nvarchar(255) default('')             
)

Insert Into #temp(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jgdw
)
Select top 20000 'Y' as FStatus,v1.FInterID,u1.FEntryID,w.FID,
v1.FBillNo as FSourceBillNo,convert(char(10),w.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
w.FQty as 'fssl',u1.FBatchNo as 'wlph',t4.FName as 'jgdw'
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID 
INNER JOIN rss.dbo.wwzc_wwjysqd w on u1.FInterID=w.FSourceInterID and u1.FEntryID=w.FSourceEntryID 
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND w.FDate>=@begindate AND  w.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jgdw)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jgdw)select * from #temp order by '+ @orderby +' '+ @ordertype)

Insert Into  #Data(FStatus,fssl)
Select '合计',sum(u1.FOperTranOutQty) as 'fssl'
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
INNER JOIN rss.dbo.wwzc_wwjysqd w on u1.FInterID=w.FSourceInterID and u1.FEntryID=w.FSourceEntryID 
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND w.FDate>=@begindate AND w.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
select count(*) from #Data 
end



execute list_wwjysqd '','2013-03-22','2013-03-22','null',''

execute list_wwzc_count '','2011-08-01','2011-08-31','','null',''


execute list_wwzc_count 'WORK011866','2000-01-01','2099-12-31','','null','null'




select * from ICStockBillEntry where FInterID in (1780,1782)

select * from ICShop_SubcOutEntry

select * from rss.dbo.wwzc_wwjysqd

create table wwzc_wwjysqd (
FID int identity(1,1),
FSourceInterID int default(0),
FSourceEntryID int default(0),
FQty decimal(28,2) default(0)
)




