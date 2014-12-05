--任务单下达时判断库存是否满足投料，测试帐套没问题，但正式帐套接收单保存时报错
--DROP TRIGGER IC_ICMO_TL

CREATE TRIGGER IC_ICMO_TL ON ICMO
After UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM Inserted WHERE FStatus in (1,2)) 
AND EXISTS(SELECT 1 FROM Deleted WHERE FStatus = 0 or FStatus = 5)    --必须是确认到下达
AND EXISTS(SELECT 1 FROM Inserted a INNER JOIN ICBOM b on a.FBomInterID=b.FInterID INNER JOIN ICBOMCHILD c on b.FInterID=c.FInterID LEFT JOIN t_ICItem i on c.FItemID=i.FItemID WHERE c.FEntryID=1 and i.FNumber in ('01.01.06.048','01.01.06.050','01.01.06.049'))     --只包含指定物料
BEGIN
DECLARE @JSKC decimal(28,4)         --即时库存
DECLARE @WLSL decimal(28,4)         --未领料
DECLARE @WLDM nvarchar(255)         --物料代码
DECLARE @LLSL decimal(28,4)         --本次领料量

DECLARE @I int
SET @I=1
WHILE EXISTS(select 1 from Inserted a INNER JOIN ICBOM b on a.FBomInterID=b.FInterID INNER JOIN ICBOMCHILD c on b.FInterID=c.FInterID where c.FEntryID=@I)
BEGIN

SELECT @WLDM=i.FNumber,@LLSL=a.FQty*ISNULL(c.FQty,0) FROM Inserted a 
INNER JOIN ICBOM b on a.FBomInterID=b.FInterID
INNER JOIN ICBOMCHILD c on b.FInterID=c.FInterID 
LEFT JOIN t_ICItem i on c.FItemID=i.FItemID
WHERE c.FEntryID=@I

EXEC @JSKC=query_jskc @WLDM
EXEC @WLSL=query_ppbom_wlsl @WLDM

DECLARE @temp decimal(28,4)
SET @temp=@JSKC-@WLSL

IF @JSKC-@WLSL<@LLSL                       --如果 结存-未领<本次领料
exec ('库存余额不足_余额为_'+@temp)

IF @I>30                  --防止死循环
BREAK

set @I=@I+1
END

END



SELECT i.FNumber,EXEC  FROM ICMO a 
INNER JOIN ICBOM b on a.FBomInterID=b.FInterID
INNER JOIN ICBOMCHILD c on b.FInterID=c.FInterID 
LEFT JOIN t_ICItem i on c.FItemID=i.FItemID
WHERE a.FBillNo='WORK000306'

select * from ICMO
FBomInterID

select * from ICBOMCHILD

select * from ICMO where FBillNo='WORK000307'

