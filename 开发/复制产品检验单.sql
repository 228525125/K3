--drop procedure copy_cpjyd

create procedure copy_cpjyd 
@jydh varchar(50),              --被复制的检验单号
@interid int,                   --申请单内码
@entryid int,                   --申请单分录号
@sqsl decimal(28,2),            --报检数量
@FBatchNo varchar(255),         --批号  （没用）
@FICMOInterID varchar(255)      --任务单内码
as 
begin
SET NOCOUNT ON 

DECLARE @FCurNo int
DECLARE @FBillNo nvarchar(255)
DECLARE @FInterID int
DECLARE @FNote nvarchar(255)
DECLARE @FSendUpQty decimal(28,2)
DECLARE @FCheckQty decimal(28,2)
DECLARE @FPassQty decimal(28,2)
DECLARE @FBasePassQty decimal(28,2)
DECLARE @FSerialID int
DECLARE @FInStockInterID int
DECLARE @FCheckerID int
DECLARE @FCheckDate datetime
DECLARE @FAuxCommitQty decimal(28,2)
DECLARE @FCommitQty decimal(28,2)

select @FCurNo=FCurNo+1 from ICBillNo where FBillID = '713'
set @FBillNo='FQC0'+convert(nvarchar(255),@FCurNo)

select @FInterID=max(FInterID) from ICQCBill
exec GetICMaxNum 'ICQCBill',@FInterID output,1,16469

set @FNote='关联检验单号：'+@jydh
set @FSendUpQty=@sqsl
set @FCheckQty=@sqsl
set @FPassQty=@sqsl
set @FBasePassQty=@sqsl
set @FInStockInterID=@interid
set @FSerialID=@entryid
select @FCheckerID=FCheckerID,@FCheckDate=FCheckDate from ICQCBill where FBillNo=@jydh
set @FAuxCommitQty=0             --入库辅助数量
set @FCommitQty=0                --入库数量

Insert Into ICQCBill(FBrNo,FInterID,FTranType,FType,FDate,FBillNo,FFManagerID,FSManagerID,FCheckerID,FCheckDate,FSCBillInterID,FInStockInterID,FICMOInterID,FSupplyID,FRoutingID,FSerialID,FItemID,FUnitID,Fresult,FBatchNo,FCheckMethod,FSendUpQty,FCheckQty,FPassQty,FNote,FStatus,FForOpScrapQty,FForMatScrapQty,FSpecialUse,Fcancellation,FBillerID,FWBInterID,Fserial,FMultiCheckLevel1,FMultiCheckLevel2,FMultiCheckLevel3,FMultiCheckLevel4,FMultiCheckLevel5,FMultiCheckLevel6,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,FMultiCheckDate6,FCurCheckLevel,FWWICMOInterID,FCheckTimes,FOrgBillID,FSampleQty,FSampleBadQty,FBadQty,FOperID,FBillDate,FCommitInQty,FSampStdID,FAcQty,FReQty,FAQLID,FNotPassQty,FSampleBreakQty,FBackWorkQty,FNotPassQtyBack,FCloseFlag,FAuxPropID,FAuxCommitQty,FCommitQty,FConnectFlag,Fchildren,FBasePassQty,FPlanMode,FMTONo,FBizType,FSHSubcOutInterID,FSHSubcOutEntryID,FSHSubcOutIndexID,FFlowCardInterID,FFlowCardEntryID,FReceiptQty,FCardReportID,FCardReportEntryID,FOrderInterID,FOrderEntryID,FOrderBillNo,FHeadSelfT1458,FHeadSelfT1459
)
select FBrNo,@FInterID,FTranType,FType,FDate,@FBillNo,FFManagerID,FSManagerID,null,null,FSCBillInterID,@FInStockInterID,@FICMOInterID,FSupplyID,FRoutingID,@FSerialID,FItemID,FUnitID,Fresult,FBatchNo,FCheckMethod,@FSendUpQty,@FCheckQty,@FPassQty,@FNote,0,FForOpScrapQty,FForMatScrapQty,FSpecialUse,Fcancellation,FBillerID,FWBInterID,Fserial,FMultiCheckLevel1,FMultiCheckLevel2,FMultiCheckLevel3,FMultiCheckLevel4,FMultiCheckLevel5,FMultiCheckLevel6,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,FMultiCheckDate6,FCurCheckLevel,FWWICMOInterID,FCheckTimes,FOrgBillID,FSampleQty,FSampleBadQty,FBadQty,FOperID,FBillDate,FCommitInQty,FSampStdID,FAcQty,FReQty,FAQLID,FNotPassQty,FSampleBreakQty,FBackWorkQty,FNotPassQtyBack,FCloseFlag,FAuxPropID,@FAuxCommitQty,@FCommitQty,FConnectFlag,Fchildren,@FBasePassQty,FPlanMode,FMTONo,FBizType,FSHSubcOutInterID,FSHSubcOutEntryID,FSHSubcOutIndexID,FFlowCardInterID,FFlowCardEntryID,FReceiptQty,FCardReportID,FCardReportEntryID,FOrderInterID,FOrderEntryID,FOrderBillNo,FHeadSelfT1458,FHeadSelfT1459 from ICQCBill where FBillNo=@jydh

Insert Into ICQCBillEntry(FBrNo,FInterID,FEntryID,FSourceEntryID,FQCItemNumber,FQCItemName,FQCUnit,FTargetValue,FLowerLimit,FUpperLimit,FEmphasesCheck,Fresult,FPassQty,FForOpScrapQty,FForMatScrapQty,FDisPassReason,Fnote,FSampleQty,FSamplePassQty,FBadQty,FAnalysisMethodID,FTargetID,FTargetQty,FLowerLimitID,FLowerLimitQty,FUpperLimitID,FUpperLimitQty,FTestValueID,FTestValue,FQCBasisID,FQCInstrument,FQCMethodID,FSampStdID,FQCItemID,FSchemeMemos,FDefectID,FQCOtherID1,FQCOtherID2,FTestValue2,FTestValueText,FTargetText,FLowerLimitText,FUpperLimitText,FQCInstrumentID,FLowTolerance,FUpTolerance
)
select b.FBrNo,@FInterID,b.FEntryID,b.FSourceEntryID,b.FQCItemNumber,b.FQCItemName,b.FQCUnit,b.FTargetValue,b.FLowerLimit,b.FUpperLimit,b.FEmphasesCheck,b.Fresult,b.FPassQty,b.FForOpScrapQty,b.FForMatScrapQty,b.FDisPassReason,b.Fnote,b.FSampleQty,b.FSamplePassQty,b.FBadQty,b.FAnalysisMethodID,b.FTargetID,b.FTargetQty,b.FLowerLimitID,b.FLowerLimitQty,b.FUpperLimitID,b.FUpperLimitQty,b.FTestValueID,b.FTestValue,b.FQCBasisID,b.FQCInstrument,b.FQCMethodID,b.FSampStdID,b.FQCItemID,b.FSchemeMemos,b.FDefectID,b.FQCOtherID1,b.FQCOtherID2,b.FTestValue2,b.FTestValueText,b.FTargetText,b.FLowerLimitText,b.FUpperLimitText,b.FQCInstrumentID,b.FLowTolerance,b.FUpTolerance from ICQCBill a left join ICQCBillEntry b on a.FInterID=b.FInterID where a.FBillNo=@jydh

UPDATE ICQCBill SET FCheckerID=@FCheckerID,FStatus=1,FCheckDate=@FCheckDate WHERE FInterID=@FInterID

update ICMO set FQtyPass=FQtyPass+@FPassQty,FAuxQtyPass=FAuxQtyPass+@FPassQty where FInterID=@FICMOInterID  --更新任务单里的合格数字段

update ICBillNo set FCurNo=@FCurNo, FDesc='FQC+0'+convert(nvarchar(255),@FCurNo+1) where FBillID = '713'           --更新单据编号
update t_billcoderule set FProjectVal=@FCurNo+1 where fbilltypeid=713 and FClassIndex=2                            --更新单据编号

end


select * from ICBillNo where FBillID = '713'
select * from t_billcoderule where fbilltypeid=713 and FClassIndex=2

select * from ICQCBill where FBillNo like 'FQC000027'

select * from ICQCBill where FBillNo='FQC000042'

select FBillNo,FQtyPass,FAuxQtyPass,FStockQty,FQtyScrap,FQtyForItem from ICMO where FInterID=1231

select FPassQty from View_ProductInspectionSlip713 where FICMOBillNo='WORK000205'

select FAuxCommitQty from ICMO where FBillNo='WORK014220'

update ICMO set FCommitQty=0,FAuxCommitQty=0 where FBillNo='WORK014220'


select * from ICMO where FBillNo='WORK014218'

--update ICMO set FQtyPass=1400 where FInterID=1231

select FCurNo from ICBillNo where FBillID = '713'




select * from ICQCBill where FTranType=713 and FBillNo in ('FQC017726','FQC017728','FQC017727')

update ICQCBill set FAuxCommitQty=0,FCommitQty=0 where FTranType=713 and FBillNo in ('FQC017728')

--update ICQCBill set fstatus=1,FCheckerID = null,FCheckDate=null where FBillNo='FQC000042'

--DELETE ICQCBill where FBillNo='IQC042'

select FQtyPass,FStockQty,FQtyScrap,FQtyForItem,FAuxQtyScrap,FAuxQtyForItem from ICMO where FInterID=1062

--execute copy_cpjyd 'FQC000028',1035,1,'150','1115'


select * from ICQCBill where FBillNo IN ('FQC012323','FQC012324')

select * from ICQCBill v1 where 1=1 AND (v1.FTranType=713 AND (v1.FCancellation = 0)) and FNote like '关联检验单号%' AND FBillNo='FQC031954'

update ICQCBill set FAuxCommitQty=0,FCommitQty=0 where 1=1 AND (FTranType=713 AND (FCancellation = 0)) and FDate='2013-08-01' and FNote like '关联检验单号%'-- AND FBillNo>='FQC016565'

update ICQCBill set FStatus=0,FCheckerID = null, FCheckDate=null  where 1=1 AND (FTranType=713 AND (FCancellation = 0)) and FNote like '关联检验单号%' and FBillNo='FQC031954'



select * from ICQCBill where FBillNo='FQC031954'

update ICQCBill set FStatus=0 where FBillNo='FQC031954'


