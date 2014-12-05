select Convert(char(10),Max(a.FDate),111) as '�Ƶ�����',Max(d.FName) as '������λ',Max(a.FBillNo) as '������',Max(c.FName) as '��Ʒ����',Max(c.FModel) as '���',Max(e.FName) as '��λ',
sum(b.FQty) as '����',
MIN(b.FPrice) as '����',
MIN(b.FPriceDiscount) as '��˰����',
SUM(b.FTaxAmt) as '����˰',
SUM(b.FAllAmount) as '��˰���',
Convert(char(10),MAX(b.FDate),111) as '��������',
Convert(char(10),MAX(f.FFetchDate),111) as 'ʵ�ʽ�������',
SUM(f.FQty) as '֪ͨ����',
SUM(f.FQty*b.FPriceDiscount) as '���',
SUM(b.FQty)-SUM(f.FQty) as '����a',
Convert(char(10),MAX(g.FDate),111) as '��������',
SUM(g.FQty) as '��������',
SUM(g.FQty*b.FPriceDiscount) as '������',
SUM(f.FQty)-SUM(g.FQty) as '����b',
Convert(char(10),MAX(h.FDate),111) as '��Ʊ����',
SUM(h.FQty) as '��Ʊ����',
SUM(h.FAmount) as '��Ʊ���',
SUM(g.FQty)-SUM(h.FQty) as '����c'--,b.*,f.* 
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