--工序流转卡生成时，自动从任务单导入炉号
--DROP TRIGGER IC_XSCK_LH

CREATE TRIGGER IC_XSCK_LH ON ICStockBill
After UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted WHERE FTranType=21 and FStatus=1)
BEGIN
UPDATE d SET d.FEntrySelfB0160=case when b.lh is null or b.lh = '' then c.lh else b.lh end
FROM inserted a 
INNER JOIN ICStockBillEntry d on a.FInterID=d.FInterID and d.FInterID>0
LEFT JOIN(select b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0  group by b.FBatchNo) b on d.FBatchNo=b.ph
LEFT JOIN(select ph,max(lh) as lh from rss.dbo.pclh where ph is not null group by ph) c on d.FBatchNo=c.ph
END 


SELECT case when b.lh is null or b.lh = '' then c.lh else b.lh end as lh 
FROM ICStockBill a 
INNER JOIN ICStockBillEntry d on a.FInterID=d.FInterID and d.FInterID>0
LEFT JOIN(select b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0  group by b.FBatchNo) b on d.FBatchNo=b.ph
LEFT JOIN(select ph,max(lh) as lh from rss.dbo.pclh where ph is not null group by ph) c on d.FBatchNo=c.ph
WHERE a.FBillNo='xout008534'

UPDATE d SET d.FEntrySelfB0160=case when b.lh is null or b.lh = '' then c.lh else b.lh end
FROM ICStockBill a 
INNER JOIN ICStockBillEntry d on a.FInterID=d.FInterID and d.FInterID>0
LEFT JOIN(select b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0  group by b.FBatchNo) b on d.FBatchNo=b.ph
LEFT JOIN(select ph,max(lh) as lh from rss.dbo.pclh where ph is not null group by ph) c on d.FBatchNo=c.ph