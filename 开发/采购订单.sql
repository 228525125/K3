--drop procedure list_cgdd drop procedure list_cgdd_count

create procedure list_cgdd 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FSourceInterID nvarchar(255) default('')
,FSourceEntryID nvarchar(255) default('')
,FEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)      
,hsdj decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)    
,dhrq nvarchar(255) default('')     
,ywy nvarchar(255) default('')       
,gys nvarchar(255) default('')       
,sjsl decimal(28,2) default(0)                  
,shsl decimal(28,2) default(0)          
,jysl decimal(28,2) default(0)          
,rksl decimal(28,2) default(0)
,sjdhrq nvarchar(255) default('')        
)

create table #Data(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FSourceInterID nvarchar(255) default('')
,FSourceEntryID nvarchar(255) default('')
,FEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)      
,hsdj decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)    
,dhrq nvarchar(255) default('')     
,ywy nvarchar(255) default('')       
,gys nvarchar(255) default('')       
,sjsl decimal(28,2) default(0)                  
,shsl decimal(28,2) default(0)          
,jysl decimal(28,2) default(0)          
,rksl decimal(28,2) default(0)    
,sjdhrq nvarchar(255) default('')        
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FSourceInterID,FSourceEntryID,FEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,hsdj,hsje,dhrq,ywy,gys,sjsl,shsl,jysl,rksl,sjdhrq
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FSourceInterID,FSourceEntryID,u1.FEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FPriceDiscount as 'hsdj',u1.FAllAmount as 'hsje',convert(char(10),u1.FDate,120) as 'dhrq',us.FDescription as 'ywy',s.FName as 'gys',
isnull(j.FQty,0) as 'sjsl',isnull(k.FQty,0) as 'shsl',isnull(l.FQty,0) as 'jysl',isnull(m.FQty,0) as 'rksl',
case when j.FDate is not null then isnull(convert(char(10),j.FDate,120),'') else isnull(convert(char(10),k.FDate,120),'') end as 'sjdhrq'  
from POOrder v1 
INNER JOIN POOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',MIN(v1.FDate) as 'FDate' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0)) and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',MIN(v1.FDate) as 'FDate'  
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) k on u1.FInterID=k.FOrderInterID and u1.FEntryID=k.FOrderEntryID
LEFT JOIN (
select b.FOrderInterID,b.FOrderEntryID,sum(a.FPassQty) as 'FQty' 
from ICQCBill a 
left join POInstockEntry b on a.FInStockInterID=b.FInterID and a.FSerialID=b.FEntryID
where 1=1 
AND (a.FTranType=711 AND (a.FCancellation = 0)) AND a.FCheckerID>0
group by b.FOrderInterID,b.FOrderEntryID
) l on u1.FInterID=l.FOrderInterID and u1.FEntryID=l.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=1 AND v1.FROB=1 AND  v1.FCancellation = 0
group by u1.FOrderInterID,u1.FOrderEntryID
) m on u1.FInterID=m.FOrderInterID and u1.FEntryID=m.FOrderEntryID
where 1=1 
AND v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007101) AND v1.FCancellation = 0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or u1.FSourceBillNo like '%'+@query+'%' or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query 
or cast(u1.FSourceInterID as nvarchar(10))+cast(u1.FSourceEntryID as nvarchar(10)) = @query )
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FSourceInterID,FSourceEntryID,FEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,hsdj,hsje,dhrq,ywy,gys,sjsl,shsl,jysl,rksl,sjdhrq)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FSourceInterID,FSourceEntryID,FEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,hsdj,hsje,dhrq,ywy,gys,sjsl,shsl,jysl,rksl,sjdhrq)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl,hsje,sjsl,shsl,jysl,rksl)
Select '合计',sum(u1.FQty) as 'fssl',sum(u1.FAllAmount) as 'hsje',sum(j.FQty) as 'sjsl',sum(k.FQty) as 'shsl',sum(l.FQty) as 'jysl',sum(m.FQty) as 'rksl'
from POOrder v1 
INNER JOIN POOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0)) and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty'  
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) k on u1.FInterID=k.FOrderInterID and u1.FEntryID=k.FOrderEntryID
LEFT JOIN (
select b.FOrderInterID,b.FOrderEntryID,sum(a.FPassQty) as 'FQty' 
from ICQCBill a 
left join POInstockEntry b on a.FInStockInterID=b.FInterID and a.FSerialID=b.FEntryID
where 1=1 
AND (a.FTranType=711 AND (a.FCancellation = 0)) AND a.FCheckerID>0
group by b.FOrderInterID,b.FOrderEntryID
) l on u1.FInterID=l.FOrderInterID and u1.FEntryID=l.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=1 AND v1.FROB=1 AND  v1.FCancellation = 0
group by u1.FOrderInterID,u1.FOrderEntryID
) m on u1.FInterID=m.FOrderInterID and u1.FEntryID=m.FOrderEntryID
where 1=1 
AND v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007101) AND v1.FCancellation = 0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or u1.FSourceBillNo like '%'+@query+'%' or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query
or cast(u1.FSourceInterID as nvarchar(10))+cast(u1.FSourceEntryID as nvarchar(10)) = @query )
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--
create procedure list_cgdd_count 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FSourceInterID nvarchar(255) default('')
,FSourceEntryID nvarchar(255) default('')
,FEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)      
,hsdj decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)    
,dhrq nvarchar(255) default('')     
,ywy nvarchar(255) default('')       
,gys nvarchar(255) default('')       
,sjsl decimal(28,2) default(0)                  
,shsl decimal(28,2) default(0)          
,jysl decimal(28,2) default(0)          
,rksl decimal(28,2) default(0)
)

