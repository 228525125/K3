--�����´�ʱ�жϿ���Ƿ�����Ͷ��
--DROP TRIGGER IC_PPBOM_TL

CREATE TRIGGER IC_PPBOM_TL ON PPBOM
After INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM Inserted WHERE FStatus = 1) 
AND EXISTS(SELECT 1 FROM Inserted a INNER JOIN PPBOMEntry b on a.FInterID=b.FInterID LEFT JOIN t_ICItem i on b.FItemID=i.FItemID WHERE b.FEntryID=1 and i.FNumber in ('01.01.06.048','01.01.06.050','01.01.06.049'))     --ֻ����ָ������
BEGIN
DECLARE @JSKC decimal(28,4)         --��ʱ���
DECLARE @WLSL decimal(28,4)         --δ����
DECLARE @WLDM nvarchar(255)         --���ϴ���
DECLARE @LLSL decimal(28,4)         --����������
DECLARE @PH nvarchar(255)           --��������

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

IF (@JSKC-(@WLSL-@LLSL))<@LLSL                       --��� ���-δ��<��������   δ���ϰ����˱�����������
IF @temp>=0
	exec ('�������_ʣ_'+@temp)
ELSE
BEGIN
	SET @temp = abs(@temp)
	exec ('�������_��_'+@temp)
END

IF @I>30                  --��ֹ��ѭ��
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

