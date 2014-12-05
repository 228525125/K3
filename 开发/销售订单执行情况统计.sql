
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
djrq nvarchar(20) default('')
,wldw nvarchar(20) default('')
,djbh nvarchar(20) default('')
,cpmc nvarchar(200) default('')
,cpgg nvarchar(50) default('')
,jldw nvarchar(20) default('')
,fssl decimal(28,2) default(0)
,wsdj decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)           
,xxs decimal(28,2) default(0)          
,hsje decimal(28,2) default(0)
,jhrq nvarchar(20) default('')
,sjjhrq nvarchar(20) default('')
,tzsl decimal(28,2) default(0)
,tzje decimal(28,2) default(0)
,chayia decimal(28,2) default(0)
,ckrq nvarchar(20) default('')
,cksl decimal(28,2) default(0)
,ckje decimal(28,2) default(0)
,chayib decimal(28,2) default(0)
,kprq nvarchar(20) default('')
,ckrq
,hxsl decimal(28,2) default(0)
,hxje decimal(28,2) default(0)
,ddhsdj decimal(28,2) default(0)
,ddhsje decimal(28,2) default(0)  --这个不是订单金额，是发票数量*订单含税单价
)

Insert Into #temp(FOrderID,FSaleID,FCheck,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,wsdj,hsdj,xxs,hsje,cpdm,hxsl,hxje,ddhsdj,ddhsje
)
select Convert(char(10),Max(a.FDate),111) as 'djrq',       --制单日期
Max(d.FName) as 'wldw',                --往来单位
Max(a.FBillNo) as 'djbh',              --订单号
Max(c.FName) as 'cpmc',                --产品名称
Max(c.FModel) as 'cpgg',               --规格
Max(e.FName) as 'jldw',                --单位
sum(b.FQty) as 'fssl',                 --数量
MIN(b.FPrice) as 'wsdj',               --无税单价
MIN(b.FPriceDiscount) as 'hsdj',       --含税单价
SUM(b.FTaxAmt) as 'xxs',               --销项税
SUM(b.FAllAmount) as 'hsje',           --含税金额
Convert(char(10),MAX(b.FDate),111) as 'jhrq',           --交货日期
Convert(char(10),MAX(f.FFetchDate),111) as 'sjjhrq',        --实际交货日期
SUM(f.FQty) as 'tzsl',
SUM(f.FQty*b.FPriceDiscount) as 'tzje',
SUM(b.FQty)-SUM(f.FQty) as 'chayia',
Convert(char(10),MAX(g.FDate),111) as 'ckrq',
SUM(g.FQty) as 'cksl',
SUM(g.FQty*b.FPriceDiscount) as 'ckje',
SUM(f.FQty)-SUM(g.FQty) as 'chayib',
Convert(char(10),MAX(h.FDate),111) as 'kprq',
SUM(h.FQty) as 'kpsl',
SUM(h.FAmount) as 'kpje',
SUM(g.FQty)-SUM(h.FQty) as 'chayic',
SUM(h.FCheckQty) as 'hxsl',
SUM(h.FCheckAmount) as 'hxje'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID
left join t_Organization d on a.FCustID=d.FItemID
left join t_MeasureUnit e on e.FItemID=b.FUnitID
left join (select FSourceBillNo,FItemID,max(FFetchDate) as FFetchDate,sum(FQty) as FQty/*,sum(FAmount) as FAmount*/ from SEOutStock a left join SEOutStockEntry b on a.FInterID=b.FInterID Group by FSourceBillNo,FItemID) f on a.FBillNo=f.FSourceBillNo and b.FItemID=f.FItemID
left join (select FOrderBillNo,FItemID,max(FDate) as FDate,sum(FQty) as FQty/*,sum(FAmount) as FAmount*/ from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID group by FOrderBillNo,FItemID) g on a.FBillNo=g.FOrderBillNo and b.FItemID=g.FItemID
left join (select FOrderBillNo,FItemID,max(FDate) as FDate,sum(FQty) as FQty,sum(FAmount) as FAmount, sum(b.FCheckQty) as FCheckQty, sum(b.FCheckAmount) as FCheckAmount from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID group by FOrderBillNo,FItemID) h on a.FBillNo=h.FOrderBillNo and b.FItemID=h.FItemID
where a.FCancellation=0 
and a.FDate>='2011-11-01' and a.FDate<='2011-11-30'
group by Convert(char(10),a.FDate,111)+a.FBillNo+d.FName+c.FName+c.FModel+e.FName
order by Max(d.fName),Max(a.FDate),Max(c.FName),Max(c.FModel)


