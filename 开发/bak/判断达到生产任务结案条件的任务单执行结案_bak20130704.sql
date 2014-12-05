-------������᰸���������񵥽��н᰸����


create procedure close_scrw
as
begin
create table #temp(
FBillNo nvarchar(255) default('')
)

Insert Into  #temp(FBillNo)
select a.FBillNo
from ICMO a
LEFT JOIN PPBOM b ON   b.FICMOInterID = a.FInterID  AND a.FInterID<>0
LEFT JOIN PPBOMEntry c ON c.FInterID = b.FInterID  AND b.FInterID<>0 
LEFT JOIN t_ICItem i1 on a.FItemID=i1.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=a.FUnitID
LEFT JOIN t_ICItem i2 on c.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu2 on mu2.FItemID=c.FUnitID
INNER JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
group by u1.FICMOBillNo,u1.FItemID
) e on a.FBillNo=e.FICMOBillNo and a.FItemID=e.FItemID
INNER JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
group by u1.FICMOBillNo,u1.FItemID
) g on a.FBillNo=g.FICMOBillNo and a.FItemID=g.FItemID
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=24 AND v1.FCancellation = 0
group by u1.FICMOBillNo,u1.FItemID
) f on a.FBillNo=f.FICMOBillNo and c.FItemID=f.FItemID
where 1=1
AND a.FStatus in (1,2)
and a.FQty+c.FAuxQtySupply-c.FDiscardAuxQty=g.FQty             --�ƻ�����+��������-��������=�������
and c.FAuxQtyPick <> c.FAuxStockQty                            --��������û��ִ�����
and left(i2.FNumber,3)<>'08.'                                  --�����ǰ���û�����õ����
order by a.FBillNo

update a set a.FStatus=3,a.FCheckerID=16469,a.FMrpClosed=1,a.FHandworkClose=1,a.FCloseDate=convert(char(10),getDate(),120),a.FNote=a.FNote+'<-�Զ��жϺ�᰸->'
from ICMO a
LEFT JOIN PPBOM b ON   b.FICMOInterID = a.FInterID  AND a.FInterID<>0
LEFT JOIN PPBOMEntry c ON c.FInterID = b.FInterID  AND b.FInterID<>0 
LEFT JOIN t_ICItem i1 on a.FItemID=i1.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=a.FUnitID
LEFT JOIN t_ICItem i2 on c.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu2 on mu2.FItemID=c.FUnitID
INNER JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
group by u1.FICMOBillNo,u1.FItemID
) e on a.FBillNo=e.FICMOBillNo and a.FItemID=e.FItemID
INNER JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
group by u1.FICMOBillNo,u1.FItemID
) g on a.FBillNo=g.FICMOBillNo and a.FItemID=g.FItemID
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=24 AND v1.FCancellation = 0
group by u1.FICMOBillNo,u1.FItemID
) f on a.FBillNo=f.FICMOBillNo and c.FItemID=f.FItemID
where 1=1
AND a.FStatus in (1,2)
and a.FQty+c.FAuxQtySupply-c.FDiscardAuxQty=g.FQty             --�ƻ�����+��������-��������=�������
and not exists(select * from #temp where a.FBillNo=FBillNo)
end


exec close_scrw

SELECT 1 FROM inserted a 
	INNER JOIN  ICStockBillEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	INNER JOIN ICMO e on b.FICMOInterID=e.FInterID 
	WHERE a.FTranType=2 
	and c.FAuxStockQty < (e.FStockQty+b.FQty) * c.FAuxQtyScrap         --���������� < �������*��λ���� 
	and left(d.FNumber,3)<>'08.'                            --�����ǰ�װ����
	and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --������λû��С�����
	and d.FErpClsID=2                                       --ֻ�������Ʋ���