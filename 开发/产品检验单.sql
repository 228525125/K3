--drop procedure list_cpjyd drop procedure list_cpjyd_count

create procedure list_cpjyd 
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
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceInterID nvarchar(20) default('')
,FSourceEntryID nvarchar(20) default('')
,FICMOInterID nvarchar(20) default('')
,FICOMBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,bjsl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)    
,bhgsl decimal(28,2) default(0)                
,wlph nvarchar(20) default('')   
,jyjg nvarchar(20) default('')
,gfsl decimal(28,2) default(0)                          
,lfsl decimal(28,2) default(0)                
)

create table #Data(
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceInterID nvarchar(20) default('')
,FSourceEntryID nvarchar(20) default('')
,FICMOInterID nvarchar(20) default('')
,FICOMBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,bjsl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)          
,bhgsl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,jyjg nvarchar(20) default('')
,gfsl decimal(28,2) default(0)                          
,lfsl decimal(28,2) default(0)                
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg,gfsl,lfsl
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end  as FCheck,'' as FCloseStatus, 
'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation, 
v1.FInStockInterID as FSourceInterID,v1.FSerialID as FSourceEntryID,q1.FICMOInterID,o.FBillNo as FICOMBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
v1.FSendUpQty as 'bjsl',v1.FPassQty as 'hgsl',v1.FNotPassQty as 'bhgsl',v1.FBatchNo as 'wlph',case when v1.FResult=286 then '合格' when v1.FResult=13556 then '保留' else '不合格' end as 'jyjg',FForOpScrapQty as 'gfsl',FForMatScrapQty as 'lfsl'
from ICQCBill v1 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN QMICMOCKRequestEntry q on v1.FInStockInterID=q.FInterID and v1.FSerialID=q.FEntryID
LEFT JOIN QMICMOCKRequest q1 on q.FInterID=q1.FInterID
LEFT JOIN ICMO o on q1.FICMOInterID=o.FInterID
where 1=1 
AND (v1.FTranType=713 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or v1.FBatchNo like '%'+@query+'%' 
or o.FBillNo = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg,gfsl,lfsl)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg,gfsl,lfsl)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,hgsl)
Select '合计',sum(v1.FPassQty) as 'hgsl'
from ICQCBill v1 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN QMICMOCKRequestEntry q on v1.FInStockInterID=q.FInterID and v1.FSerialID=q.FEntryID
LEFT JOIN QMICMOCKRequest q1 on q.FInterID=q1.FInterID
LEFT JOIN ICMO o on q1.FICMOInterID=o.FInterID
where 1=1 
AND (v1.FTranType=713 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or v1.FBatchNo like '%'+@query+'%' 
or o.FBillNo = @query)
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--
create procedure list_cpjyd_count 
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
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceInterID nvarchar(20) default('')
,FSourceEntryID nvarchar(20) default('')
,FICMOInterID nvarchar(20) default('')
,FICOMBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,bjsl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)    
,bhgsl decimal(28,2) default(0)                
,wlph nvarchar(20) default('')   
,jyjg nvarchar(20) default('')         
,gfsl decimal(28,2) default(0)                          
,lfsl decimal(28,2) default(0)                 
)

create table #Data(
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceInterID nvarchar(20) default('')
,FSourceEntryID nvarchar(20) default('')
,FICMOInterID nvarchar(20) default('')
,FICOMBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,bjsl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)          
,bhgsl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,jyjg nvarchar(20) default('')  
,gfsl decimal(28,2) default(0)                          
,lfsl decimal(28,2) default(0)                
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg,gfsl,lfsl
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end  as FCheck,'' as FCloseStatus, 
'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation, 
v1.FInStockInterID as FSourceInterID,v1.FSerialID as FSourceEntryID,q1.FICMOInterID,o.FBillNo as FICOMBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
v1.FSendUpQty as 'bjsl',v1.FPassQty as 'hgsl',v1.FNotPassQty as 'bhgsl',v1.FBatchNo as 'wlph',case when v1.FResult=286 then '合格' else '不合格' end as 'jyjg',FForOpScrapQty as 'gfsl',FForMatScrapQty as 'lfsl'
from ICQCBill v1 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN QMICMOCKRequestEntry q on v1.FInStockInterID=q.FInterID and v1.FSerialID=q.FEntryID
LEFT JOIN QMICMOCKRequest q1 on q.FInterID=q1.FInterID
LEFT JOIN ICMO o on q1.FICMOInterID=o.FInterID
where 1=1 
AND (v1.FTranType=713 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or v1.FBatchNo like '%'+@query+'%' 
or o.FBillNo = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg,gfsl,lfsl)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg,gfsl,lfsl)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,hgsl)
Select '合计',sum(v1.FPassQty) as 'hgsl'
from ICQCBill v1 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN QMICMOCKRequestEntry q on v1.FInStockInterID=q.FInterID and v1.FSerialID=q.FEntryID
LEFT JOIN QMICMOCKRequest q1 on q.FInterID=q1.FInterID
LEFT JOIN ICMO o on q1.FICMOInterID=o.FInterID
where 1=1 
AND (v1.FTranType=713 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or v1.FBatchNo like '%'+@query+'%' 
or o.FBillNo = @query)
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end

