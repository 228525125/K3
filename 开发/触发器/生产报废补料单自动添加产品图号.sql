--���ϲ��ϵ��Զ���Ӳ�Ʒͼ�� 
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




select FEntrySelfZ0632,* 

update b set b.FEntrySelfZ0632=6
from ICItemScrap a left join ICItemScrapEntry b on a.FInterID=b.FInterID where a.FBillNo='FSC007235'


