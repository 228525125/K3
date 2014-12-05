--�������񵥣��������ı���
--drop procedure list_scrw_wlxh drop procedure list_scrw_wlxh_count

create procedure list_scrw_wlxh
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@style int
as
begin
SET NOCOUNT ON
create table #Data(
djbh nvarchar(255) default('')
,djzt nvarchar(255) default('')         --����״̬
,djrq nvarchar(255) default('')
,cpdm nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,cpgg nvarchar(255) default('')
,cpph nvarchar(255) default('')
,jhsl decimal(28,0) default(0)
,sqsl decimal(28,0) default(0)
,hgsl decimal(28,0) default(0)
,gfsl decimal(28,4) default(0)         --��������
,lfsl decimal(28,4) default(0)         --�Ϸ�����
,rksl decimal(28,0) default(0)
,wldm nvarchar(30) default('')          
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')       
,dwyl decimal(28,6) default(0)           
,llsl decimal(28,4) default(0)          
,bfsl decimal(28,4) default(0) 
,tlsl decimal(28,4) default(0)
,zzpsl decimal(28,4) default(0)
,hbsl decimal(28,4) default(0)          --����㱨
)

Insert Into #Data(djbh,djzt,djrq,cpdm,cpmc,cpgg,cpph,jhsl,sqsl,hgsl,gfsl,lfsl,rksl,wldm,wlmc,wlgg,dwyl,llsl,bfsl,tlsl,zzpsl,hbsl
)
SELECT a.FBillNo as 'djbh',case when a.FStatus=0 then '�ƻ�' when a.FStatus=5 then 'ȷ��' when a.FStatus=1 or a.FStatus=2 then '�´�' when a.FStatus=3 then '�᰸' else '' end as 'djzt'
,convert(char(10),a.FCheckDate,120) as  'djrq',g.FNumber as 'cpdm',g.FName as 'cpmc',g.FModel as 'cpgg',a.FGMPBatchNo as 'cpph',a.FQty as 'jhsl',ISNULL(c.FQty,0) as 'sqsl',FAuxQtyPass as 'hgsl',a.FQtyScrap as 'gfsl',a.FQtyForItem as 'lfsl',a.FStockQty as 'rksl',d.FNumber as 'wldm',d.FName as 'wlmc',d.FModel as 'wlgg',b.FAuxQtyScrap as 'dwyl',ROUND((b.FAuxStockQty+ISNULL(-f.FQty,0))/b.FAuxQtyScrap,0) as 'llsl',ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) as 'bfsl',case when e.FQty is null then ROUND(ISNULL(f.FQty,0)/b.FAuxQtyScrap,0) end as 'tlsl'
,ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - case when g.FProChkMde=352 then ISNULL(a.FAuxStockQty,0) else ISNULL(c.FQty,0) end as 'zzpsl'
,h.hbsl
FROM ICMO a 
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID 
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID
LEFT JOIN t_ICItem g on g.FItemID=a.FItemID
LEFT JOIN (select djbh,sum(hgsl) as hbsl from rss.dbo.scrw_gxhb group by djbh) h on h.djbh=a.FBillNo
where 1=1
--and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --�����ڲ�Ʒbom���ж���1��ԭ���ϣ�����Ʒ��ԭ����һһ��Ӧ��bomû�ж��ڵ�ԭ����
and left(d.FNumber,3)<>'08.'                        --�����ǰ�װ����
and b.FAuxQtyScrap > 0                              --��λ�����������0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --������λû��С�����
--and (b.FAuxStockQty/b.FAuxQtyScrap) - (b.FDiscardAuxQty/b.FAuxQtyScrap) + ISNULL(-e.FQty,0) * 0.9 < a.FStockQty    --���� - ���� = ���
--and b.FAuxStockQty+ISNULL(-f.FQty,0)>=FAuxQtyPick                 --ȫ�����ϣ�����+���� >= Ӧ��
--and a.FStatus in (1,2)        --�´�״̬
--and (left(d.FNumber,5)='07.05' or left(d.FNumber,5)='07.09')
and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'      --�������⹺���صİ��Ʒ
and a.FCheckDate>=@begindate and a.FCheckDate<=@enddate
AND (a.FBillNo like '%'+@query+'%' 
or d.FNumber like '%'+@query+'%' or d.FName like '%'+@query+'%' or d.FModel like '%'+@query+'%'
or g.FNumber like '%'+@query+'%' or g.FName like '%'+@query+'%' or g.FModel like '%'+@query+'%')
order by a.FBillNo,d.FNumber