select * from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID --group by FOrderBillNo,FItemID

select * from ICSaleEntry

select a.FBillNo,b.FPrice as 'fpdj',b.FTaxAmount as 'fpse',b.FAmount as 'fpwsje',b.FTaxPrice as 'fphsdj',b.FAmountincludetax as 'fphsje',b.FOrderPrice,b.FAuxOrderPrice
,c.FConsignPrice,c.FConsignAmount
,d.FPrice,d.FAmount,d.FAuxPrice,d.FStdAmount
,e.FPrice,e.FAmount,e.FAuxPrice,e.FAllAmount,e.FAllStdAmount,e.FAuxPriceDiscount,e.FPriceDiscount,e.FAuxTaxPrice,e.FTaxPrice 
from ICSale a 
LEFT JOIN ICSaleEntry b on a.FInterID=b.FInterID 
LEFT JOIN ICStockBillEntry c on c.FOrderInterID=b.FOrderInterID and c.FOrderEntryID=b.FOrderEntryID
LEFT JOIN SEOutStockEntry d on d.FSourceInterID=b.FOrderInterID and d.FOrderEntryID=b.FOrderEntryID
LEFT JOIN SEOrderEntry e on e.FInterID=b.FOrderInterID and e.FEntryID=b.FOrderEntryID
where a.FDate>='2011-11-01' and a.FDate<='2011-11-30'
and a.FTranType=80 and a.FCancellation=0 and a.FBillNo='XZP00000265'

select a.FBillNo,b.FPrice as 'fpdj',b.FTaxAmount as 'fpse',b.FAmount as 'fpwsje',b.FTaxPrice as 'fphsdj',b.FAmountincludetax as 'fphsje',b.FOrderPrice,b.FAuxOrderPrice,b.FOrderInterID,b.FOrderEntryID
--,c.FConsignPrice,c.FConsignAmount
from ICSale a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID and FOrderInterID>0
LEFT JOIN ICStockBillEntry c on c.FOrderInterID=b.FOrderInterID and c.FOrderEntryID=b.FOrderEntryID and c.FItemID=b.FItemID
LEFT JOIN SEOutStockEntry d on d.FSourceInterID=b.FOrderInterID and d.FOrderEntryID=b.FOrderEntryID and d.FItemID=b.FItemID
LEFT JOIN SEOrderEntry e on e.FInterID=b.FOrderInterID and e.FEntryID=b.FOrderEntryID and e.FItemID=b.FItemID
where a.FDate>='2011-11-01' and a.FDate<='2011-11-30'
and a.FTranType=80 and a.FCancellation=0 --and a.FBillNo='XZP00000265'

update e set e.FPrice=b.FPrice,e.FAmount=b.FAmount,e.FAuxPrice=b.FPrice,e.FAllAmount=b.FAmountincludetax,e.FAllStdAmount=b.FAmountincludetax,e.FAuxPriceDiscount=b.FTaxPrice,e.FPriceDiscount=b.FTaxPrice,e.FAuxTaxPrice=b.FTaxPrice,e.FTaxPrice=b.FTaxPrice
from ICSale a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID and FOrderInterID>0
LEFT JOIN ICStockBillEntry c on c.FOrderInterID=b.FOrderInterID and c.FOrderEntryID=b.FOrderEntryID and c.FItemID=b.FItemID
LEFT JOIN SEOutStockEntry d on d.FSourceInterID=b.FOrderInterID and d.FOrderEntryID=b.FOrderEntryID and d.FItemID=b.FItemID
LEFT JOIN SEOrderEntry e on e.FInterID=b.FOrderInterID and e.FEntryID=b.FOrderEntryID and e.FItemID=b.FItemID
where a.FDate>='2011-11-01' and a.FDate<='2011-11-30'
and a.FTranType=80 and a.FCancellation=0

