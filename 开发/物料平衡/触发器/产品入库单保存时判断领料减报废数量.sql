--此触发器在产品入库时，判断入库数量 > 领料数量 - 报废数量
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
	and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=c.FICMOInterID and bome.FEntryID=2 and bom.FItemID=b.FItemID)        --不存在产品bom里有多于1个原材料，即成品与原材料一一对应，bom没有多于的原材料
	and a.FTranType=2
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) - ROUND((c.FDiscardAuxQty)/c.FAuxQtyScrap,0) - ISNULL(o.FAuxStockQty,0) < b.FQty         --已领料数量-已报废数量-已入库数量 < 当前入库数量
	and left(d.FNumber,3)<>'08.'                            --不考虑包装材料
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --计量单位没有小数点的
	and a.FStatus=0                    --单据保存时判断
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'    --不考虑外购称重的半成品
)
RAISERROR (50022,16,1 )
END






SELECT 
ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) as '领料', 
ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) as '退料',
ROUND((c.FDiscardAuxQty)/c.FAuxQtyScrap,0) as '报废', 
ISNULL(o.FAuxStockQty,0) as '入库',
ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) - ROUND((c.FDiscardAuxQty)/c.FAuxQtyScrap,0) - ISNULL(o.FAuxStockQty,0) as '结果'
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
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) - ROUND((c.FDiscardAuxQty)/c.FAuxQtyScrap,0) - ISNULL(o.FAuxStockQty,0) < b.FQty         --已领料数量-已报废数量-已入库数量 < 当前入库数量
	and left(d.FNumber,3)<>'08.'                            --不考虑包装材料
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --计量单位没有小数点的
	and a.FStatus=0                    --单据保存时判断
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'    --不考虑外购称重的半成品
	and a.FBillNo='CIN010781'

