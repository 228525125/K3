select f.FBillNo,a.FDate as '�Ƶ�����',d.FName as '������λ',a.FBillNo as '������',c.FName as '��Ʒ����',c.FModel as '���',e.FName as '��λ',
b.FQty as '����',b.FPrice as '����',b.FPriceDiscount as '��˰����',b.FTaxAmt as '����˰',b.FAllAmount as '��˰���',b.FDate as '��������',
f.FFetchDate as 'ʵ�ʽ�������',f.FQty as '֪ͨ����',f.FAmount as '���'--,b.*,f.* 
from SEOrder a 
left join (select FInterID,FItemID,FUnitID,sum(FQty) as FQty,max(FPrice) as FPrice,max(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(FDate) as FDate from SEOrderEntry group by FInterID,FItemID,FUnitID) b on a.FInterID=b.FInterID 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID
left join t_MeasureUnit e on e.FItemID=b.FUnitID
left join (select FBillNo,FSourceBillNo,FItemID,max(FFetchDate) as FFetchDate,sum(FQty) as FQty,sum(FAmount) as FAmount from SEOutStock a left join SEOutStockEntry b on a.FInterID=b.FInterID Group by FBillNo,FSourceBillNo,FItemID) f on a.FBillNo=f.FSourceBillNo and b.FItemID=f.FItemID
--left join (select FSourceBillNo,FItemID,max(FDate) as FDate,sum(FQty) as FQty,sum(FAmount) as FAmount from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where FBillNo like 'XOUT%' group by FSourceBillNo,FItemID) g on f.FItemID=g.FItemID
where a.FDate='2011-05-23' and a.FBillNo='SEORD001816'

union


select FSourceBillNo,FCommitQty,FQty from SEOutStockEntry where FCommitQty<>FQty

select * from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FBillNo='SEORD001816'      --���۶���

select * from t_ICItem where FItemID=1467 --and FName='����о(SUS316)'        --��Ʒ��

select * from t_Organization   --�ͻ���

select * from t_MeasureUnit    --������λ

select * from SEOutStock a left join SEOutStockEntry b on a.FInterID=b.FInterID where b.FSourceBillNo='SEORD001816'    --����֪ͨ

select * from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where FBillNo like 'XOUT%' --���۳���

select a.FBillNo,b.FCommitQty,b.FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID

select FCommitQty,FQty from ICStockBillEntry



select FSourceBillNo,FItemID,max(FFetchDate) as FFetchDate,sum(FQty) as FQty,sum(FAmount) as FAmount from SEOutStock a left join SEOutStockEntry b on a.FInterID=b.FInterID where FSourceBillNo='SEORD001816' Group by FSourceBillNo,FItemID

select FSourceBillNo,FItemID,max(FFetchDate) as FFetchDate,sum(FQty) as FQty,sum(FAmount) as FAmount from SEOutStockEntry  where FSourceBillNo='SEORD001816' Group by FSourceBillNo,FItemID

select b.FSourceBillNo,b.FItemID,max(a.FDate) as FDate,sum(b.FQty) as FQty,sum(b.FAmount) as FAmount from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID left join SEOutStock c on b.FSourceBillNo=c.FBillNo left join SEOutStockEntry d on c.FInterID=d.FInterID where a.FBillNo like 'XOUT%' and .d.FSourceBillNo='SEORD001816' group by b.FSourceBillNo,b.FItemID


select sum(d.fqty) from SEOrder a 
left join SEOutStockEntry b on a.FBillNo=b.FSourceBillNo 
left join SEOutStock c on b.FInterID=c.FInterID
left join ICStockBillEntry d on c.FBillNo=d.FSourceBillNo
--left join ICStockBill e on d.FInterID=e.FInterID
where a.FBillNo='SEORD001816'



