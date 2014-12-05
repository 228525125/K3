--任务单根据批号自动生成炉号 ，经实验发现有问题，做转出单的时候报错
--DROP TRIGGER IC_SCRWD_LH

CREATE TRIGGER IC_SCRWD_LH ON ICMO
After INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(
SELECT 1 FROM inserted a 
WHERE 1=1 
AND not exists(select 1 from ICBomChild b where a.FBomInterID=b.FInterID and b.FEntryID=2)   --不存在产品bom里有多于1个原材料，即成品与原材料一一对应，bom没有多于的原材料
AND a.FGMPBatchNo is not null
AND a.FGMPBatchNo <>''
AND a.FGMPBatchNo <>'0'
)
BEGIN
DECLARE @FInterID int
DECLARE @PH nvarchar(255)
DECLARE @LH nvarchar(255)
SET @PH=''
SET @LH=''

Select @FInterID=a.FInterID,@PH=a.FGMPBatchNo, @LH=case when b.lh is null or b.lh = '' then c.lh else b.lh end
FROM inserted a
LEFT JOIN(select b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0  group by b.FBatchNo) b on a.FGMPBatchNo=b.ph
LEFT JOIN(select ph,max(lh) as lh from rss.dbo.pclh where ph is not null group by ph) c on a.FGMPBatchNo=c.ph


UPDATE ICMO SET FHeadSelfJ0187=@LH
WHERE FInterID=@FInterID
AND (FHeadSelfJ0187 is null OR FHeadSelfJ0187='')
END ELSE   --如果是组合件，就把炉号设为''
BEGIN
DECLARE @FID int
SELECT @FID=FInterID FROM inserted

UPDATE ICMO SET FHeadSelfJ0187=''
WHERE FInterID=@FID

END



select * from ICMO

select * from rss.dbo.pclh


select b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0 AND b.FBatchNo='1212'  group by b.FBatchNo

Select @FInterID=a.FInterID,@PH=a.FGMPBatchNocase, @LH=case when b.lh is null or b.lh = '' then c.lh else b.lh end
from inserted a
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN(select c.FNumber,b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0  group by c.FNumber,b.FBatchNo) b on i.FNumber=b.FNumber and a.FGMPBatchNo=b.ph
LEFT JOIN(select ph,max(lh) as lh from rss.dbo.pclh where ph is not null group by ph) c on a.FGMPBatchNo=c.ph

