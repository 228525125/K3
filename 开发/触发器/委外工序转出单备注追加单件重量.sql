--委外转出备注追加单件重量
--DROP TRIGGER IC_WWZC_ZL

CREATE TRIGGER IC_WWZC_ZL ON ICShop_SubcOut
After UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted

UPDATE u1 set u1.FNote = cast(cast(p1.FAuxQtyScrap as decimal(18,4)) as nvarchar(255))+' kg/件 '
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN PPBOMEntry p1 on u1.FICMOInterID=p1.FICMOInterID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=p1.FUnitID 
where 1=1
and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=p1.FICMOInterID and bome.FEntryID=2)
and mu.FMeasureUnitID=173
and v1.FInterID=@FInterID
END




select * from PPBOMEntry where FICMOInterID='34011'


select * from t_MeasureUnit

select ISNull(u1.FNote,'')+' '+cast(cast(p1.FAuxQtyScrap as decimal(18,4)) as char(6))+' kg ' 
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN PPBOMEntry p1 on u1.FICMOInterID=p1.FICMOInterID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=p1.FUnitID 
where 1=1
and not exists(select 1 from PPBOM bom inner join PPBOMEntry bome on bom.FInterID=bome.FInterID where bome.FICMOInterID=p1.FICMOInterID and bome.FEntryID=2)
and mu.FMeasureUnitID=173
and v1.FBillNo ='wwzc004145'
