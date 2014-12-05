--根据发票更新订单、通知、出库
--drop procedure update_xsdj drop procedure list_xsfp_djcy  drop procedure list_xsfp_djcy_count

create procedure update_xsdj
@FInterID int,
@FEntryID int
as
begin
SET NOCOUNT ON
update e set e.FPrice=b.FPrice,e.FAmount=b.FAmount,e.FAuxPrice=b.FPrice,e.FAllAmount=b.FAmountincludetax,e.FAllStdAmount=b.FAmountincludetax,e.FAuxPriceDiscount=b.FTaxPrice,e.FPriceDiscount=b.FTaxPrice,e.FAuxTaxPrice=b.FTaxPrice,e.FTaxPrice=b.FTaxPrice,FTaxAmt=b.FTaxAmount        --销售订单
from ICSale a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID and FOrderInterID>0
LEFT JOIN ICStockBillEntry c on c.FOrderInterID=b.FOrderInterID and c.FOrderEntryID=b.FOrderEntryID and c.FItemID=b.FItemID
LEFT JOIN SEOutStockEntry d on d.FSourceInterID=b.FOrderInterID and d.FOrderEntryID=b.FOrderEntryID and d.FItemID=b.FItemID
LEFT JOIN SEOrderEntry e on e.FInterID=b.FOrderInterID and e.FEntryID=b.FOrderEntryID and e.FItemID=b.FItemID
where a.FTranType=80 and a.FCancellation=0 and b.FInterID=@FInterID and b.FEntryID=@FEntryID

update d set d.FPrice=b.FTaxPrice,d.FAmount=b.FAmountincludetax,d.FAuxPrice=b.FTaxPrice,d.FStdAmount=b.FAmountincludetax            --销售通知
from ICSale a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID and FOrderInterID>0
LEFT JOIN ICStockBillEntry c on c.FOrderInterID=b.FOrderInterID and c.FOrderEntryID=b.FOrderEntryID and c.FItemID=b.FItemID
LEFT JOIN SEOutStockEntry d on d.FSourceInterID=b.FOrderInterID and d.FOrderEntryID=b.FOrderEntryID and d.FItemID=b.FItemID
LEFT JOIN SEOrderEntry e on e.FInterID=b.FOrderInterID and e.FEntryID=b.FOrderEntryID and e.FItemID=b.FItemID
where a.FTranType=80 and a.FCancellation=0 and b.FInterID=@FInterID and b.FEntryID=@FEntryID

update c set c.FConsignPrice=b.FTaxPrice,c.FConsignAmount=b.FAmountincludetax            --销售出库
from ICSale a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID and FOrderInterID>0
LEFT JOIN ICStockBillEntry c on c.FOrderInterID=b.FOrderInterID and c.FOrderEntryID=b.FOrderEntryID and c.FItemID=b.FItemID
LEFT JOIN SEOutStockEntry d on d.FSourceInterID=b.FOrderInterID and d.FOrderEntryID=b.FOrderEntryID and d.FItemID=b.FItemID
LEFT JOIN SEOrderEntry e on e.FInterID=b.FOrderInterID and e.FEntryID=b.FOrderEntryID and e.FItemID=b.FItemID
where a.FTranType=80 and a.FCancellation=0 and b.FInterID=@FInterID and b.FEntryID=@FEntryID

update b set b.FOrderPrice=b.FTaxPrice,b.FAuxOrderPrice=b.FTaxPrice            --销售发票
from ICSale a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID and FOrderInterID>0
LEFT JOIN ICStockBillEntry c on c.FOrderInterID=b.FOrderInterID and c.FOrderEntryID=b.FOrderEntryID and c.FItemID=b.FItemID
LEFT JOIN SEOutStockEntry d on d.FSourceInterID=b.FOrderInterID and d.FOrderEntryID=b.FOrderEntryID and d.FItemID=b.FItemID
LEFT JOIN SEOrderEntry e on e.FInterID=b.FOrderInterID and e.FEntryID=b.FOrderEntryID and e.FItemID=b.FItemID
where a.FTranType=80 and a.FCancellation=0 and b.FInterID=@FInterID and b.FEntryID=@FEntryID
end

--list_xsfp_djcy--
create procedure list_xsfp_djcy 
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
FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FOrderID nvarchar(20) default('')
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
FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FOrderID nvarchar(20) default('')
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

Insert Into #temp(FInterID,FEntryID,FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje,ddhsdj,ddhsje
)
Select top 20000 u1.FInterID,u1.FEntryID,cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) as FOrderID,cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) as FSaleID,
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
AND (v1.FTranType=80 AND (v1.FROB=1 AND  v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or t17.FName like '%'+@query+'%' 
or t17.FModel like '%'+@query+'%' or u1.FAuxQty like '%'+@query+'%' or u1.FTaxPrice like '%'+@query+'%' or (u1.FAuxQty*u1.FTaxPrice) like '%'+@query+'%' or t17.FNumber like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
AND u1.FTaxPrice<>se.FPriceDiscount
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FInterID,FEntryID,FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje,ddhsdj,ddhsje)select * from #temp')
else
exec('Insert Into #Data(FInterID,FEntryID,FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje,ddhsdj,ddhsje)select * from #temp order by '+ @orderby+' '+ @ordertype)

select * from #Data 
end

---------count----------
create procedure list_xsfp_djcy_count 
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
FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FOrderID nvarchar(20) default('')
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
FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FOrderID nvarchar(20) default('')
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

Insert Into #temp(FInterID,FEntryID,FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje,ddhsdj,ddhsje
)
Select top 20000 u1.FInterID,u1.FEntryID,cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) as FOrderID,cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) as FSaleID,
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
AND (v1.FTranType=80 AND (v1.FROB=1 AND  v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or t17.FName like '%'+@query+'%' 
or t17.FModel like '%'+@query+'%' or u1.FAuxQty like '%'+@query+'%' or u1.FTaxPrice like '%'+@query+'%' or (u1.FAuxQty*u1.FTaxPrice) like '%'+@query+'%' or t17.FNumber like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
AND u1.FTaxPrice<>se.FPriceDiscount
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FInterID,FEntryID,FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje,ddhsdj,ddhsje)select * from #temp')
else
exec('Insert Into #Data(FInterID,FEntryID,FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje,ddhsdj,ddhsje)select * from #temp order by '+ @orderby+' '+ @ordertype)

select count(*) from #Data 
end

execute list_xsfp_djcy '','2011-12-01','2011-12-30','','null',''

execute list_xsfp_djcy_count '','2011-12-01','2011-12-30','','null',''

execute update_xsdj 1085,1

select * from ICSale v1 
INNER JOIN ICSaleEntry u1 ON  v1.FInterID = u1.FInterID AND u1.FInterID <>0 
where v1.FDate>='2011-12-01' and v1.FDate<='2011-12-30'

select * from SEOrder where FBillNo='SEORD000107'

select * from SEOrderEntry where FInterID=1241 and FEntryID=1



select * from ICSaleEntry where FInterID=1085 and FEntryID=1

select * from ICSale where FInterID=1085

select b.* from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FBillNo='SEORD002684' and b.FQty=9.4

update b set b.FTaxAmt=102.44 from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FBillNo='SEORD002684' and b.FQty=9.4

select FQty,b.FTaxAmount from ICSale a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID and FOrderInterID>0
where a.FBillNo='XZP00000288'



