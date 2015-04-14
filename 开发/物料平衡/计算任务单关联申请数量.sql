--计算任务单已申请数量（FCheckCommitQty、FAuxCheckCommitQty）,已申请数量 = 计划 - (已领 + 退料（2015-02-01之后） - 报废 - 申请)，安装触发器：生产报废单审核、反审核；生产领料退料审核、反审核；检验申请保存、删除；生产任务单下达；
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
max(a.FQty - (ROUND(case when (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0))>b.FAuxQtyMust then b.FAuxQtyMust else (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0)) end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0))) as '计算结果'        --max表示多部件的情况下，取领料最多的部件进行计算
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2015-02-01' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=a.FInterID and b.FEntryID=k.FPPBomEntryID
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
where 1=1
and b.FAuxQtyMust>0                  --计划投料数量等于0 表示取消投料，因此不参加计算
--and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --不存在产品bom里有多于1个原材料，即成品与原材料一一对应，bom没有多于的原材料
and left(d.FNumber,3)<>'08.'                        --不考虑包装材料
and b.FAuxQtyScrap > 0                              --单位用量必须大于0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --计量单位没有小数点的
and a.FQty -(ROUND(case when (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0))>b.FAuxQtyMust then b.FAuxQtyMust else (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0)) end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --计划 - (已领 + 退料（2015-02-01之后） - 报废 - 申请)
--and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) >= 0       --计算结果为负数，因为有多领料的情况；2013-09-27被注释，因为这个条件会导致FCheckCommitQty不会更新
and a.FStatus in (1,2)        --下达状态
and i.FProChkMde=353         --产品检验方式为抽检
and a.FCheckDate>='2014-01-01'   --之前的时间是2013-06-01，之所以修改时间是因为之前不考虑多部件的情况
and i.FNumber <>'05.03.0105'
and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040' and d.FNumber<>'06.04.0049' and d.FNumber<>'06.07.0111' and d.FNumber <>'06.07.0108' and d.FNumber <>'06.07.0107'
and a.FBillNo<>'WORK027512'   --问题单据
and a.FBillNo<>'WORK028370'
and a.FBillNo<>'WORK029282'
and a.FBillNo<>'WORK029291'
group by a.FBillNo

update a set a.FCheckCommitQty=b.fssl,FAuxCheckCommitQty=b.fssl
from ICMO a 
inner join #temp b on a.FBillNo=b.FBillNo

end


exec compute_scrw_yjsl









SELECT a.FBillNo,a.FItemID,b.FEntryID,a.FQty as '计划',ROUND(b.FAuxStockQty/b.FAuxQtyScrap,0) as '已领',ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) as '报废',b.FAuxQtyScrap as '单位用量',ROUND(ISNULL(e.FQty,0)/b.FAuxQtyScrap,0) as '退料',ISNULL(c.FQty,0) as '关联申请',
a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)) as '计算结果',a.FCheckCommitQty
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
LEFT JOIN t_ICItem f on a.FItemID=f.FItemID
where 1=1
and b.FAuxQtyMust>0                  --计划投料数量等于0 表示取消投料，因此不参加计算
--and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --不存在产品bom里有多于1个原材料，即成品与原材料一一对应，bom没有多于的原材料
and left(d.FNumber,3)<>'08.'                        --不考虑包装材料
and b.FAuxQtyScrap > 0                              --单位用量必须大于0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --计量单位没有小数点的
and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --计划 - (已领 - 报废 + 退料（2013-06-26之前） - 申请)
--and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) >= 0       --计算结果为负数，因为有多领料的情况；2013-09-27被注释，因为这个条件会导致FCheckCommitQty不会更新
and a.FStatus in (1,2)        --下达状态
and f.FProChkMde=353         --产品检验方式为抽检
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
max(a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0))) as '计算结果'
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
LEFT JOIN t_ICItem f on a.FItemID=f.FItemID
where 1=1
and b.FAuxQtyMust>0                  --计划投料数量等于0 表示取消投料，因此不参加计算
--and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --不存在产品bom里有多于1个原材料，即成品与原材料一一对应，bom没有多于的原材料
and left(d.FNumber,3)<>'08.'                        --不考虑包装材料
and b.FAuxQtyScrap > 0                              --单位用量必须大于0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --计量单位没有小数点的
and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --计划 - (已领 - 报废 + 退料（2013-06-26之前） - 申请)
--and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) >= 0       --计算结果为负数，因为有多领料的情况；2013-09-27被注释，因为这个条件会导致FCheckCommitQty不会更新
and a.FStatus in (1,2)        --下达状态
and f.FProChkMde=353         --产品检验方式为抽检
and a.FCheckDate>='2014-01-01'   --之前的时间是2013-06-01，之所以修改时间是因为之前不考虑多部件的情况
and f.FNumber <>'05.03.0105'
and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040' and d.FNumber<>'06.04.0049' and d.FNumber<>'06.07.0111' and d.FNumber <>'06.07.0108' and d.FNumber <>'06.07.0107'
and a.FBillNo<>'WORK027512'   --问题单据
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


