--drop procedure list_xsdd_wdj drop procedure list_xsdd_wdj_count

create procedure list_xsdd_wdj 
@query varchar(100),
@begindate varchar(10),
@enddate varchar(10),
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
,hsdj decimal(28,2) default(0)
,jhrq nvarchar(20) default('')
,cpdm nvarchar(20) default('')
,hywgb nvarchar(20) default('')
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
,hsdj decimal(28,2) default(0)
,jhrq nvarchar(20) default('')
,cpdm nvarchar(20) default('')
,hywgb nvarchar(20) default('')
)

Insert Into #temp(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,hsdj,jhrq,cpdm,hywgb
)
Select top 2000 v1.FTranType as FTranType,v1.FInterID as FInterID,u1.FEntryID as FEntryID,case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,Convert(char(10),v1.Fdate,120) as Fdate,v1.FBillNo as FBillNo,Convert(char(10),v1.FChangeDate,120) as 
FChangeDate,v1.FVersionNo as FVersionNo,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,t4.FNumber as 'dwdm',t4.FName as 'wldw',FChangeDate as 'bgrq',FChangeCauses as 'bgyy',
u.FDescription as 'bgr',us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',
u1.FPriceDiscount as 'hsdj',Convert(char(10),u1.FDate,120) as 'jhrq',i.FNumber as 'cpdm',
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb'
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT OUTER JOIN t_Organization t4 ON  v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_user u ON u.FUserID=v1.FChangeUser
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
left join t_ICItemBase b on i.FItemID=b.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND (v1.FChangeMark=0 
AND ( Isnull(v1.FClassTypeID,0)<>1007100) 
AND ((v1.FDate>=@begindate AND  v1.FDate<=@enddate) AND  v1.FCancellation = 0)) 
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or u.FDescription like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or u1.FPriceDiscount like '%'+@query+'%' or u1.FAllAmount like '%'+@query+'%' or i.FNumber like '%'+@query+'%' 
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query) 
AND v1.FStatus > 0
AND u1.FPriceDiscount=0
order by v1.FBillNo 

if @orderby='null'
exec('Insert Into #Data(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,hsdj,jhrq,cpdm,hywgb)select * from #temp')
else
exec('Insert Into #Data(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,hsdj,jhrq,cpdm,hywgb)select * from #temp order by '+ @orderby+' '+ @ordertype)

select * from #Data
end

--------------count------------
create procedure list_xsdd_wdj_count 
@query varchar(100),
@begindate varchar(10),
@enddate varchar(10),
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
,hsdj decimal(28,2) default(0)
,jhrq nvarchar(20) default('')
,cpdm nvarchar(20) default('')
,hywgb nvarchar(20) default('')
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
,hsdj decimal(28,2) default(0)
,jhrq nvarchar(20) default('')
,cpdm nvarchar(20) default('')
,hywgb nvarchar(20) default('')
)

Insert Into #temp(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,hsdj,jhrq,cpdm,hywgb
)
Select top 2000 v1.FTranType as FTranType,v1.FInterID as FInterID,u1.FEntryID as FEntryID,case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,Convert(char(10),v1.Fdate,120) as Fdate,v1.FBillNo as FBillNo,Convert(char(10),v1.FChangeDate,120) as 
FChangeDate,v1.FVersionNo as FVersionNo,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,t4.FNumber as 'dwdm',t4.FName as 'wldw',FChangeDate as 'bgrq',FChangeCauses as 'bgyy',
u.FDescription as 'bgr',us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',
u1.FPriceDiscount as 'hsdj',Convert(char(10),u1.FDate,120) as 'jhrq',i.FNumber as 'cpdm',
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb'
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT OUTER JOIN t_Organization t4 ON  v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_user u ON u.FUserID=v1.FChangeUser
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
left join t_ICItemBase b on i.FItemID=b.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND (v1.FChangeMark=0 
AND ( Isnull(v1.FClassTypeID,0)<>1007100) 
AND ((v1.FDate>=@begindate AND  v1.FDate<=@enddate) AND  v1.FCancellation = 0)) 
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or u.FDescription like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or u1.FPriceDiscount like '%'+@query+'%' or u1.FAllAmount like '%'+@query+'%' or i.FNumber like '%'+@query+'%' 
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query) 
AND v1.FStatus > 0
AND u1.FPriceDiscount=0
order by v1.FBillNo 

if @orderby='null'
exec('Insert Into #Data(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,hsdj,jhrq,cpdm,hywgb)select * from #temp')
else
exec('Insert Into #Data(FTranType,FInterID,FEntryID,FCheck,FCloseStatus,Fdate,FBillNo,FChangeDate,FVersionNo,FCancellation,dwdm,wldw,bgrq,bgyy,bgr,ywy,cpmc,cpgg,jldw,fssl,hsdj,jhrq,cpdm,hywgb)select * from #temp order by '+ @orderby+' '+ @ordertype)

select count(*) from #Data
end

execute list_xsdd_wdj '','2012-01-01','2012-01-31','null',''

execute list_xsdd_wdj_count '','2012-01-01','2012-01-31','null',''
