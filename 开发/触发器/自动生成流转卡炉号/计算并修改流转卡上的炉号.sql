--�������񵥺�������ת��¯�š�����
--drop procedure sclzklh

create procedure sclzklh
@FInterID int         --��������
as 
begin
SET NOCOUNT ON 
IF EXISTS(
SELECT 1 FROM ICMO a 
WHERE FInterID=@FInterID 
AND not exists(select 1 from ICBomChild b left join t_ICItem i on b.FItemID=i.FItemID where a.FBomInterID=b.FInterID and b.FEntryID=2 and left(i.FNumber,2)<>'08')   --�����ڲ�Ʒbom���ж���1��ԭ���ϣ�����Ʒ��ԭ����һһ��Ӧ��bomû�ж��ڵ�ԭ����
--AND not exists(select 1 from PPBOM p1 left join PPBOMEntry p2 on p1.FInterID=p2.FInterID where p1.FICMOInterID=a.FInterID and p2.FEntryID=2)   --�����ж�Ͷ�ϵ���BOM�ã���ΪͶ�ϵ��޸ıȽϷ���
AND a.FGMPBatchNo is not null
AND a.FGMPBatchNo <>''
AND a.FGMPBatchNo <>'0'
)
BEGIN
DECLARE @PH nvarchar(255)
DECLARE @LH nvarchar(255)
SET @LH=''

SELECT @PH=FGMPBatchNo FROM ICMO WHERE FInterID=@FInterID

SELECT @LH=ISNULL(b.FEntrySelfT0241,'') FROM POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0 and b.FBatchNo=@PH

IF (@LH='' OR @LH is null)
SELECT @LH=ISNULL(lh,'') FROM pclh where ph=@PH

IF (@LH='' OR @LH is null)
SET @LH='NA'

UPDATE ICShop_FlowCard SET FText=@PH,FText1=@LH WHERE FSRCInterID=@FInterID
END 
ELSE   --�������ϼ����Ͱ�¯����Ϊ''
BEGIN
DECLARE @PH1 nvarchar(255)
SELECT @PH1=FGMPBatchNo FROM ICMO WHERE FInterID=@FInterID

UPDATE ICShop_FlowCard SET FText=@PH1,FText1='���㲿������' WHERE FSRCInterID=@FInterID
END

end


execute sclzklh 39742

select FInterID,* from ICMO where FBillNo='WORK038073'



SELECT 1 FROM ICMO a 
WHERE FInterID=29993 
AND not exists(select 1 from ICBomChild b left join t_ICItem i on b.FItemID=i.FItemID where a.FBomInterID=b.FInterID and b.FEntryID=2 and left(i.FNumber,2)<>'08')   --�����ڲ�Ʒbom���ж���1��ԭ���ϣ�����Ʒ��ԭ����һһ��Ӧ��bomû�ж��ڵ�ԭ����
--AND not exists(select 1 from PPBOM p1 left join PPBOMEntry p2 on p1.FInterID=p2.FInterID where p1.FICMOInterID=a.FInterID and p2.FEntryID=2)   --�����ж�Ͷ�ϵ���BOM�ã���ΪͶ�ϵ��޸ıȽϷ���
AND a.FGMPBatchNo is not null
AND a.FGMPBatchNo <>''
AND a.FGMPBatchNo <>'0'


SELECT FGMPBatchNo FROM ICMO WHERE FInterID=29993


SELECT ISNULL(b.FEntrySelfT0241,'') FROM POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0 and b.FBatchNo='13E04'


update pclh set lh='P11606301' where ph='13E04'

SELECT * FROM pclh where ph='Q1403'




SELECT ISNULL(b.FEntrySelfT0241,''),a.FBillNo FROM POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0 and b.FBatchNo='Q1403'


