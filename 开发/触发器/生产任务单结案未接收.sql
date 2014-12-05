--对未接收的任务单，反结案
--DROP TRIGGER IC_JAWJS

CREATE TRIGGER IC_JAWJS ON ICMO
After UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)  and EXISTS(SELECT 1 FROM inserted where FStatus=3)
BEGIN
DECLARE @Count int
DECLARE @FBillNo nvarchar(255)
SELECT @FBillNo=FBillNo FROM inserted

update v1 set v1.FStatus=1
from ICMO v1 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID
LEFT JOIN (select b.FICMOBillNo,sum(b.FTranOutQty) as FTranOutQty from ICShop_SubcOut a inner join ICShop_SubcOutEntry b ON a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) c on v1.FBillNo=c.FICMOBillNo
LEFT JOIN (select b.FICMOBillNo,sum(b.FReceiveQty) as FReceiveQty from ICShop_SubcIn a inner join ICShop_SubcInEntry b on a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) d on v1.FBillNo=d.FICMOBillNo
where 1=1
and v1.FBillNo=@FBillNo
and ((c.FTranOutQty is not null and d.FReceiveQty is null) or (c.FTranOutQty is not null and c.FTranOutQty<>d.FReceiveQty))

select @Count=Count(*) from ICMO v1 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID
LEFT JOIN (select b.FICMOBillNo,sum(b.FTranOutQty) as FTranOutQty from ICShop_SubcOut a inner join ICShop_SubcOutEntry b ON a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) c on v1.FBillNo=c.FICMOBillNo
LEFT JOIN (select b.FICMOBillNo,sum(b.FReceiveQty) as FReceiveQty from ICShop_SubcIn a inner join ICShop_SubcInEntry b on a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) d on v1.FBillNo=d.FICMOBillNo
where 1=1
and v1.FBillNo=@FBillNo
and ((c.FTranOutQty is not null and d.FReceiveQty is null) or (c.FTranOutQty is not null and c.FTranOutQty<>d.FReceiveQty))

if @Count=0
update b set b.FStatus=4
from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on  a.FID=b.FID
where a.FSourceBillNo=@FBillNo 
and b.FIsOut<>1058

END



