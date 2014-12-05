--drop procedure report_wwgxzxgzbhz

create procedure report_wwgxzxgzbhz
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
FDate nvarchar(255) default('') --�Ƶ�����
,FOutBill nvarchar(255) default('') --ί�⹤��ת������
,FClosed nvarchar(20) default('')           --�йرձ�־
,FInvoiceNumber varchar(255) default('')--�ӹ��̴���
,FInvoiceName varchar(80) default('')--�ӹ�������
,FEmpName varchar(255) default('')--ҵ��Ա
,FNumber nvarchar(80) default('')--��Ʒ����
,FShortNumber nvarchar(80) default('')--��Ʒ�̴���
,FName nvarchar(80) default('')--��Ʒ����
,FModel nvarchar(255) default('')--����ͺ�
,FOper nvarchar(30) default('')--�������
,FOperName nvarchar(80) default('')--��������
,FDeliDate datetime--��������
,FUnit nvarchar(80) default('')--������λ
,FOutQty decimal(28,10) default(0)--ת������
,FOperOutQty decimal(28,10) default(0)--ת������(����)
,FInQty decimal(28,10) default(0)--��������
,FQualifiedQty decimal(28,10) default(0)--�ϸ�����
,FScrapQty decimal(28,10) default(0)--�򹤱�������
,FScrapItemQty decimal(28,10) default(0)--���ϱ�������
,FOperInQty decimal(28,10) default(0)--��������������
,FOperQualifiedQty decimal(28,10) default(0)--�ϸ�����������
,FOperScrapQty decimal(28,10) default(0)--�򹤱�������������
,FOperScrapItemQty decimal(28,10) default(0)--���ϱ�������������
,FBalanceQty decimal(28,10) default(0)--�������
,FOperBalanceQty decimal(28,10) default(0)--�������������
,FEntryID int default(0)--ת������¼����
,FSumSort int default(0)
,FNotPassQty decimal(28,10) default(0)--���ϸ�����
,FQINQty decimal(28,10) default(0)
,FQOUTQty decimal(28,10) default(0)
)

Insert Into #Data(FDate,FOutBill,FClosed,FInvoiceNumber,FInvoiceName,FEmpName,FNumber,FShortNumber,FName,FModel,FOper,FOperName,FDeliDate,FUnit
,FOutQty,FOperOutQty,FInQty,FQualifiedQty,FEntryID,FNotPassQty,FQINQty,FQOUTQty
)
select convert(varchar(10),t1.FBillDate,120) as FData,t1.FBillNo as FOutBill, case when t2.FCloseFlag=1 then 'Y' else 'N' end ,t3.FNumber as 
FInvoiceNumber,t3.FName as FInvoiceName
,t4.FName as FEmpName, t5.FNumber as FNumber , t5.FShortNumber as FShortNumber,t5.FName,t5.FModel as FModel
,t6.FID as FOper,t6.FName as FOperName ,convert(datetime,convert(varchar(30),t2.FFetchDate,111)) as FDeliDate, t7.FName as FUnit
,t2.FTranOutQty as FOutQty ,t2.FOperTranOutQty as FOperOutQty,t2.FReceiptQty as FInQty,t2.FQualifiedQty as FQualifiedQty,t2.FEntryID,t20.FNotPassQty,t21.FQty as FQINQty,t22.FQty as FQOUTQty 
from ICShop_SubcOut t1
inner join ICShop_SubcOutEntry t2 on t1.FInterID=t2.FInterID
left join t_Supplier t3 on t1.FSupplierID=t3.FItemID
left join t_Emp t4 on t1.FEmpID=t4.FItemID
left join t_icitem t5 on  t2.FitemID=t5.FitemID
left join t_submessage t6 on t2.FOperID=t6.FInterID
left join t_Measureunit t7 on t2.FUnitID=t7.FMeasureUnitID
left join (
select sum(FNotPassQty) as FNotPassQty,FSHSubcOutInterID,FSHSubcOutEntryID from ICQCBill
where 1=1
AND FTranType=715 AND FCancellation = 0 AND FStatus=1 AND FResult<>13556
group by FSHSubcOutInterID,FSHSubcOutEntryID
) t20 on t20.FSHSubcOutInterID=t2.FInterID and t20.FSHSubcOutEntryID=t2.FEntryID
left join (
select b.FNote,sum(b.FQty) as 'FQty' from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=10 and a.FCheckerID>0 and a.FCancellation=0 and b.FNote like 'WWZC%' group by b.FNote
) t21 on t21.FNote=t1.FBillNo
left join (
select b.FNote,sum(b.FQty) as 'FQty' from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=29 and a.FCheckerID>0 and a.FCancellation=0 and b.FNote like 'WWZC%' group by b.FNote
) t22 on t22.FNote=t1.FBillNo

Where convert(datetime,convert(varchar(30),t1.FBillDate,111)) >= @begindate and convert(datetime,convert(varchar(30),t1.FBillDate,111)) <= @enddate 
and (t5.FNumber like '%'+@query+'%' or t1.FBillNo like '%'+@query+'%' or t5.FShortNumber like '%'+@query+'%' or t5.FName like '%'+@query+'%'
or t5.FModel like '%'+@query+'%' or t3.FName like '%'+@query+'%')


update #Data set #Data.FScrapQty=t3.FSumScrapQty, #Data.FScrapItemQty=t3.FSumScrapItemQty
,FOperInQty=t3.FSumOperReceiveQty,FOperQualifiedQty=t3.FSumOperPassQty,FOperScrapQty=t3.FSumOperScrapQty
,FOperScrapItemQty=t3.FSumOperScrapItemQty
from #Data
inner join (select FSubcOutEntryID, sum(FScrapQty) as FSumScrapQty, sum(FScrapItemQty) as FSumScrapItemQty
,sum(FOperReceiveQty) as FSumOperReceiveQty,sum(FOperPassQty) as FSumOperPassQty ,sum(FOperScrapQty) as FSumOperScrapQty
,sum(FOperScrapItemQty) as FSumOperScrapItemQty
from ICShop_SubcInEntry t1 inner join ICShop_SubcOutEntry t2 on t1.FSubcOutEntryID=t2.FEntryID
group by t1.FSubcOutEntryID) t3 on #Data.FEntryID=t3.FSubcOutEntryID

update #Data set FBalanceQty=FOutQty-FInQty-isnull(FNotPassQty,0),FOperBalanceQty=FOperOutQty-FOperInQty-FNotPassQty
Insert Into #Data(FOutBill,FOutQty,FOperOutQty,FInQty,FQualifiedQty,FScrapQty,FScrapItemQty,FOperInQty
,FOperQualifiedQty,FOperScrapQty,FOperScrapItemQty,FBalanceQty,FOperBalanceQty,FSumSort)
select '�ϼ�' ,sum(FOutQty),sum(FOperOutQty),sum(FInQty),sum(FQualifiedQty),sum(FScrapQty),sum(FScrapItemQty),sum(FOperInQty)
,sum(FOperQualifiedQty),sum(FOperScrapQty),sum(FOperScrapItemQty),sum(FBalanceQty),sum(FOperBalanceQty),101
from #Data
Where 1=1  

select FNumber,FName,FModel,FInvoiceName,FUnit,sum(FOutQty)as FOutQty,sum(FInQty)as FInQty,sum(FBalanceQty)as FBalanceQty from #Data  
Where 1=1
group by FInvoiceName,FNumber,FName,FModel,FUnit
order by FNumber,FName,FModel,FInvoiceName,FUnit
end




execute report_wwgxzxgzbhz '','2013-01-01','2013-06-30'




select * from wx_zzp

