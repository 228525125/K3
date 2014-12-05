--�˴������ڲ�Ʒ��������ʱ���ж��ͼ�����>��������-��������
--DROP TRIGGER IC_CPJYSQD

CREATE TRIGGER IC_CPJYSQD ON QMICMOCKRequest    
FOR INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN  QMICMOCKRequestEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on a.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=c.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	WHERE 1=1     
	and (
		(c.FQtyMust>=c.FQtyPick and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0)-ROUND(FDiscardAuxQty/c.FAuxQtyScrap,0)+ROUND(ISNULL(-f.FQty,0)/c.FAuxQtyScrap,0) < e.FQty)  --�ƻ�Ͷ������ >= Ӧ������    ����������-�������� < �������*��λ����   f.qty���ϷϿ�ĺ���������������Ϊ֮ǰ���������뱨�ϵ��ظ��ˣ����������2013-06-26�տ�ʼ�Ĺ���
	    	or 
		(c.FQtyMust<c.FQtyPick  and  c.FQtyMust>c.FAuxStockQty)   --�ƻ�Ͷ������ < Ӧ���������ͱ���ȫ�����꣬��Ϊ��ʱ����ʱ�޸�Ͷ�ϵ�
	)                         
	and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
	and c.FAuxQtyScrap > 0                              --��λ�����������0
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --������λû��С�����
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040' and d.FNumber<>'06.04.0049'      --�������⹺���صİ��Ʒ
)
BEGIN
DECLARE @test nvarchar(255)
SELECT @test=ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0)-ROUND(c.FDiscardAuxQty/c.FAuxQtyScrap,0)+ROUND(ISNULL(-f.FQty,0)/c.FAuxQtyScrap,0)-(e.FQty-b.FQty) FROM inserted a 
	INNER JOIN  QMICMOCKRequestEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on a.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 	
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=c.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	WHERE 1=1 
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0)-ROUND(FDiscardAuxQty/c.FAuxQtyScrap,0)+ROUND(ISNULL(-f.FQty,0)/c.FAuxQtyScrap,0) < e.FQty         --����������-�������� < �������*��λ����   f.qty���ϷϿ�ĺ���������������Ϊ֮ǰ���������뱨�ϵ��ظ��ˣ����������2013-06-26�տ�ʼ�Ĺ���
	and left(d.FNumber,3)<>'08.'                            --�����ǰ�װ����
	and c.FAuxQtyScrap > 0                              --��λ�����������0
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --������λû��С�����
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040' and d.FNumber<>'06.04.0049'      --�������⹺���صİ��Ʒ

exec('�ͼ�����_����_��������_��_����_'+@test) 
END 






(select v1.FICMOInterID,sum(u1.FQty) from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) 




--select (c.FAuxStockQty/c.FAuxQtyScrap) as '����',(FDiscardAuxQty/c.FAuxQtyScrap) as '����',(-f.FQty) as '����',e.FQty as '���' 
select (c.FAuxStockQty) as '����',(FDiscardAuxQty) as '����',(-f.FQty) as '����',e.FQty* c.FAuxQtyScrap as '���' 
	FROM QMICMOCKRequest a 
	INNER JOIN  QMICMOCKRequestEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on a.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 	
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 /*and a.FDate<'2013-06-26'*/ group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=c.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	WHERE 1=1 
	--and c.FAuxStockQty-c.FDiscardAuxQty+(-f.FQty) < (e.FQty+7) * c.FAuxQtyScrap         --����������-�������� < �������*��λ���� 
	and left(d.FNumber,3)<>'08.'                            --�����ǰ�װ����
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --������λû��С�����
	and c.FICMOInterID=25135


select * from ICMO where FBillNo='work024004'

select * from PPBOM a left join PPBOMEntry b on a.FInterID=b.FInterID where a.FBillNo='PBOM000164'


select v1.* from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=24 AND v1.FCancellation = 0 AND v1.FStatus = 1 AND FROB=-1
and v1.FBillNo='SOUT020648'

FSCStockID

select * from t_stock where FItemID='5272'

select * from ICMO where FBillNo IN ('WORK000303','WORK000304')
1331
1332

FCheckCommitQty

update ICMO set FCheckCommitQty=0,FAuxCheckCommitQty=0 where FBillNo IN ('WORK023816')


23816

select FCheckCommitQty,* from ICMO where FBillNo like '%23816%'