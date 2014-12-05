--drop procedure list_xsfp drop procedure list_xsfp_count

create procedure list_xsfp 
@query varchar(100),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FOrderID nvarchar(20) default('')
,FSaleID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,Fdate nvarchar(200) default('')
,FBillNo nvarchar(50) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)
,wsdj decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,xxs decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)
,cpdm nvarchar(20) default('')
,hxsl decimal(28,2) default(0)
,hxje decimal(28,2) default(0)
,ddhsdj decimal(28,2) default(0)
,ddhsje decimal(28,2) default(0)  --这个不是订单金额，是发票数量*订单含税单价
)

create table #Data(
FOrderID nvarchar(20) default('')
,FSaleID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,Fdate nvarchar(200) default('')
,FBillNo nvarchar(50) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)
,wsdj decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,xxs decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)
,cpdm nvarchar(20) default('')
,hxsl decimal(28,2) default(0)
,hxje decimal(28,2) default(0)
,ddhsdj decimal(28,2) default(0)
,ddhsje decimal(28,2) default(0)
)

Insert Into #temp(FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje,ddhsdj,ddhsje
)
Select top 20000 cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) as FOrderID,cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) as FSaleID,
case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FCheck,Convert(char(10),v1.Fdate,111) as Fdate,v1.FBillNo as FBillNo,
t4.FNumber as 'dwdm',t4.FName as 'wldw',us.FDescription as 'ywy',t17.FName as 'cpmc',t17.FModel as 'cpgg',mu.FName as 'jldw',u1.FAuxQty as 'fssl',
cast(u1.FPrice as decimal(28,2)) as 'wsdj',cast(u1.FTaxPrice as decimal(28,2)) as 'hsdj',cast(u1.FTaxAmount as decimal(28,2)) as 'xxs',cast(u1.FAuxQty*u1.FTaxPrice as decimal(28,2)) as 'hsje',t17.FNumber as 'cpdm',cast(u1.FCheckQty as decimal(28,2)) as 'hxsl',cast(u1.FCheckAmount as decimal(28,2)) as 'hxje',se.FPriceDiscount as 'ddhsdj',(se.FPriceDiscount*u1.FAuxQty) as 'ddhsje'
from ICSale v1 INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_ICItem t17 ON     u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
 LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 LEFT JOIN t_user us On us.FUserID=v1.FBillerID
 LEFT JOIN SEOrderEntry se on u1.FOrderInterID=se.FInterID and u1.FOrderEntryID=se.FEntryID
 where 1=1 
AND (v1.FTranType=80 AND  v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or t17.FName like '%'+@query+'%' 
or t17.FModel like '%'+@query+'%' or u1.FAuxQty like '%'+@query+'%' or u1.FTaxPrice like '%'+@query+'%' or (u1.FAuxQty*u1.FTaxPrice) like '%'+@query+'%' or t17.FNumber like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje,ddhsdj,ddhsje)select * from #temp')
else
exec('Insert Into #Data(FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje,ddhsdj,ddhsje)select * from #temp order by '+ @orderby+' '+ @ordertype)


Insert Into  #Data(FBillNo,fssl,xxs,hsje,hxsl,hxje,ddhsje)
Select '合计',sum(u1.FAuxQty) as 'fssl',sum(u1.FTaxAmount) as 'xxs',sum(u1.FAuxQty*u1.FTaxPrice) as 'hsje',sum(u1.FCheckQty) as 'hxsl',sum(u1.FCheckAmount) as 'hxje',sum(se.FPriceDiscount*u1.FAuxQty) as 'ddhsje'
from ICSale v1 INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_ICItem t17 ON     u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
 LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 LEFT JOIN t_user us On us.FUserID=v1.FBillerID
  LEFT JOIN SEOrderEntry se on u1.FOrderInterID=se.FInterID and u1.FOrderEntryID=se.FEntryID
 where 1=1 
AND (v1.FTranType=80 AND  v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or t17.FName like '%'+@query+'%' 
or t17.FModel like '%'+@query+'%' or u1.FAuxQty like '%'+@query+'%' or u1.FTaxPrice like '%'+@query+'%' or (u1.FAuxQty*u1.FTaxPrice) like '%'+@query+'%' or t17.FNumber like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

---------count----------

create procedure list_xsfp_count 
@query varchar(100),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FOrderID nvarchar(20) default('')
,FSaleID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,Fdate nvarchar(20) default('')
,FBillNo nvarchar(50) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)
,wsdj decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,xxs decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)
,cpdm nvarchar(20) default('')
,hxsl decimal(28,2) default(0)
,hxje decimal(28,2) default(0)
)

create table #Data(
FOrderID nvarchar(20) default('')
,FSaleID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,Fdate nvarchar(20) default('')
,FBillNo nvarchar(50) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)
,wsdj decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,xxs decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)
,cpdm nvarchar(20) default('')
,hxsl decimal(28,2) default(0)
,hxje decimal(28,2) default(0)
)

