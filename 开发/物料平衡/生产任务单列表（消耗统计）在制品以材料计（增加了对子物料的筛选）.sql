--增加对子物料的筛选
--drop procedure list_scrw_wlxh_querySub

create procedure list_scrw_wlxh_querySub
@query varchar(50),
@querySub varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@style int
as
begin
SET NOCOUNT ON
create table #Data(
djbh nvarchar(255) default('')
,djzt nvarchar(255) default('')         --任务单状态
,djrq nvarchar(255) default('')
,cpdm nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,cpgg nvarchar(255) default('')
,cpph nvarchar(255) default('')
,jhsl decimal(28,0) default(0)
,sqsl decimal(28,0) default(0)
,hgsl decimal(28,0) default(0)
,bhgsl decimal(28,4) default(0)        --不合格数量
,gfsl decimal(28,4) default(0)         --工废数量
,lfsl decimal(28,4) default(0)         --料废数量
,rksl decimal(28,0) default(0)
,rkrq nvarchar(255) default('')         --入库日期          
,wldm nvarchar(30) default('')          
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')       
,dwyl decimal(28,6) default(0)           
,llsl decimal(28,4) default(0)          
,bfsl decimal(28,4) default(0) 
,tlsl decimal(28,4) default(0)
,zzpsl decimal(28,4) default(0)
,hbsl decimal(28,4) default(0)          --工序汇报
,jhtlsl decimal(28,4) default(0)        --计划投料数量
,ddbh nvarchar(255) default('')           
,jhrq nvarchar(255) default('')
,ddsl decimal(28,4) default(0)
,jhwgrq nvarchar(255) default('')       --计划完工日期          
,jarq nvarchar(255) default('')         --结案日期          
,bz nvarchar(255) default('')           --备注          
)

Insert Into #Data(djbh,djzt,djrq,cpdm,cpmc,cpgg,cpph,jhsl,sqsl,hgsl,bhgsl,gfsl,lfsl,rksl,rkrq,wldm,wlmc,wlgg,dwyl,llsl,bfsl,tlsl,zzpsl,hbsl,jhtlsl,ddbh,jhrq,ddsl,jhwgrq,jarq,bz
)
SELECT a.FBillNo as 'djbh',case when a.FStatus=0 then '计划' when a.FStatus=5 then '确认' when a.FStatus=1 or a.FStatus=2 then '下达' when a.FStatus=3 then '结案' else '' end as 'djzt'
,convert(char(10),a.FCheckDate,120) as  'djrq',g.FNumber as 'cpdm',g.FName as 'cpmc',g.FModel as 'cpgg',a.FGMPBatchNo as 'cpph',a.FQty as 'jhsl',ISNULL(c.FQty,0) as 'sqsl',FAuxQtyPass as 'hgsl',ISNULL(c.FQty,0)-FAuxQtyPass as 'bhgsl',a.FQtyScrap as 'gfsl',a.FQtyForItem as 'lfsl',a.FStockQty as 'rksl',convert(char(10),e.FDate,120) as 'rkrq',d.FNumber as 'wldm',d.FName as 'wlmc',d.FModel as 'wlgg',b.FAuxQtyScrap as 'dwyl',b.FAuxStockQty+ISNULL(-k.FQty,0)+ISNULL(-l.FQty,0) as 'llsl',b.FDiscardAuxQty as 'bfsl',ISNULL(f.FQty,0) as 'tlsl'
,(ROUND((b.FAuxStockQty+ISNULL(-k.FQty,0)+ISNULL(-l.FQty,0))/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - case when g.FProChkMde=352 then ISNULL(a.FAuxStockQty,0) else ISNULL(c.FQty,0) end)*b.FAuxQtyScrap as 'zzpsl'
,h.hbsl,b.FAuxQtyMust as 'jhtlsl',j.FBillNo as 'ddbh',convert(char(10),j.FDate,120) as 'jhrq',j.FQty as 'ddsl',convert(char(10),a.FPlanFinishDate,120) as 'jhwgrq',convert(char(10),a.FCloseDate,120) as 'jarq',a.FNote as 'bz'
FROM ICMO a 
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID 
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,MAX(a.FDate) as FDate from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=2 AND a.FCancellation = 0 AND a.FStatus = 1 group by b.FICMOInterID) e on e.FICMOInterID=a.FInterID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and b.FSCStockID<>5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2015-02-01' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) l on l.FICMOInterID=a.FInterID and b.FEntryID=l.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=a.FInterID and b.FEntryID=k.FPPBomEntryID
LEFT JOIN t_ICItem g on g.FItemID=a.FItemID 
LEFT JOIN (select djbh,sum(hgsl) as hbsl from rss.dbo.scrw_gxhb group by djbh) h on h.djbh=a.FBillNo
LEFT JOIN (select v1.FInterID, v1.FBillNo, u1.FItemID,convert(char(10),MIN(u1.FDate),120) as FDate,sum(u1.FQty) as FQty from SEOrder v1 INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 where v1.FCancellation = 0 and v1.FStatus>0 group by v1.FInterID, v1.FBillNo, u1.FItemID) j on j.FInterID=a.FOrderInterID and a.FItemID=j.FItemID
where 1=1
--and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --不存在产品bom里有多于1个原材料，即成品与原材料一一对应，bom没有多于的原材料
and left(d.FNumber,3)<>'08.'                        --不考虑包装材料
and b.FAuxQtyScrap > 0                              --单位用量必须大于0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --计量单位没有小数点的
--and ((b.FAuxStockQty+ISNULL(-k.FQty,0)+ISNULL(-l.FQty,0))/b.FAuxQtyScrap) - (b.FDiscardAuxQty/b.FAuxQtyScrap) < a.FStockQty    --已领 - 报废 = 入库
--and b.FAuxStockQty+ISNULL(-k.FQty,0)+ISNULL(-l.FQty,0)+ISNULL(-f.FQty,0)>=FAuxQtyPick                 --全部领料；已领+退料 >= 应发
--and a.FStatus in (1,2)        --下达状态
--and (left(d.FNumber,5)='07.05' or left(d.FNumber,5)='07.09')
and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'      --不考虑外购称重的半成品
and a.FPlanFinishDate>=@begindate and a.FPlanFinishDate<=@enddate
AND (a.FBillNo like '%'+@query+'%' or a.FGMPBatchNo like '%'+@query+'%' 
or g.FNumber like '%'+@query+'%' or g.FName like '%'+@query+'%' or g.FModel like '%'+@query+'%' or g.FHelpCode like '%'+@query+'%'
or j.FBillNo like '%'+@query+'%')
AND (d.FNumber like '%'+@querySub+'%' or d.FName like '%'+@querySub+'%' or d.FModel like '%'+@querySub+'%' or d.FHelpCode like '%'+@querySub+'%')
order by a.FBillNo,d.FNumber

if @style = 0 
select * from #Data
else
select * from #Data where zzpsl<>0
end




SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID where a.FICMOInterID=37434 group by a.FICMOInterID
select a.FROB,b.FICMOInterID,MAX(a.FDate) as FDate from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID 
where 1=1
and a.FTranType=2 AND a.FCancellation = 0 AND a.FStatus = 1 
--AND a.FROB=-1 
and b.FICMOInterID=37434 
group by b.FICMOInterID

select * from icmo where FBillNo='work035768'


select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID

select b.FICMOInterID,b.FPPBomEntryID,b.FQty,a.FBillNo from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID

