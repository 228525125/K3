--drop procedure hint_xsddjq

create procedure hint_xsddjq 
@diffday int
as 
begin
select convert(char(10),a.FDate,111) as 'djrq',convert(char(10),b.FDate,111) as 'jhrq',datediff(Day,getDate(), b.FDate) as 'sjc',a.FBillNo as 'djbh',d.FName as 'wldw',c.FName as 'cpmc',c.FModel as 'cpgg',e.FName as 'jldw', 
cast(b.FQty as decimal(18,2)) as 'ddsl',
cast(b.FPriceDiscount as decimal(18,2)) as 'hsdj',
cast(b.FAllAmount as decimal(18,2)) as 'hsje',
cast(b.FAllAmount as decimal(18,2)) as 'cksl'
--f.FStatus,f.FClosed
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,max(b.FDate) as FDate,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID
left join t_Organization d on a.FCustID=d.FItemID
left join t_MeasureUnit e on e.FItemID=b.FUnitID
--left join (select FSourceBillNo,FItemID,max(FFetchDate) as FFetchDate,sum(FQty) as FQty,min(FStatus) as FStatus,min(FClosed) as FClosed from SEOutStock a left join SEOutStockEntry b on a.FInterID=b.FInterID Group by FSourceBillNo,FItemID) f on a.FBillNo=f.FSourceBillNo and b.FItemID=f.FItemID
left join (select FOrderBillNo,FItemID,max(FDate) as FDate,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID group by FOrderBillNo,FItemID) g on a.FBillNo=g.FOrderBillNo and b.FItemID=g.FItemID
where 1=1
and a.FStatus>=1 
and a.FCancellation=0     --未作废的单据
and datediff(Day,getDate(), b.FDate)<=@diffday and datediff(Day,getDate(), b.FDate)>0    --提前几天提醒
and b.FQty>isnull(g.FQty,0)       --判断订单数量与出库数量的差异
end

execute hint_xsddjq 3


select * from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where FBillNo='SEORD002182'

select * from SEOrderEntry where FInterID in (3520,3534)




---------------第一个版本--------------
select convert(char(10),a.FDate,111) as 'djrq',convert(char(10),b.FDate,111) as 'jhrq',datediff(Day,getDate(), b.FDate) as 'sjc',a.FBillNo as 'djbh',d.FName as 'wldw',c.FName as 'cpmc',c.FModel as 'cpgg',e.FName as 'jldw', 
cast(b.FQty as decimal(18,2)) as '数量',
cast(b.FPriceDiscount as decimal(18,2)) as '含税单价',
cast(b.FAllAmount as decimal(18,2)) as '含税金额',
a.FStatus
from SEOrder a 
left join SEOrderEntry b on a.FInterID=b.FInterID 
left join t_ICItem c on b.FItemID=c.FItemID
left join t_Organization d on a.FCustID=d.FItemID
left join t_MeasureUnit e on e.FItemID=b.FUnitID
left join (select FOrderBillNo,FItemID,max(FDate) as FDate,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID group by FOrderBillNo,FItemID) g on a.FBillNo=g.FOrderBillNo and b.FItemID=g.FItemID
where 1=1
and a.FStatus>=1
--and not exists(select * from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where b.FOrderBillNo=a.FBillNo)
and datediff(Day,getDate(), b.FDate)>=@diffday