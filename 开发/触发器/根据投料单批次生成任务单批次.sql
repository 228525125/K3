--����Ͷ�ϵ������������Σ�����1����������Ϊ�գ�(ȡ����һ������Ϊ���ܴ����޸�Ͷ�ϵ�����)2��Ͷ�ϵ�ֻ��һ�з�¼��3��Ͷ�ϵ���ָ������,�Ҳ�Ϊ��
--DROP TRIGGER IC_TLDSCRWDPC

CREATE TRIGGER IC_TLDSCRWDPC ON PPBOM    
AFTER UPDATE
AS
SET NOCOUNT ON
IF EXISTS(
	select 1 from inserted a 
	INNER JOIN PPBOMEntry b ON a.FInterID = b.FInterID  AND b.FInterID<>0
	INNER JOIN ICMO c ON a.FICMOInterID=c.FInterID
 	where a.FStatus=1 
	--and (c.FGMPBatchNo='' or c.FGMPBatchNo is null)
	and (b.FBatchNo<>'' or b.FBatchNo is not null)
	and not exists(select 1 from inserted a INNER JOIN PPBOMEntry b ON a.FInterID = b.FInterID AND b.FInterID<>0 where b.FEntryID=2)
)
BEGIN
	UPDATE c set c.FGMPBatchNo=b.FBatchNo 
	from inserted a 
	INNER JOIN PPBOMEntry b ON a.FInterID = b.FInterID  AND b.FInterID<>0
	INNER JOIN ICMO c ON a.FICMOInterID=c.FInterID	
END


select FGMPBatchNo,* from ICMO where FBillNo='WORK028138' and (FGMPBatchNo='' or FGMPBatchNo is not null)

update ICMO set FGMPBatchNo='9C03' where FBillNo='WORK028138' and (FGMPBatchNo='' or FGMPBatchNo is not null)

select b.* from PPBOM a left join PPBOMEntry b ON a.FInterID = b.FInterID  AND b.FInterID<>0 where b.FEntryID=2
