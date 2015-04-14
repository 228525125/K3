-------������᰸���������񵥽��н᰸����
--drop procedure close_scrw

create procedure close_scrw
as
begin
create table #temp(
FBillNo nvarchar(255) default('')
)

Insert Into  #temp(FBillNo)
SELECT a.FBillNo
FROM ICMO a 
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID 
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2015-02-01' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=a.FInterID and b.FEntryID=k.FPPBomEntryID
where 1=1
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
and ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - (a.FQtyForItem+a.FQtyScrap) <> a.FStockQty    --���� + (2015-02-01֮�������) - ���ϱ��� - ��Ʒ���ϸ� <> ���
and a.FStatus in (1,2)        --�´�״̬
group by a.FBillNo
order by a.FBillNo

--2015-02-01�������̷����仯�����ϵ������ϵ�ͬʱ���ڣ�����У�2014-2-26 �� 2015-2-1 ͳ����������ʱ�����Ϸ���������������Ʒʱ�����ӣ�2015-2-1֮��ͳ�����������ͼ�������Ʒʱ�������Ϸ�����

update a set a.FStatus=3,a.FCheckerID=16469,a.FMrpClosed=1,a.FHandworkClose=1,a.FCloseDate=convert(char(10),getDate(),120),a.FNote=case when a.FNote like '%�Զ�%' then a.FNote else a.FNote+'<-�Զ��᰸->' end
FROM ICMO a 
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID 
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2013-02-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) n on n.FICMOInterID=a.FInterID and b.FEntryID=n.FPPBomEntryID           --��������,�����ж���ȫ����
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2015-02-01' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID           --�������ϣ������ж�����ƽ��
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=a.FInterID and b.FEntryID=k.FPPBomEntryID                                        --�������У������ж�����ƽ��
where 1=1
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
and ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - (a.FQtyForItem+a.FQtyScrap) = a.FStockQty    --���� - ���ϱ��� - ��Ʒ���� = ���
and b.FAuxStockQty+ISNULL(-n.FQty,0)+ISNULL(-k.FQty,0)>=FAuxQtyPick                 --ȫ�����ϣ�����+���� >= Ӧ��
and a.FStatus in (1,2)        --�´�״̬
and not exists(select * from #temp where a.FBillNo=FBillNo)
end

exec close_scrw
exec unclose_scrw



SELECT a.*
FROM ICMO a 
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID 
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID
where 1=1
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
and (b.FAuxStockQty/b.FAuxQtyScrap) - (b.FDiscardAuxQty/b.FAuxQtyScrap) + ISNULL(-e.FQty,0) - (a.FQtyForItem+a.FQtyScrap) = a.FStockQty    --���� - ���� = ���
and b.FAuxStockQty+ISNULL(-f.FQty,0)>=FAuxQtyPick                 --ȫ�����ϣ�����+���� >= Ӧ��
and a.FStatus in (1,2)        --�´�״̬
and not exists(select * from #temp where a.FBillNo=FBillNo)

drop table #temp

select FNote,* from ICMO 

sp_help ICMO

025563-2



SELECT a.FBillNo,ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) ,ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/b.FAuxQtyScrap,0) , ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) , (a.FQtyForItem+a.FQtyScrap) ,a.FStockQty
FROM ICMO a 
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID 
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=a.FInterID and b.FEntryID=k.FPPBomEntryID
where 1=1
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
and ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - (a.FQtyForItem+a.FQtyScrap) <> a.FStockQty    --���� - ���ϱ��� - ��Ʒ���ϸ� <> ���
and a.FStatus in (1,2)        --�´�״̬
and a.FBillNo='WORK035805'
--group by a.FBillNo
order by a.FBillNo



select 
ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - (a.FQtyForItem+a.FQtyScrap),
a.FStockQty
FROM ICMO a 
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID 
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2013-02-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) n on n.FICMOInterID=a.FInterID and b.FEntryID=n.FPPBomEntryID           --��������
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2015-02-01' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID           --��������
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=a.FInterID and b.FEntryID=k.FPPBomEntryID                                        --������������
where 1=1
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
and ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - (a.FQtyForItem+a.FQtyScrap) = a.FStockQty    --���� - ���ϱ��� - ��Ʒ���� = ���
and b.FAuxStockQty+ISNULL(-n.FQty,0)+ISNULL(-k.FQty,0)>=FAuxQtyPick                 --ȫ�����ϣ�����+���� >= Ӧ��
and a.FStatus in (1,2)        --�´�״̬
and a.FBillNo='WORK036655'

