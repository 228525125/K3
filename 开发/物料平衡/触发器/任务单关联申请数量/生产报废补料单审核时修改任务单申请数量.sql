--�˴��������������ϲ��ϵ�ʱ���Զ�������������FCheckCommitQty��FAuxCheckCommitQty��ֵ���Դﵽ�ͼ�����=�ƻ�-����-����-���ͼ�
--DROP TRIGGER IC_SCBFBLD

CREATE TRIGGER IC_SCBFBLD ON ICItemScrap    
AFTER INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
)
BEGIN
exec compute_scrw_yjsl
END






FCheckCommitQty

SELECT a.FBillNo,a.FItemID,a.FQty as '�ƻ�',b.FAuxStockQty as '����',b.FDiscardAuxQty as '����',b.FAuxQtyScrap as '��λ����',ISNULL(e.FQty,0) as '����',ISNULL(c.FQty,0) as '��������',
a.FQty - ((b.FAuxStockQty/b.FAuxQtyScrap) - (b.FDiscardAuxQty/b.FAuxQtyScrap) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)) as '������'
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
where 1=1
and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --�����ڲ�Ʒbom���ж���1��ԭ���ϣ�����Ʒ��ԭ����һһ��Ӧ��bomû�ж��ڵ�ԭ����
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
and a.FQty - ((b.FAuxStockQty/b.FAuxQtyScrap) - (b.FDiscardAuxQty/b.FAuxQtyScrap) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --�ƻ� - (���� - ���� + ���ϣ�2013-06-26֮ǰ�� - ����)
and a.FStatus in (1,2)        --�´�״̬




select * FROM ICMO

select * from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FBillNo='SOUT020584'

5272


select FAuxQtyScrap,* from PPBOMEntry 

select ISNULL(-1,0)

select * from ICBOM a left join ICBOMCHILD b on a.FInterID=b.FInterID where b.FEntryID=2


select * from t_ICItem where FNumber='05.03.0002'

select * from ICMO where FStatus=2 FBillNo='WORK000300'


select * from t_stock

select * from t_MeasureUnit where FMeasureUnitID in (179,181,183,185,187,189,214,227,334,338,5947)