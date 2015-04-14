--��������������������FCheckCommitQty��FAuxCheckCommitQty��,���������� = �ƻ� - (���� + ���ϣ�2015-02-01֮�� - ���� - ����)����װ���������������ϵ���ˡ�����ˣ���������������ˡ�����ˣ��������뱣�桢ɾ�������������´
--drop procedure compute_scrw_yjsl

create procedure compute_scrw_yjsl
as
begin
create table #temp(
FBillNo nvarchar(20) default('')
,fssl decimal(28,2) default(0)
)

Insert Into #temp(FBillNo,fssl
)
SELECT a.FBillNo,
max(a.FQty - (ROUND(case when (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0))>b.FAuxQtyMust then b.FAuxQtyMust else (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0)) end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0))) as '������'        --max��ʾ�ಿ��������£�ȡ�������Ĳ������м���
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2015-02-01' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=a.FInterID and b.FEntryID=k.FPPBomEntryID
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
where 1=1
and b.FAuxQtyMust>0                  --�ƻ�Ͷ����������0 ��ʾȡ��Ͷ�ϣ���˲��μӼ���
--and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --�����ڲ�Ʒbom���ж���1��ԭ���ϣ�����Ʒ��ԭ����һһ��Ӧ��bomû�ж��ڵ�ԭ����
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
and a.FQty -(ROUND(case when (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0))>b.FAuxQtyMust then b.FAuxQtyMust else (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0)) end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --�ƻ� - (���� + ���ϣ�2015-02-01֮�� - ���� - ����)
--and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) >= 0       --������Ϊ��������Ϊ�ж����ϵ������2013-09-27��ע�ͣ���Ϊ��������ᵼ��FCheckCommitQty�������
and a.FStatus in (1,2)        --�´�״̬
and i.FProChkMde=353         --��Ʒ���鷽ʽΪ���
and a.FCheckDate>='2014-01-01'   --֮ǰ��ʱ����2013-06-01��֮�����޸�ʱ������Ϊ֮ǰ�����Ƕಿ�������
and i.FNumber <>'05.03.0105'
and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040' and d.FNumber<>'06.04.0049' and d.FNumber<>'06.07.0111' and d.FNumber <>'06.07.0108' and d.FNumber <>'06.07.0107'
and a.FBillNo<>'WORK027512'   --���ⵥ��
and a.FBillNo<>'WORK028370'
and a.FBillNo<>'WORK029282'
and a.FBillNo<>'WORK029291'
group by a.FBillNo

update a set a.FCheckCommitQty=b.fssl,FAuxCheckCommitQty=b.fssl
from ICMO a 
inner join #temp b on a.FBillNo=b.FBillNo

end


exec compute_scrw_yjsl









SELECT a.FBillNo,a.FItemID,b.FEntryID,a.FQty as '�ƻ�',ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) as '����',ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) as '����',b.FAuxQtyScrap as '��λ����',ROUND(ISNULL(e.FQty,0)/b.FAuxQtyScrap,0) as '����',ISNULL(c.FQty,0) as '��������',
a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)) as '������',a.FCheckCommitQty
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
LEFT JOIN t_ICItem f on a.FItemID=f.FItemID
where 1=1
and b.FAuxQtyMust>0                  --�ƻ�Ͷ����������0 ��ʾȡ��Ͷ�ϣ���˲��μӼ���
--and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --�����ڲ�Ʒbom���ж���1��ԭ���ϣ�����Ʒ��ԭ����һһ��Ӧ��bomû�ж��ڵ�ԭ����
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --�ƻ� - (���� - ���� + ���ϣ�2013-06-26֮ǰ�� - ����)
--and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) >= 0       --������Ϊ��������Ϊ�ж����ϵ������2013-09-27��ע�ͣ���Ϊ��������ᵼ��FCheckCommitQty�������
and a.FStatus in (1,2)        --�´�״̬
and f.FProChkMde=353         --��Ʒ���鷽ʽΪ���
and f.FNumber <>'05.03.0105'
and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040' and d.FNumber<>'06.04.0049' and d.FNumber<>'06.07.0111' and d.FNumber <>'06.07.0108' and d.FNumber <>'06.07.0107'
and a.FBillNo<>'work027512'
and a.FBillNo<>'WORK028370'
and a.FBillNo<>'WORK029282'
and a.FBillNo<>'WORK029291'
and a.FBillNo = 'WORK030966'
and a.FCheckDate>='2014-01-01'       
and ISNULL(c.FQty,0)=0



