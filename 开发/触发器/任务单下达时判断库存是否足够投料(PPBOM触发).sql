--任务单下达时判断库存是否满足投料
--DROP TRIGGER IC_PPBOM_TL

CREATE TRIGGER IC_PPBOM_TL ON PPBOM
After INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM Inserted WHERE FStatus = 1) 
AND EXISTS(SELECT 1 FROM Inserted a INNER JOIN PPBOMEntry b on a.FInterID=b.FInterID LEFT JOIN t_ICItem i on b.FItemID=i.FItemID WHERE b.FEntryID=1 and i.FNumber in ('01.01.06.048','01.01.06.050','01.01.06.049'))     --只包含指定物料
BEGIN
DECLARE @JSKC decimal(28,4)         --即时库存
DECLARE @WLSL decimal(28,4)         --未领料
DECLARE @WLDM nvarchar(255)         --物料代码
DECLARE @LLSL decimal(28,4)         --本次领料量
DECLARE @PH nvarchar(255)           --材料批次

SELECT @PH=b.FGMPBatchNo FROM Inserted a INNER JOIN ICMO b on a.FICMOInterID=b.FInterID

DECLARE @I int
SET @I=1
WHILE EXISTS(select 1 from Inserted a inner join PPBOMEntry b on a.FInterID=b.FInterID where b.FEntryID=@I)
BEGIN

SELECT @WLDM=i.FNumber,@LLSL=b.FAuxQtyMust
FROM Inserted a 
INNER JOIN PPBOMEntry b on a.FInterID=b.FInterID
LEFT JOIN t_ICItem i on b.FItemID=i.FItemID
WHERE b.FEntryID=@I

EXEC @JSKC=query_jskc @WLDM,@PH
EXEC @WLSL=query_ppbom_wlsl @WLDM,@PH

DECLARE @temp decimal(28,4)
SET @temp=@JSKC-@WLSL

IF (@JSKC-(@WLSL-@LLSL))<@LLSL                       --如果 结存-未领<本次领料   未领料包含了本次领料数量
IF @temp>=0
	exec ('库存余额不足_剩_'+@temp)
ELSE
BEGIN
	SET @temp = abs(@temp)
	exec ('库存余额不足_差_'+@temp)
END

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

select b.FAuxQtyMust,* from PPBOM a left join PPBOMEntry b on a.FInterID=b.FInterID where a.FBillNo='PBOM026028'