create table #Data(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FSourceInterID nvarchar(255) default('')
,FSourceEntryID nvarchar(255) default('')
,FEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)      
,hsdj decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)    
,dhrq nvarchar(255) default('')     
,ywy nvarchar(255) default('')       
,gys nvarchar(255) default('')       
,sjsl decimal(28,2) default(0)                  
,shsl decimal(28,2) default(0)          
,jysl decimal(28,2) default(0)          
,rksl decimal(28,2) default(0)     
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FSourceInterID,FSourceEntryID,FEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,hsdj,hsje,dhrq,ywy,gys,sjsl,shsl,jysl,rksl
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FSourceInterID,FSourceEntryID,u1.FEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FPriceDiscount as 'hsdj',u1.FAllAmount as 'hsje',convert(char(10),u1.FDate,120) as 'dhrq',us.FDescription as 'ywy',s.FName as 'gys',
isnull(j.FQty,0) as 'sjsl',isnull(k.FQty,0) as 'shsl',isnull(l.FQty,0) as 'jysl',isnull(m.FQty,0) as 'rksl' 
from POOrder v1 
INNER JOIN POOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0)) and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty'  
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) k on u1.FInterID=k.FOrderInterID and u1.FEntryID=k.FOrderEntryID
LEFT JOIN (
select b.FOrderInterID,b.FOrderEntryID,sum(a.FPassQty) as 'FQty' 
from ICQCBill a 
left join POInstockEntry b on a.FInStockInterID=b.FInterID and a.FSerialID=b.FEntryID
where 1=1 
AND (a.FTranType=711 AND (a.FCancellation = 0)) AND a.FCheckerID>0
group by b.FOrderInterID,b.FOrderEntryID
) l on u1.FInterID=l.FOrderInterID and u1.FEntryID=l.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=1 AND v1.FROB=1 AND  v1.FCancellation = 0
group by u1.FOrderInterID,u1.FOrderEntryID
) m on u1.FInterID=m.FOrderInterID and u1.FEntryID=m.FOrderEntryID
where 1=1 
AND v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007101) AND v1.FCancellation = 0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or u1.FSourceBillNo like '%'+@query+'%' or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query 
or cast(u1.FSourceInterID as nvarchar(10))+cast(u1.FSourceEntryID as nvarchar(10)) = @query )
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FSourceInterID,FSourceEntryID,FEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,hsdj,hsje,dhrq,ywy,gys,sjsl,shsl,jysl,rksl)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FSourceInterID,FSourceEntryID,FEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,hsdj,hsje,dhrq,ywy,gys,sjsl,shsl,jysl,rksl)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl,hsje,sjsl,shsl,jysl,rksl)
Select '合计',sum(u1.FQty) as 'fssl',sum(u1.FAllAmount) as 'hsje',sum(j.FQty) as 'sjsl',sum(k.FQty) as 'shsl',sum(l.FQty) as 'jysl',sum(m.FQty) as 'rksl'
from POOrder v1 
INNER JOIN POOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0)) and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty'  
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) k on u1.FInterID=k.FOrderInterID and u1.FEntryID=k.FOrderEntryID
LEFT JOIN (
select b.FOrderInterID,b.FOrderEntryID,sum(a.FPassQty) as 'FQty' 
from ICQCBill a 
left join POInstockEntry b on a.FInStockInterID=b.FInterID and a.FSerialID=b.FEntryID
where 1=1 
AND (a.FTranType=711 AND (a.FCancellation = 0)) AND a.FCheckerID>0
group by b.FOrderInterID,b.FOrderEntryID
) l on u1.FInterID=l.FOrderInterID and u1.FEntryID=l.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=1 AND v1.FROB=1 AND  v1.FCancellation = 0
group by u1.FOrderInterID,u1.FOrderEntryID
) m on u1.FInterID=m.FOrderInterID and u1.FEntryID=m.FOrderEntryID
where 1=1 
AND v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007101) AND v1.FCancellation = 0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or u1.FSourceBillNo like '%'+@query+'%' or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query
or cast(u1.FSourceInterID as nvarchar(10))+cast(u1.FSourceEntryID as nvarchar(10)) = @query )
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end

execute list_cgdd '','2011-08-01','2011-08-31','','null',''


select * from POOrderEntry

select * from t_Supplier

select * from supply


select * from POOrder where FBillNo='JH-1302-70'

select * from POOrder where FBillNo='JH-1303-52'



update POOrder set FBillNo='JH-1303-52' where FBillNo='JH-1302-70'