if @style = 0 
select * from #Data
else
select cpdm,cpmc,cpgg,sum(zzpsl) from #Data where zzpsl<>0 group by cpdm,cpmc,cpgg
end


--count--
create procedure list_scrw_wlxh_count
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@style int
as
begin
SET NOCOUNT ON
create table #Data(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,cpdm nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,cpgg nvarchar(255) default('')
,cpph nvarchar(255) default('')
,jhsl decimal(28,0) default(0)
,sqsl decimal(28,0) default(0)
,hgsl decimal(28,0) default(0)
,rksl decimal(28,0) default(0)
,wldm nvarchar(30) default('')          
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')       
,dwyl decimal(28,6) default(0)           
,llsl decimal(28,4) default(0)          
,bfsl decimal(28,4) default(0) 
,tlsl decimal(28,4) default(0)
,zzpsl decimal(28,4) default(0)                  
)

Insert Into #Data(djbh,djrq,cpdm,cpmc,cpgg,cpph,jhsl,sqsl,hgsl,rksl,wldm,wlmc,wlgg,dwyl,llsl,bfsl,tlsl,zzpsl
)
SELECT a.FBillNo as 'djbh',convert(char(10),a.FCheckDate,120) as  'djrq',g.FNumber as 'cpdm',g.FName as 'cpmc',g.FModel as 'cpgg',a.FGMPBatchNo as 'cpph',a.FQty as 'jhsl',ISNULL(c.FQty,0) as 'sqsl',FAuxQtyPass as 'hgsl',a.FStockQty as 'rksl',d.FNumber as 'wldm',d.FName as 'wlmc',d.FModel as 'wlgg',b.FAuxQtyScrap as 'dwyl',ROUND((b.FAuxStockQty+ISNULL(-f.FQty,0))/b.FAuxQtyScrap,0) as 'llsl',ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) as 'bfsl',case when e.FQty is null then ROUND(ISNULL(f.FQty,0)/b.FAuxQtyScrap,0) end as 'tlsl'
,ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - case when g.FProChkMde=352 then ISNULL(a.FAuxStockQty,0) else ISNULL(c.FQty,0) end as 'zzpsl'
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
--and (b.FAuxStockQty/b.FAuxQtyScrap) - (b.FDiscardAuxQty/b.FAuxQtyScrap) + ISNULL(-e.FQty,0) * 0.9 < a.FStockQty    --���� - ���� = ���
--and b.FAuxStockQty+ISNULL(-f.FQty,0)>=FAuxQtyPick                 --ȫ�����ϣ�����+���� >= Ӧ��
--and a.FStatus in (1,2)        --�´�״̬
--and (left(d.FNumber,5)='07.05' or left(d.FNumber,5)='07.09')
and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'      --�������⹺���صİ��Ʒ
and a.FCheckDate>=@begindate and a.FCheckDate<=@enddate
AND (a.FBillNo like '%'+@query+'%' 
or d.FNumber like '%'+@query+'%' or d.FName like '%'+@query+'%' or d.FModel like '%'+@query+'%'
or g.FNumber like '%'+@query+'%' or g.FName like '%'+@query+'%' or g.FModel like '%'+@query+'%')
order by a.FBillNo,d.FNumber

if @style = 0 
select count(djbh) from #Data
else
select count(djbh) from #Data where zzpsl<>0
end



exec list_scrw_wlxh '','2013-01-01','2014-02-28',1

exec list_scrw_wlxh_count '','2013-07-01','2013-07-22',1



SELECT a.FBillNo,a.FItemID,a.FQty as '�ƻ�',ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) as '����',ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) as '����',b.FAuxQtyScrap as '��λ����',ROUND(ISNULL(e.FQty,0)/b.FAuxQtyScrap,0) as '����',ISNULL(c.FQty,0) as '��������',
a.FQty - (ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - case when f.FProChkMde=352 then ISNULL(a.FAuxStockQty,0) else ISNULL(c.FQty,0) end) as '������'
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
--and a.FQty - (ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --�ƻ� - (���� - ���� + ���ϣ�2013-06-26֮ǰ�� - ����)
--and a.FStatus in (1,2)        --�´�״̬
and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'      --�������⹺���صİ��Ʒ
and a.FBillNo = 'WORK023591'



execute list_scrw_wlxh 'F9385XB','2013-07-01','2013-07-22', 0


execute list_scrw_wlxh_count '','2013-07-01','2013-07-22',0

select FQtyForItem,FQtyScrap from ICMO where FBillNo='WORK024202-1'




