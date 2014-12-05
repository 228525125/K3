--�˴��������������񱨷ϲ��ϵ�ʱ���ж�����������-�������� < �������*��λ����
--DROP TRIGGER IC_SCRWBFD

CREATE TRIGGER IC_SCRWBFD ON ICItemScrap    
FOR INSERT,UPDATE
AS
BEGIN
SET NOCOUNT ON
IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 
	LEFT JOIN ICMO f on b.FICMOInterID=f.FInterID
	LEFT JOIN t_ICItem g on f.FItemID=g.FItemID
	WHERE 1=1 
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0)-ROUND((c.FDiscardAuxQty-b.FQty)/c.FAuxQtyScrap,0) < case when g.FProChkMde=352 then ISNULL(f.FAuxStockQty,0) else ISNULL(e.FQty,0) end         --����������-�ѱ�������-��ǰ���� < �������*��λ���� 
	and left(d.FNumber,3)<>'08.'                            --�����ǰ�װ����
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --������λû��С�����
	and c.FItemID=b.FItemID            --�жϾ��嵽һ������
	and a.FStatus=0                    --���ݱ���ʱ�ж�
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'    --�������⹺���صİ��Ʒ
)
RAISERROR (50021,16,1 )

IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 
	LEFT JOIN ICMO f on b.FICMOInterID=f.FInterID
	LEFT JOIN t_ICItem g on f.FItemID=g.FItemID
	WHERE 1=1 
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0)-ROUND(FDiscardAuxQty/c.FAuxQtyScrap,0) < case when g.FProChkMde=352 then ISNULL(f.FAuxStockQty,0) else ISNULL(e.FQty,0) end         --����������-�������� < �������*��λ����   f.qty���ϷϿ�ĺ���������������Ϊ֮ǰ���������뱨�ϵ��ظ��ˣ����������2013-06-26�տ�ʼ�Ĺ���
	and left(d.FNumber,3)<>'08.'                            --�����ǰ�װ����
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --������λû��С�����
	and c.FItemID=b.FItemID            --�жϾ��嵽һ������
	and a.FStatus=1                    --�������ʱ�жϣ���Ϊ���ʱc.FDiscardAuxQty�������α�������
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'      --�������⹺���صİ��Ʒ
)
RAISERROR (50021,16,1 )
END



select b.* from ICItemScrap a left join ICItemScrapEntry b on a.FInterID=b.FInterID





	SELECT c.FAuxStockQty,b.FQty,e.FQty,c.FAuxQtyScrap FROM ICItemScrap a 
	INNER JOIN ICItemScrapEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 
	WHERE 1=1 
	--and c.FAuxStockQty-c.FDiscardAuxQty-b.FQty < e.FQty * c.FAuxQtyScrap         --����������-�������� < �������*��λ���� 
	and left(d.FNumber,3)<>'08.'                            --�����ǰ�װ����
	and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --������λû��С�����
	and c.FItemID=b.FItemID
	and a.FBillNo='FSC003353'

