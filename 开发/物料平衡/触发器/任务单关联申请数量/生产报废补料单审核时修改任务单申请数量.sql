--此触发器在生产报废补料单时，自动更新生产任务单FCheckCommitQty和FAuxCheckCommitQty的值，以达到送检数量=计划-退料-报废-已送检
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

SELECT a.FBillNo,a.FItemID,a.FQty as '计划',b.FAuxStockQty as '已领',b.FDiscardAuxQty as '报废',b.FAuxQtyScrap as '单位用量',ISNULL(e.FQty,0) as '退料',ISNULL(c.FQty,0) as '关联申请',
a.FQty - ((b.FAuxStockQty/b.FAuxQtyScrap) - (b.FDiscardAuxQty/b.FAuxQtyScrap) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)) as '计算结果'
FROM ICMO a
INNER JOIN PPBOMEntry b on b.FICMOInterID=a.FInterID
LEFT JOIN (SELECT a.FICMOInterID,sum(b.FQty) as FQty FROM QMICMOCKRequest a INNER JOIN QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID) c on c.FICMOInterID=a.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) e on e.FICMOInterID=a.FInterID and b.FEntryID=e.FPPBomEntryID
where 1=1
and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=b.FICMOInterID and bome.FEntryID=2 and bom.FItemID=a.FItemID)   --不存在产品bom里有多于1个原材料，即成品与原材料一一对应，bom没有多于的原材料
and left(d.FNumber,3)<>'08.'                        --不考虑包装材料
and b.FAuxQtyScrap > 0                              --单位用量必须大于0
and b.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)           --计量单位没有小数点的
and a.FQty - ((b.FAuxStockQty/b.FAuxQtyScrap) - (b.FDiscardAuxQty/b.FAuxQtyScrap) + ISNULL(-e.FQty,0) - ISNULL(c.FQty,0)) <> a.FCheckCommitQty   --计划 - (已领 - 报废 + 退料（2013-06-26之前） - 申请)
and a.FStatus in (1,2)        --下达状态




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