Insert Into #temp(FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje
)
Select top 20000 cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) as FOrderID,cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) as FSaleID,
case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FCheck,Convert(char(10),v1.Fdate,111) as Fdate,v1.FBillNo as FBillNo,
t4.FNumber as 'dwdm',t4.FName as 'wldw',us.FDescription as 'ywy',t17.FName as 'cpmc',t17.FModel as 'cpgg',mu.FName as 'jldw',u1.FAuxQty as 'fssl',
cast(u1.FPrice as decimal(28,2)) as 'wsdj',cast(u1.FTaxPrice as decimal(28,2)) as 'hsdj',cast(u1.FTaxAmount as decimal(28,2)) as 'xxs',cast(u1.FAuxQty*u1.FTaxPrice as decimal(28,2)) as 'hsje',t17.FNumber as 'cpdm',cast(u1.FCheckQty as decimal(28,2)) as 'hxsl',cast(u1.FCheckAmount as decimal(28,2)) as 'hxje'
from ICSale v1 INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_ICItem t17 ON     u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
 LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 LEFT JOIN t_user us On us.FUserID=v1.FBillerID
 where 1=1 
AND (v1.FTranType=80 AND v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or t17.FName like '%'+@query+'%' 
or t17.FModel like '%'+@query+'%' or u1.FAuxQty like '%'+@query+'%' or u1.FTaxPrice like '%'+@query+'%' or (u1.FAuxQty*u1.FTaxPrice) like '%'+@query+'%' or t17.FNumber like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje)select * from #temp')
else
exec('Insert Into #Data(FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje)select * from #temp order by '+ @orderby+' '+ @ordertype)


Insert Into  #Data(FOrderID,fssl,xxs,hsje,hxsl,hxje)
Select '合计',sum(u1.FAuxQty) as 'fssl',sum(u1.FTaxAmount) as 'xxs',sum(u1.FAuxQty*u1.FTaxPrice) as 'hsje',sum(u1.FCheckQty) as 'hxsl',sum(u1.FCheckAmount) as 'hxje'
from ICSale v1 INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_ICItem t17 ON     u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
 LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 LEFT JOIN t_user us On us.FUserID=v1.FBillerID
 where 1=1 
AND (v1.FTranType=80 AND v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or t17.FName like '%'+@query+'%' 
or t17.FModel like '%'+@query+'%' or u1.FAuxQty like '%'+@query+'%' or u1.FTaxPrice like '%'+@query+'%' or (u1.FAuxQty*u1.FTaxPrice) like '%'+@query+'%' or t17.FNumber like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end


execute list_xsdd '34437','2011-01-01','2011-08-28','','null','desc'



select * from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID where FBillNo='XZP00000096'



execute list_xsfp '','2011-06-30','2011-08-30','','null','null'

execute list_xsfp_count '35101','2000-01-01','2099-12-31','','null','null'

execute list_xsfp '','2000-01-01','2099-12-31','','null','null'

execute list_xsfp_count '','2000-01-01','2099-12-31','','null','null'

Select top 2000 (u1.FQty-u1.FAllHookQTY) as FHookQTY,v1.FTranType as FTranType,v1.FInterID as FInterID,u1.FEntryID as FEntryID,u1.Fauxqty as Fauxqty,u1.FTaxAmount as 
FTaxAmount,case v1.FTranType when 80 then u1.FAmount+u1.FTaxAmount else u1.FAmount end as FAllAmount,t17.FQtyDecimal as FQtyDecimal,
t4.FNumber as 'dwdm',t4.FName as 'wldw',t17.FName as 'cpmc',t17.FModel as 'cpgg',u1.FAuxQty as 'fssl',
u1.FPrice as 'wsdj',u1.FTaxPrice as 'hsdj',u1.FTaxAmount as 'xxs',u1.FAllAmount as 'hsje',t17.FNumber as 'cpdm',u1.FCheckQty as 'hxsl',u1.FCheckAmount as 'hxje'
from ICSale v1 INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_ICItem t17 ON     u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
 where 1=1 AND (     
ISNULL(t4.FNumber,'') = '01.001'
)  AND (v1.FTranType=80 AND (v1.FROB=1 AND  v1.FCancellation = 0))




-------------

Select t17.FNumber,t17.FName as 'cpmc',t17.FModel as 'cpgg',sum(u1.FAuxQty) as 'fssl',
sum(cast(u1.FAuxQty*u1.FTaxPrice as decimal(28,2))) as 'hsje'
from ICSale v1 INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_ICItem t17 ON     u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
 LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 LEFT JOIN t_user us On us.FUserID=v1.FBillerID
 where 1=1 
AND (v1.FTranType=80 AND  v1.FCancellation = 0)
AND v1.FDate>='2013-01-01' AND  v1.FDate<='2013-12-31'
AND v1.FStatus > 0
and t4.FNumber in ('01.002','01.144')
group by t17.FNumber,t17.FName,t17.FModel
order by 





