--�����´�ʱ�жϿ���Ƿ�����Ͷ�ϣ���������û���⣬����ʽ���׽��յ�����ʱ����
--DROP TRIGGER IC_ICMO_TL

CREATE TRIGGER IC_ICMO_TL ON ICMO
After UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM Inserted WHERE FStatus in (1,2)) 
AND EXISTS(SELECT 1 FROM Deleted WHERE FStatus = 0 or FStatus = 5)    --������ȷ�ϵ��´�
AND EXISTS(SELECT 1 FROM Inserted a INNER JOIN ICBOM b on a.FBomInterID=b.FInterID INNER JOIN ICBOMCHILD c on b.FInterID=c.FInterID LEFT JOIN t_ICItem i on c.FItemID=i.FItemID WHERE c.FEntryID=1 and i.FNumber in ('01.01.06.048','01.01.06.050','01.01.06.049'))     --ֻ����ָ������
BEGIN
DECLARE @JSKC decimal(28,4)         --��ʱ���
DECLARE @WLSL decimal(28,4)         --δ����
DECLARE @WLDM nvarchar(255)         --���ϴ���
DECLARE @LLSL decimal(28,4)         --����������

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

IF @JSKC-@WLSL<@LLSL                       --��� ���-δ��<��������
exec ('�������_���Ϊ_'+@temp)

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

