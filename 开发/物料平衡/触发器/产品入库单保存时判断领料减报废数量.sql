--�˴������ڲ�Ʒ���ʱ���ж�������� > �������� - ��������
--DROP TRIGGER IC_CPRK

CREATE TRIGGER IC_CPRK ON ICStockBill    
FOR INSERT
AS
BEGIN
SET NOCOUNT ON
IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN  ICStockBillEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2015-02-01' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=b.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=b.FICMOInterID and c.FEntryID=k.FPPBomEntryID
	LEFT JOIN ICMO o on b.FICMOInterID=o.FInterID
	LEFT JOIN t_ICItem g on o.FItemID=g.FItemID
	WHERE 1=1 
	and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=c.FICMOInterID and bome.FEntryID=2 and bom.FItemID=b.FItemID)        --�����ڲ�Ʒbom���ж���1��ԭ���ϣ�����Ʒ��ԭ����һһ��Ӧ��bomû�ж��ڵ�ԭ����
	and a.FTranType=2
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) - ROUND((c.FDiscardAuxQty)/c.FAuxQtyScrap,0) - ISNULL(o.FAuxStockQty,0) < b.FQty         --����������-�ѱ�������-��������� < ��ǰ�������
	and left(d.FNumber,3)<>'08.'                            --�����ǰ�װ����
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --������λû��С�����
	and a.FStatus=0                    --���ݱ���ʱ�ж�
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'    --�������⹺���صİ��Ʒ
)
RAISERROR (50022,16,1 )
END






SELECT 
ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) as '����', 
ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) as '����',
ROUND((c.FDiscardAuxQty)/c.FAuxQtyScrap,0) as '����', 
ISNULL(o.FAuxStockQty,0) as '���',
ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) - ROUND((c.FDiscardAuxQty)/c.FAuxQtyScrap,0) - ISNULL(o.FAuxStockQty,0) as '���'
FROM ICStockBill a 
	INNER JOIN  ICStockBillEntry b on a.FInterID=b.FInterID 
	LEFT JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=b.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=b.FICMOInterID and c.FEntryID=k.FPPBomEntryID
	LEFT JOIN ICMO o on b.FICMOInterID=o.FInterID
	LEFT JOIN t_ICItem g on o.FItemID=g.FItemID
	WHERE 1=1 
	and a.FTranType=2
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) - ROUND((c.FDiscardAuxQty)/c.FAuxQtyScrap,0) - ISNULL(o.FAuxStockQty,0) < b.FQty         --����������-�ѱ�������-��������� < ��ǰ�������
	and left(d.FNumber,3)<>'08.'                            --�����ǰ�װ����
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --������λû��С�����
	and a.FStatus=0                    --���ݱ���ʱ�ж�
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'    --�������⹺���صİ��Ʒ
	and a.FBillNo='CIN010781'