---------------
SELECT a.FBillNo,
max(a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0))) as '������'
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
LEFT JOIN t_ICItem f on a.FItemID=f.FItemID
where 1=1
and b.FAuxQtyMust>0                  --�ƻ�Ͷ����������0 ��ʾȡ��Ͷ�ϣ���˲��μӼ���
--and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --�����ڲ�Ʒbom���ж���1��ԭ���ϣ�����Ʒ��ԭ����һһ��Ӧ��bomû�ж��ڵ�ԭ����
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --�ƻ� - (���� - ���� + ���ϣ�2013-06-26֮ǰ�� - ����)
--and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) >= 0       --������Ϊ��������Ϊ�ж����ϵ������2013-09-27��ע�ͣ���Ϊ��������ᵼ��FCheckCommitQty�������
and a.FStatus in (1,2)        --�´�״̬
and f.FProChkMde=353         --��Ʒ���鷽ʽΪ���
and a.FCheckDate>='2014-01-01'   --֮ǰ��ʱ����2013-06-01��֮�����޸�ʱ������Ϊ֮ǰ�����Ƕಿ�������
and f.FNumber <>'05.03.0105'
and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040' and d.FNumber<>'06.04.0049' and d.FNumber<>'06.07.0111' and d.FNumber <>'06.07.0108' and d.FNumber <>'06.07.0107'
and a.FBillNo<>'WORK027512'   --���ⵥ��
and a.FBillNo<>'WORK028370'
and a.FBillNo<>'WORK029282'
and a.FBillNo<>'WORK029291'
and a.FBillNo = 'WORK030966'
group by a.FBillNo



select FCheckCommitQty from ICMO where FBillNo='WORK030966'
update ICMO set FCheckCommitQty=0,FAuxCheckCommitQty=0 where FBillNo = 'WORK030966'


select FNumber from t_ICItem where FItemID=1178


select * from ICMO where FCheckCommitQty<0 or FAuxCheckCommitQty<0

update ICMO set FCheckCommitQty=0,FAuxCheckCommitQty=0 where FCheckCommitQty<0 or FAuxCheckCommitQty<0

select FCheckCommitQty,* from ICMO where FBillNo='WORK029069-1'

update ICMO set FCheckCommitQty=0,FAuxCheckCommitQty=0 where FBillNo='WORK029069-1'

select ROUND(1748.58, 0) 


---ԭ����
UPDATE a SET a.FCheckCommitQty=case when (a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)))<0 then 0 else a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)) end ,a.FAuxCheckCommitQty=case when (a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)))<0 then 0 else a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)) end
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
LEFT JOIN t_ICItem f on a.FItemID=f.FItemID
where 1=1
--and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --�����ڲ�Ʒbom���ж���1��ԭ���ϣ�����Ʒ��ԭ����һһ��Ӧ��bomû�ж��ڵ�ԭ����
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --�ƻ� - (���� - ���� + ���ϣ�2013-06-26֮ǰ�� - ����)
--and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) >= 0       --������Ϊ��������Ϊ�ж����ϵ������2013-09-27��ע�ͣ���Ϊ��������ᵼ��FCheckCommitQty�������
and a.FStatus in (1,2)        --�´�״̬
and f.FProChkMde=353         --��Ʒ���鷽ʽΪ���
and a.FCheckDate>='2013-04-01'   --֮ǰ��ʱ����2013-06-01��֮�����޸�ʱ������Ϊ֮ǰ�����Ƕಿ�������
and f.FNumber <>'05.03.0105'
and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040' and d.FNumber<>'06.04.0049' and d.FNumber<>'06.07.0111' and d.FNumber <>'06.07.0108' and d.FNumber <>'06.07.0107'
and a.FBillNo<>'WORK027512'   --���ⵥ��
and a.FBillNo<>'WORK028370'
and a.FBillNo<>'WORK029282'
and a.FBillNo<>'WORK029291'
---end




select * from thcx where gsth='pm9080cd'

select * from thcx WHERE RQ='2014-05-19'

update thcx set gsth='PM9080BD' where gsth='pm9080cd'

delete thcx where id=7299






SELECT a.FBillNo,
a.FQty as '�ƻ�',
ROUND(case when (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0))>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) as '����',
ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) as '����', 
ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) as '����', 
ISNULL(c.FQty,0) as '����', 
a.FCheckCommitQty,
a.FQty -(ROUND(case when (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0))>b.FAuxQtyMust then b.FAuxQtyMust else (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0)) end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0))
--max(a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0))) as '������'
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and b.FSCStockID<>5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=a.FInterID and b.FEntryID=k.FPPBomEntryID
--LEFT JOIN t_ICItem f on a.FItemID=f.FItemID
where 1=1
and b.FAuxQtyMust>0                  --�ƻ�Ͷ����������0 ��ʾȡ��Ͷ�ϣ���˲��μӼ���
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and a.FQty -(ROUND(case when (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0))>b.FAuxQtyMust then b.FAuxQtyMust else (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0)) end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --�ƻ� - (���� - ���� + ���ϣ�2013-06-26֮ǰ�� - ����)
and a.FStatus in (1,2)        --�´�״̬
and a.FCheckDate>='2015-01-01'   --֮ǰ��ʱ����2013-06-01��֮�����޸�ʱ������Ϊ֮ǰ�����Ƕಿ�������
and a.FBillNo='WORK036684'
--group by a.FBillNo



select * FROM ICMO a
