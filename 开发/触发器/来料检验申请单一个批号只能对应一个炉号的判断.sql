--判断来料检验申请单炉号是否重复
--DROP TRIGGER IC_LLJYSQD_LUHAOCHONGFU

CREATE TRIGGER IC_LLJYSQD_LUHAOCHONGFU ON POInstockEntry
After INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)       
BEGIN
DECLARE @FInterID int
DECLARE @PH nvarchar(255)
DECLARE @LH nvarchar(255)
DECLARE @RESULT nvarchar(255)  
SELECT @FInterID=FInterID,@PH=FBatchNo,@LH=FEntrySelfT0241 FROM inserted

EXEC query_lh @PH,@RESULT output

IF (@RESULT<>'')
	EXEC('同一批次只能对应一个炉号')

END 
