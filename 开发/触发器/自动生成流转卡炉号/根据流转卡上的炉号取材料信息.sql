--������ת�������ɲ�����Ϣ
--drop procedure sclzkclxx

create procedure sclzkclxx
@FID int         --��ת������
as
SET NOCOUNT ON 
IF EXISTS(SELECT 1 FROM ICShop_FlowCard WHERE FID=@FID and FText<>'' and FText is not null)
BEGIN
DECLARE @FBatchNo nvarchar(255)        --��Ʒ���ţ�Ҳ�ǲ�������
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