execute list_cpjyd '','2011-11-01','2011-11-30','','null','null'

execute list_cpjyd_count '','2011-11-01','2011-11-30','','null','null'

execute list_cpjyd 'WORK009972','2000-01-01','2099-12-31','','null','null'

select * from ICQCBillEntry where FBillNo='FQC011970'



update v1 set v1.FAuxCommitQty=0
from ICQCBill v1 
LEFT JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FSourceInterID
LEFT JOIN t_item i on i.FItemID=v1.FItemID
where 1=1 AND  v1.FCancellation = 0 
AND u1.FSourceInterID is null 
and v1.FAuxCommitQty>0

select i.FName,v1.FAuxCommitQty,u1.FSourceInterID,v1.* 
from ICQCBill v1 
LEFT JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FSourceInterID
LEFT JOIN t_item i on i.FItemID=v1.FItemID
where 1=1 AND  v1.FCancellation = 0 
--AND u1.FSourceInterID is null 
--and v1.FAuxCommitQty>0
and v1.FDate>'2011-12-01'



select V1.* from ICStockBill v1 
LEFT JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1 AND v1.FTranType=2 AND  v1.FCancellation = 0
AND FHeadSelfD0132 is not null


select * 
from ICQCBill a
left join ICQCBillEntry b on a.FInterID=b.FInterID and b.FInterID>0
LEFT JOIN t_ICItem i on i.FItemID=a.FItemID
LEFT JOIN ICQCScheme c on i.FInspectionProject = c.FInterID and i.FInspectionProject>0
left join ICQCSchemeEntry d on c.FInterID=d.FInterID and b.FEntryID=d.FEntryID
where 1=1
and i.FNumber in ('06.04.0046','05.04.0052','05.04.0054','05.04.0053','05.04.0076','06.04.0052','05.04.0101')
--and a.FBillNo='FQC020836'

UPDATE b set b.FEntrySelfT1448 = d.FEntrySelfQCS26 
from ICQCBill a
left join ICQCBillEntry b on a.FInterID=b.FInterID and b.FInterID>0
LEFT JOIN t_ICItem i on i.FItemID=a.FItemID
LEFT JOIN ICQCScheme c on i.FInspectionProject = c.FInterID and i.FInspectionProject>0
left join ICQCSchemeEntry d on c.FInterID=d.FInterID and b.FEntryID=d.FEntryID
where 1=1
and a.FBillNo='FQC035063'

select a.FBillNo,i.FNumber,i.FName,i.FModel,i.FHelpCode,c.FBillNo,a.FSendUpQty from ICQCBill a
left join ICQCBillEntry b on a.FInterID=b.FInterID and b.FInterID>0
left join ICMO c on a.FICMOInterID=c.FInterID
left join t_ICItem i on a.FItemID=i.FItemID
where 1=1
and a.FBillNo in ('FQC034054','FQC034195')
and a.FResult = 13556
and FOrgBillID =0
and c.FStatus=1
and a.FTranType=713




select FInspectionProject from t_ICItem 

select a.* from ICQCBill a
left join ICQCBillEntry b on a.FInterID=b.FInterID and b.FInterID>0
left join ICMO c on a.FICMOInterID=c.FInterID
where a.FBillNo in ('FQC045284')

update a set a.FCommitQty=0,a.FAuxCommitQty=0 from ICQCBill a
left join ICQCBillEntry b on a.FInterID=b.FInterID and b.FInterID>0
left join ICMO c on a.FICMOInterID=c.FInterID
where a.FBillNo in ('FQC045284')



select a.FHeadSelfT1466,d.FHeadSelfQCS26,b.FEntrySelfT1449,c.FEntrySelfQCS27 
from ICQCBill a
left join ICQCBillEntry b on a.FInterID=b.FInterID and b.FInterID>0
left join ICQCSchemeEntry c on a.FSCBillInterID=c.FInterID and b.FEntryID=c.FEntryID
left join ICQCScheme d on a.FSCBillInterID=d.FInterID
where a.FBillNo in ('FQC045286')

------a.FHeadSelfT1466 : 说明

update b set b.FEntrySelfT1449=0 from ICQCBill a
left join ICQCBillEntry b on a.FInterID=b.FInterID and b.FInterID>0
left join ICMO c on a.FICMOInterID=c.FInterID
where a.FBillNo in ('FQC045284')


select b.* from ICQCScheme a 
left join ICQCSchemeEntry b on a.FInterID=b.FInterID
where 1=1
and a.FInterID=1647



select * from ICQCBill where FBillNo in ('FQC050253')

update ICQCBill set FCheckerID=0,FStatus=0 where FBillNo in ('FQC050253')




select V1.* from ICQCBill v1 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID 
where 1=1
and (i.FNumber='05.01.0033' or 
i.FNumber='05.01.0035' or 
i.FNumber='05.01.0037' or 
i.FNumber='05.04.0052')



select v1.* from ICQCBill v1 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID 
where 1=1
and v1.FBillNo in ('FQC047538','FQC047539')
