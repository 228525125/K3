select Convert(char(10),Max(a.FDate),111) as '制单日期',Max(d.FName) as '往来单位',Max(a.FBillNo) as '订单号',Max(c.FName) as '产品名称',Max(c.FModel) as '规格',Max(e.FName) as '单位',
sum(b.FQty) as '数量',
MIN(b.FPrice) as '单价',
MIN(b.FPriceDiscount) as '含税单价',
SUM(b.FTaxAmt) as '销项税',
SUM(b.FAllAmount) as '含税金额',
Convert(char(10),MAX(b.FDate),111) as '交货日期',
Convert(char(10),MAX(f.FFetchDate),111) as '实际交货日期',
SUM(f.FQty) as '通知数量',
SUM(f.FQty*b.FPriceDiscount) as '金额',
SUM(b.FQty)-SUM(f.FQty) as '差异a',
Convert(char(10),MAX(g.FDate),111) as '出库日期',
SUM(g.FQty) as '出库数量',
SUM(g.FQty*b.FPriceDiscount) as '出库金额',
SUM(f.FQty)-SUM(g.FQty) as '差异b',
Convert(char(10),MAX(h.FDate),111) as '开票日期',
SUM(h.FQty) as '开票数量',
SUM(h.FAmount) as '开票金额',
SUM(g.FQty)-SUM(h.FQty) as '差异c'--,b.*,f.* 
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID
left join t_MeasureUnit e on e.FItemID=b.FUnitID
left join (select FSourceBillNo,FItemID,max(FFetchDate) as FFetchDate,sum(FQty) as FQty/*,sum(FAmount) as FAmount*/ from SEOutStock a left join SEOutStockEntry b on a.FInterID=b.FInterID Group by FSourceBillNo,FItemID) f on a.FBillNo=f.FSourceBillNo and b.FItemID=f.FItemID
left join (select FOrderBillNo,FItemID,max(FDate) as FDate,sum(FQty) as FQty/*,sum(FAmount) as FAmount*/ from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID group by FOrderBillNo,FItemID) g on a.FBillNo=g.FOrderBillNo and b.FItemID=g.FItemID
left join (select FOrderBillNo,FItemID,max(FDate) as FDate,sum(FQty) as FQty,sum(FAmount) as FAmount from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID group by FOrderBillNo,FItemID) h on a.FBillNo=h.FOrderBillNo and b.FItemID=h.FItemID
where a.FCancellation=0 
AND a.FDate>='********' AND a.FDate<='########' 
AND a.FBillNo like '%*FBillNoCommon*%' 
AND d.FName like '%@CustName@%'
group by Convert(char(10),a.FDate,111)+a.FBillNo+d.FName+c.FName+c.FModel+e.FName with rollup
order by Max(d.fName),Max(a.FDate),Max(c.FName),Max(c.FModel)