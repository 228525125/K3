--drop procedure list_wgrk drop procedure list_wgrk_count

create procedure list_wgrk 
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
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')           
)

create table #Data(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')  
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,'' as FCloseStatus,'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID   AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--
create procedure list_wgrk_count 
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
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')           
)

create table #Data(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')  
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,'' as FCloseStatus,'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID   AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID   AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end

execute list_wgrk '','2014-02-01','2014-02-28','','null','null'

SELECT * from ICStockBill v1 left join ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where cast(u1.FSourceInterID as nvarchar(10))+cast(u1.FSourceEntryID as nvarchar(10)) = '29301' AND v1.FTranType=1 AND v1.FROB=1 AND  v1.FCancellation = 0

select * from POInstock where FBillNo='IQCR000606'


select * from ICStockBillEntry where FInterID=21951


select b.FSourceInterId,b.* from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where FBillNo='WIN003628'


UPDATE ICStockBillEntry SET FPrice=375/1.17,FEntrySelfA0156=375,FAuxPrice=375/1.17,FAmount=375/1.17*FQty,FEntrySelfA0157=375*FQty WHERE FInterID=43870      --修改系统单单价

UPDATE ICStockBillEntry SET FEntrySelfA0158=FEntrySelfA0156,FEntrySelfA0159=FEntrySelfA0157 WHERE FInterID=43870      --修改系统单单价

SELECT i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName,sum(u1.FQty) as FQty
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0 
AND v1.FDate>='2012-01-01' and v1.FDate<='2012-12-31'
group by i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName
order by i.FNumber


select * from ICStockBill where FBillNo like '%WIN004743%'

update ICStockBill set FEmpID=170 where FBillNo like '%WIN004743%'


select * from t_user

select * from t_emp


01.009


from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 


select i.FNumber,i.FName,i.FModel,i.FHelpCode,
case when wg.FName is null then st.FName else wg.FName end as 'gys',
wg.type,st.type
from t_ICItem i 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=i.FUnitID 
LEFT JOIN (
	Select s.FName,u1.FItemID,u1.FBatchNo,v1.FDate,u1.FQty, '外购' as type 
	from ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0  
	LEFT join t_Supplier s on v1.FSupplyID=s.FItemID 
	where 1=1 
	AND v1.FTranType=1 AND  v1.FCancellation = 0 
	AND v1.FDate>='2015-01-01' AND  v1.FDate<='2015-01-31' 
	AND v1.FStatus=1 
	--group by s.FName,u1.FItemID,u1.FBatchNo 
) wg on wg.FItemID = i.FItemID 
LEFT JOIN (
	select s.FName,u1.FItemID,u1.FBatchNo,v1.FDate,u1.FQty,'受托' as type
	from ICSTJGBill v1 
	INNER JOIN ICSTJGBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
	LEFT join t_Organization s on v1.FCustID=s.FItemID
	WHERE 1=1
	AND v1.FTranType=92 AND v1.FROB=1 AND  v1.FCancellation = 0 
	AND v1.FDate>='2015-01-01' AND v1.FDate<='2015-01-31' 
	AND v1.FStatus=1 
	--group by s.FName,u1.FItemID,u1.FBatchNo	
) st on st.FItemID=i.FItemID 
where 1=1 
and (wg.FName is not null or st.FName is not null) 
group by wg.FName,st.FName,wg.type,st.type,i.FNumber,i.FName,i.FModel,i.FHelpCode 







select * from ICSTJGBill



