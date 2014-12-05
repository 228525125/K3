/*�����깤��Ʒͳ��*/

DECLARE @begindate nvarchar(255)
DECLARE @enddate nvarchar(255)
set @begindate='2012-04-01'
set @enddate='2012-04-30'
select i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName,sum(u1.FQty) as FQty 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName


/*��������ͳ��*/

DECLARE @begindate nvarchar(255)
DECLARE @enddate nvarchar(255)
set @begindate='2012-04-01'
set @enddate='2012-04-30'
select i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName,sum(u1.FQty) as FQty 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where v1.FTranType=24 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
group by i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName

/*�������ù鼯*/

execute report_scxhhz_1 '','2012-04-01','2012-04-30','','null',''   --�гɱ����󣬱������깤��Ʒ����������

execute report_scxhhz_2 '2012-04-01','2012-04-30'                   --�гɱ����󣬵����깤��Ʒ����������

execute report_scxhhz_3 '2012-04-01','2012-04-30'                   --û�гɱ��������������

