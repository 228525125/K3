--根据投料单生成任务单批次，规则：1、任务单批次为空；(取消第一条，因为可能存在修改投料单批次)2、投料单只有一行分录；3、投料单被指定批次,且不为空
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