update d set d.FPrice=b.FTaxPrice,d.FAmount=b.FAmountincludetax,d.FAuxPrice=b.FTaxPrice,d.FStdAmount=b.FAmountincludetax            --销售通知
from ICSale a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID and FOrderInterID>0
LEFT JOIN ICStockBillEntry c on c.FOrderInterID=b.FOrderInterID and c.FOrderEntryID=b.FOrderEntryID and c.FItemID=b.FItemID
LEFT JOIN SEOutStockEntry d on d.FSourceInterID=b.FOrderInterID and d.FOrderEntryID=b.FOrderEntryID and d.FItemID=b.FItemID
LEFT JOIN SEOrderEntry e on e.FInterID=b.FOrderInterID and e.FEntryID=b.FOrderEntryID and e.FItemID=b.FItemID
where a.FDate>='2011-11-01' and a.FDate<='2011-11-30'
and a.FTranType=80 and a.FCancellation=0

update c set c.FConsignPrice=b.FTaxPrice,c.FConsignAmount=b.FAmountincludetax            --销售出库
from ICSale a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID and FOrderInterID>0
LEFT JOIN ICStockBillEntry c on c.FOrderInterID=b.FOrderInterID and c.FOrderEntryID=b.FOrderEntryID and c.FItemID=b.FItemID
LEFT JOIN SEOutStockEntry d on d.FSourceInterID=b.FOrderInterID and d.FOrderEntryID=b.FOrderEntryID and d.FItemID=b.FItemID
LEFT JOIN SEOrderEntry e on e.FInterID=b.FOrderInterID and e.FEntryID=b.FOrderEntryID and e.FItemID=b.FItemID
where a.FDate>='2011-11-01' and a.FDate<='2011-11-30'
and a.FTranType=80 and a.FCancellation=0

update b set b.FOrderPrice=b.FTaxPrice,b.FAuxOrderPrice=b.FTaxPrice            --销售发票
from ICSale a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID and FOrderInterID>0
LEFT JOIN ICStockBillEntry c on c.FOrderInterID=b.FOrderInterID and c.FOrderEntryID=b.FOrderEntryID and c.FItemID=b.FItemID
LEFT JOIN SEOutStockEntry d on d.FSourceInterID=b.FOrderInterID and d.FOrderEntryID=b.FOrderEntryID and d.FItemID=b.FItemID
LEFT JOIN SEOrderEntry e on e.FInterID=b.FOrderInterID and e.FEntryID=b.FOrderEntryID and e.FItemID=b.FItemID
where a.FDate>='2011-11-01' and a.FDate<='2011-11-30'
and a.FTranType=80 and a.FCancellation=0


(select a.FBillNo,b.FOrderInterID,b.FOrderEntryID from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID group by a.FBillNo,b.FOrderInterID,FOrderEntryID) c on 

select a.FBillNo,b.FConsignPrice,b.FConsignAmount from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FBillNo='XOUT003113'

select * from SEOutStock a left join SEOutStockEntry b on a.FInterID=b.FInterID where a.FBillNo='XOUT004667'

select * from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FBillNo='SEORD002511'

select b.*,b.FSourceInterID,b.FSourceEntryID from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID where a.FBillNo='XZP04740520'

select b.FAmount as '成本',FPrice as '单价' from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where FBillNo='XOUT004667'

select * from ICSale where FStatus=1


sele