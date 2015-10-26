--drop procedure list_wwzc drop procedure list_wwzc_count

create procedure list_wwzc 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@status nvarchar(255),
@style nvarchar(255),
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
,jhrq nvarchar(255) default('')         
,jgdw nvarchar(255) default('')     
,sjsl decimal(28,2) default(0)    
,hgsl decimal(28,2) default(0)      
,jssl decimal(28,2) default(0)      
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
,jhrq nvarchar(255) default('')
,jgdw nvarchar(255) default('')
,sjsl decimal(28,2) default(0)                   
,hgsl decimal(28,2) default(0)      
,jssl decimal(28,2) default(0)      
)

Insert Into #temp(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,sjsl,hgsl,jssl
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,v1.FInterID,u1.FEntryID,v1.FBillNo,
u1.FICMOBillNo as FSourceBillNo,convert(char(10),v1.FBillDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FTranOutQty as 'fssl',u1.FBatchNo as 'wlph',convert(char(10),u1.FFetchDate,120) as 'jhrq',t4.FName as 'jgdw',isnull(w.FQty,0) as 'sjsl',u1.FQualifiedQty as 'hgsl',u1.FReceiptQty as 'jssl'
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (select FSourceInterID,FSourceEntryID,sum(FQty) as FQty from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID) w on w.FSourceInterID=u1.FInterID and w.FSourceEntryID=u1.FEntryID
where 1=1 
AND v1.FBillDate>=@begindate AND  v1.FBillDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,sjsl,hgsl,jssl)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,sjsl,hgsl,jssl)select * from #temp order by '+ @orderby +' '+ @ordertype)

Insert Into  #Data(FStatus,fssl) 
Select '合计',sum(u1.FTranOutQty) as 'fssl' 
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (select FSourceInterID,FSourceEntryID,sum(FQty) as FQty from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID) w on w.FSourceInterID=u1.FInterID and w.FSourceEntryID=u1.FEntryID
where 1=1 
AND v1.FBillDate>=@begindate AND  v1.FBillDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'

if @style=1 
select * from #Data where fssl>sjsl
else
select * from #Data
 
end

--count--
create procedure list_wwzc_count 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@status nvarchar(255),
@style nvarchar(255),
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
,jhrq nvarchar(255) default('')         
,jgdw nvarchar(255) default('')     
,sjsl decimal(28,2) default(0)    
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
,jhrq nvarchar(255) default('')
,jgdw nvarchar(255) default('')
,sjsl decimal(28,2) default(0)                   
)

Insert Into #temp(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,sjsl
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,v1.FInterID,u1.FEntryID,v1.FBillNo,
u1.FICMOBillNo as FSourceBillNo,convert(char(10),v1.FBillDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FTranOutQty as 'fssl',u1.FBatchNo as 'wlph',u1.FFetchDate as 'jhrq',t4.FName as 'jgdw',isnull(w.FQty,0) as 'sjsl'
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (select FSourceInterID,FSourceEntryID,sum(FQty) as FQty from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID) w on w.FSourceInterID=u1.FInterID and w.FSourceEntryID=u1.FEntryID
where 1=1 
AND v1.FBillDate>=@begindate AND  v1.FBillDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,sjsl)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,sjsl)select * from #temp order by '+ @orderby +' '+ @ordertype)

Insert Into  #Data(FStatus,fssl)
Select '合计',sum(u1.FTranOutQty) as 'fssl'
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (select FSourceInterID,FSourceEntryID,sum(FQty) as FQty from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID) w on w.FSourceInterID=u1.FInterID and w.FSourceEntryID=u1.FEntryID
where 1=1 
AND v1.FBillDate>=@begindate AND  v1.FBillDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'

if @style=1 
select count(*) from #Data where fssl>sjsl
else
select count(*) from #Data 

end



execute list_wwzc '','2013-07-01','2013-12-31','1','0','null',''

execute list_wwzc_count '','2011-08-01','2011-08-31','','null',''


execute list_wwzc_count 'WORK011866','2000-01-01','2099-12-31','','null','null'


select * from ICShop_SubcOutEntry

select * from ICStockBillEntry where FInterID in (1780,1782)

select * from ICShop_SubcOutEntry

select * from rss.dbo.wwzc_wwjysqd

create table wwzc_wwjysqd (
FID int identity(1,1),
FSourceInterID int default(0),
FSourceEntryID int default(0),
FQty decimal(28,2) default(0)
)






select FOperTranOutQty,* FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo in ('WWZC003911')

UPDATE u1 set u1.FBatchNo='9C03' FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo in ('wwzc003285')

8128 

update v1 set v1.FSupplierID=8128 FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo in ('wwzc003283')

select * from t_supplier


select u1.* 
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo like '%WWZC003911%'

update u1 set u1.FOperTranOutQty=144,u1.FTranOutQty=144 FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo like '%WWZC003911%'





select * FROM ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo='WWZC004358'

update u1 set u1.FFetchDate='2015-01-16',u1.FFactTranOutDate='2015-01-16' 
FROM ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo='WWZC004358'


FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID




select u1.FTranOutQty,u1.FReceiptQty,* FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where u1.FTranOutQty < u1.FReceiptQty