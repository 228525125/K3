--�ж����ϼ������뵥¯���Ƿ��ظ������β����ظ�
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

/*EXEC query_lh @PH,@RESULT output

IF (@RESULT<>'')
	EXEC('ͬһ����ֻ�ܶ�Ӧһ��¯��')*/

IF EXISTS(
SELECT 1 FROM POInstockEntry a left join t_ICItem b on a.FItemID=b.FItemID 
WHERE a.FBatchNo=@PH 
and a.FBatchNo<>'' 
and a.FInterID<>@FInterID 
and b.FNumber<>'07.05.0003'  --�ض���������¯����ͬ�����Կ����ظ�
and b.FNumber<>'07.05.0006'
and b.FNumber<>'07.05.0007'
and b.FNumber<>'07.05.1001'
and b.FNumber<>'07.05.1002'
and b.FNumber<>'07.05.1003'
and b.FNumber<>'07.05.1004'
and b.FNumber<>'07.05.1005'
and b.FNumber<>'07.05.1006'
and b.FNumber<>'07.05.1007'
and b.FNumber<>'07.05.1008'
and b.FNumber<>'07.05.1009'
and b.FNumber<>'07.08.0018'
and b.FNumber<>'07.09.0009'
and b.FNumber<>'07.09.0010'
and b.FNumber<>'07.09.0011'
and b.FNumber<>'07.09.0014'
and b.FNumber<>'07.09.0016'
and b.FNumber<>'07.09.0017'
and b.FNumber<>'07.09.0020'
and b.FNumber<>'07.09.1001'
and b.FNumber<>'07.09.1002'
and b.FNumber<>'07.09.1003'
and b.FNumber<>'07.09.1010'
and b.FNumber<>'07.09.1017'
and b.FNumber<>'07.09.1018'
and b.FNumber<>'07.09.1019'
)
	EXEC('�����ظ�')

END 


select * from POInstockEntry


SELECT b.FNumber FROM POInstockEntry a left join t_ICItem b on a.FItemID=b.FItemID 