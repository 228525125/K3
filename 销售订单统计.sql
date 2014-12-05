select d.FName as 'wldw',c.FNumber as 'cpdm',c.FName as 'cpmc',c.FModel as 'cpgg',c.FHelpCode as 'cpth',e.FName as 'jldw',
sum(b.FQty) as 'fssl',
MIN(b.FPrice) as 'hsdj',
MIN(b.FPriceDiscount) as 'hsdj',
SUM(b.FTaxAmt) as 'xxs',
SUM(b.FAllAmount) as 'hsje'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FCancellation=0 
and a.FDate>='2011-05-01' and a.FDate<='2011-05-30' 
group by d.FName,c.FNumber,c.FName,c.FModel,c.FHelpCode,e.FName 
order by d.fName,c.FName,c.FModel 



select d.FName as 'wldw',c.FNumber as 'cpdm',c.FName as 'cpmc',c.FModel as 'cpgg',c.FHelpCode as 'cpth',e.FName as 'jldw',
sum(b.FQty) as 'fssl',
MIN(b.FPrice) as 'hsdj',
MIN(b.FPriceDiscount) as 'hsdj',
SUM(b.FTaxAmt) as 'xxs',
SUM(b.FAllAmount) as 'hsje'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FCancellation=0 
and a.FDate>='2011-05-01' and a.FDate<='2011-05-30' 
group by d.FName,c.FNumber,c.FName,c.FModel,c.FHelpCode,e.FName 
order by d.fName,c.FName,c.FModel 

select count(FItemID) from t_ICItem













select d.FName as '�ͻ�',c.FName as '����',c.FModel as '���',e.FName as '��λ',
sum(b.FQty) as '����',
MIN(b.FPrice) as '����',
MIN(b.FPriceDiscount) as '��˰����',
SUM(b.FTaxAmt) as '����˰',
SUM(b.FAllAmount) as '��˰���'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID
left join t_MeasureUnit e on e.FItemID=b.FUnitID
where a.FCancellation=0 
and a.FDate>='2011-05-01' and a.FDate<='2011-05-30' 
group by c.FName ,c.FModel,e.FName

