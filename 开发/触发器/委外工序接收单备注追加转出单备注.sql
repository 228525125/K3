--自动把转出单备注导入接收单备注，后增加单价关联
--DROP TRIGGER IC_WWZC_BZ

CREATE TRIGGER IC_WWZC_BZ ON ICShop_SubcIn
After INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted


UPDATE u1 set u1.FText=ISnull(u1.FText,'')+' 《转出单备注》：'+zc.FNOTE 
FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (select v1.FBillNo,u1.FEntryID,FNOTE FROM  ICShop_SubcOut v1 INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID group by v1.FBillNo,u1.FEntryID,FNOTE) zc on u1.FSubcOutNo=zc.FBillNo and u1.FSubcOutEntryID=zc.FEntryID 
WHERE 1=1 
AND v1.FInterID=@FInterID 
AND zc.FNOTE is not null 
AND zc.FNOTE <> '' 
AND not(u1.FText like '%转出单备注%')


--将检验申请单单价关联到接收单上面
UPDATE u1 set u1.FUnitPrice=b.dj,u1.FBaseUnitPrice=b.dj,u1.FAmount=u1.FReceiveQty*b.dj 
FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
INNER JOIN ICShop_SubcOut a on u1.FSubcOutNo=a.FBillNo
INNER JOIN rss.dbo.wwzc_wwjysqd b on a.FInterID=b.FSourceInterID and u1.FSubcOutEntryID=b.FSourceEntryID 
WHERE 1=1 
AND v1.FInterID=@FInterID
AND b.dj is not null
END 





SELECT u1.FUnitPrice,u1.FBaseUnitPrice,u1.FAmount,u1.FReceiveQty,u1.*,b.* 
FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
INNER JOIN ICShop_SubcOut a on u1.FSubcOutNo=a.FBillNo
LEFT JOIN rss.dbo.wwzc_wwjysqd b on a.FInterID=b.FSourceInterID and u1.FSubcOutEntryID=b.FSourceEntryID
WHERE 1=1 
--AND v1.FInterID=@FInterID
--AND zc.FNOTE is not null 
--AND zc.FNOTE <> ''
and v1.FBillNo='WWJS003910'
--and not(v1.FInterID like '%00%')

select * from ICShop_SubcOut

select * from rss.dbo.wwzc_wwjysqd order by FDate desc

select FSubcOutNo,FSubcOutEntryID,o.FTranOutQty,o.FReceiptQty,* FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN (SELECT v1.FBillNo,u1.FEntryID,u1.FTranOutQty,u1.FReceiptQty FROM  ICShop_SubcOut v1 INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID group by v1.FBillNo,u1.FEntryID,u1.FTranOutQty,u1.FReceiptQty) o on u1.FSubcOutNo = o.FBillNo and u1.FSubcOutEntryID = o.FEntryID
where o.FTranOutQty < o.FReceiptQty


----------刷新单价----------
UPDATE u1 set u1.FUnitPrice=b.dj,u1.FBaseUnitPrice=b.dj,u1.FAmount=u1.FReceiveQty*b.dj 
FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
INNER JOIN ICShop_SubcOut a on u1.FSubcOutNo=a.FBillNo
INNER JOIN rss.dbo.wwzc_wwjysqd b on a.FInterID=b.FSourceInterID and u1.FSubcOutEntryID=b.FSourceEntryID 
WHERE 1=1 
AND b.dj is not null
and v1.FBillNo = 'WWJS004850'
