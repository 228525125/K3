--�����������ϲ�ƽ������
--drop procedure list_scrw_xy

create procedure list_scrw_xy
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10)
as
begin
SELECT a.FBillNo,convert(char(10),a.FCheckDate,120) as FDate,g.FNumber,g.FName,g.FModel,a.FQty as '�ƻ�',ISNULL(c.FQty,0) as '��������',FAuxQtyPass as '�ϸ�',a.FStockQty as '���',d.FNumber,d.FName,d.FModel,b.FAuxQtyScrap as '��λ����',ROUND((b.FAuxStockQty+ISNULL(-f.FQty,0))/b.FAuxQtyScrap,0) as '����',ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) as '����',case when e.FQty is null then ROUND(ISNULL(f.FQty,0)/b.FAuxQtyScrap,0) end as '����'
,ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - case when g.FProChkMde=352 then ISNULL(a.FAuxStockQty,0) else ISNULL(c.FQty,0) end as '����Ʒ'
FROM ICMO a 
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID 
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID
LEFT JOIN t_ICItem g on g.FItemID=a.FItemID
where 1=1
--and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --�����ڲ�Ʒbom���ж���1��ԭ���ϣ�����Ʒ��ԭ����һһ��Ӧ��bomû�ж��ڵ�ԭ����
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
and ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) * 0.9 < a.FStockQty    --���� - ���� = ���
and a.FStatus in (1,2)        --�´�״̬
and a.FCheckDate>=@begindate and a.FCheckDate<=@enddate
AND (a.FBillNo like '%'+@query+'%' 
or d.FNumber like '%'+@query+'%' or d.FName like '%'+@query+'%' or d.FModel like '%'+@query+'%'
or g.FNumber like '%'+@query+'%' or g.FName like '%'+@query+'%' or g.FModel like '%'+@query+'%')
order by a.FBillNo,d.FNumber
end


exec list_scrw_xy '','2013-07-01','2013-07-31'


select * from ICMO where FBillNo in ('work030456','work030455')

update ICMO set FStatus=1 where FBillNo in ('work030456','work030455')