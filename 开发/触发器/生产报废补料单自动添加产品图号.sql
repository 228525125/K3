--报废补料单自动添加产品图号
--DROP TRIGGER IC_SCBFBL

CREATE TRIGGER IC_SCBFBL ON ICItemScrapEntry    
AFTER INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)
BEGIN
	DECLARE @FInterID int
	DECLARE @FEntryID int
	SELECT @FInterID=FInterID,@FEntryID=FEntryID FROM inserted
	
	
	UPDATE a set a.FEntrySelfZ0631=i.FHelpCode,FEntrySelfZ0638=i.FNumber 
	from ICItemScrapEntry a 
	LEFT JOIN ICMO o ON a.FSourceBillNo=o.FBillNo
	LEFT JOIN t_ICItem i on o.FItemID=i.FItemID
	where 1=1 AND a.FInterID=@FInterID AND a.FEntryID=@FEntryID
END




select FEntrySelfZ0638,* from ICItemScrapEntry
