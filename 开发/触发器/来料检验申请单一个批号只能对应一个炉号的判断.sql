--�ж����ϼ������뵥¯���Ƿ��ظ�
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
	EXEC('ͬһ����ֻ�ܶ�Ӧһ��¯��')

END 