---原代码
UPDATE a SET a.FCheckCommitQty=case when (a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)))<0 then 0 else a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)) end ,a.FAuxCheckCommitQty=case when (a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)))<0 then 0 else a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)) end
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
LEFT JOIN t_ICItem f on a.FItemID=f.FItemID
where 1=1
--and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --不存在产品bom里有多于1个原材料，即成品与原材料一一对应，bom没有多于的原材料
and left(d.FNumber,3)<>'08.'                        --不考虑包装材料
and b.FAuxQtyScrap > 0                              --单位用量必须大于0
--and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --计量单位没有小数点的
and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --计划 - (已领 - 报废 + 退料（2013-06-26之前） - 申请)
--and a.FQty -(ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) >= 0       --计算结果为负数，因为有多领料的情况；2013-09-27被注释，因为这个条件会导致FCheckCommitQty不会更新
and a.FStatus in (1,2)        --下达状态
and f.FProChkMde=353         --产品检验方式为抽检
and a.FCheckDate>='2013-04-01'   --之前的时间是2013-06-01，之所以修改时间是因为之前不考虑多部件的情况
and f.FNumber <>'05.03.0105'
and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040' and d.FNumber<>'06.04.0049' and d.FNumber<>'06.07.0111' and d.FNumber <>'06.07.0108' and d.FNumber <>'06.07.0107'
and a.FBillNo<>'WORK027512'   --问题单据
and a.FBillNo<>'WORK028370'
and a.FBillNo<>'WORK029282'
and a.FBillNo<>'WORK029291'
---end




select * from thcx where gsth='pm9080cd'

select * from thcx WHERE RQ='2014-05-19'

update thcx set gsth='PM9080BD' where gsth='pm9080cd'

delete thcx where id=7299






SELECT a.FBillNo,
a.FQty as '计划',
ROUND(case when (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0))>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) as '已领',
ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) as '报废', 
ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) as '退料', 
ISNULL(c.FQty,0) as '申请', 
a.FCheckCommitQty,
a.FQty -(ROUND(case when (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0))>b.FAuxQtyMust then b.FAuxQtyMust else (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0)) end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0))
--max(a.FQty - (ROUND(case when b.FAuxStockQty>b.FAuxQtyMust then b.FAuxQtyMust else b.FAuxStockQty end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0))) as '计算结果'
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and b.FSCStockID<>5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=a.FInterID and b.FEntryID=f.FPPBomEntryID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=a.FInterID and b.FEntryID=k.FPPBomEntryID
--LEFT JOIN t_ICItem f on a.FItemID=f.FItemID
where 1=1
and b.FAuxQtyMust>0                  --计划投料数量等于0 表示取消投料，因此不参加计算
and left(d.FNumber,3)<>'08.'                        --不考虑包装材料
and b.FAuxQtyScrap > 0                              --单位用量必须大于0
--and a.FQty -(ROUND(case when (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0))>b.FAuxQtyMust then b.FAuxQtyMust else (b.FAuxStockQty + ISNULL(-f.FQty,0) + ISNULL(-k.FQty,0)) end/b.FAuxQtyScrap,0) - ROUND(b.FDiscardAuxQty/b.FAuxQtyScrap,0) + ROUND(ISNULL(-e.FQty,0)/b.FAuxQtyScrap,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --计划 - (已领 - 报废 + 退料（2013-06-26之前） - 申请)
and a.FStatus in (1,2)        --下达状态
and a.FCheckDate>='2015-01-01'   --之前的时间是2013-06-01，之所以修改时间是因为之前不考虑多部件的情况
and a.FBillNo='WORK036684'
--group by a.FBillNo



select * FROM ICMO a
