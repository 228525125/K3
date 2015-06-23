--根据流转卡号生成材料信息
--drop procedure sclzkclxx

create procedure sclzkclxx
@FID int         --流转卡内码
as
SET NOCOUNT ON 
IF EXISTS(SELECT 1 FROM ICShop_FlowCard WHERE FID=@FID and FText<>'' and FText is not null)
BEGIN
DECLARE @FBatchNo nvarchar(255)        --产品批号，也是材料批号
SELECT @FBatchNo=FText FROM ICShop_FlowCard WHERE FID=@FID

DECLARE @FText2 nvarchar(255)
SET @FText2=''
SELECT @FText2=i.FName+'/'+i.FModel 
FROM POInstockEntry a
INNER JOIN t_ICItem i on a.FItemID=i.FItemID
WHERE a.FBatchNo=@FBatchNo

UPDATE ICShop_FlowCard SET FText2=@FText2
WHERE FID=@FID
END





