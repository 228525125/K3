 SET NOCOUNT ON 
create table #data(
FData datetime --�Ƶ�����
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
)

Insert Into #Data(FData,FOutBill,FClosed,FInvoiceNumber,FInvoiceName,FEmpName,FNumber,FShortNumber,FName,FModel,FOper,FOperName,FDeliDate,FUnit
,FOutQty,FOperOutQty,FInQty,FQualifiedQty,FEntryID
)
select convert(datetime,convert(varchar(30),t1.FBillDate,111)) as FData,t1.FBillNo as FOutBill, case when t2.FCloseFlag=1 then 'Y' else 'N' end ,t3.FNumber as 
FInvoiceNumber,t3.FName as FInvoiceName
,t4.FName as FEmpName, t5.FNumber as FNumber , t5.FShortNumber as FShortNumber,t5.FName,t5.FModel as FModel
,t6.FID as FOper,t6.FName as FOperName ,convert(datetime,convert(varchar(30),t2.FFetchDate,111)) as FDeliDate, t7.FName as FUnit
,t2.FTranOutQty as FOutQty ,t2.FOperTranOutQty as FOperOutQty,t2.FReceiptQty as FInQty,t2.FQualifiedQty as FQualifiedQty,t2.FEntryID
from ICShop_SubcOut t1
inner join ICShop_SubcOutEntry t2 on t1.FInterID=t2.FInterID
left join t_Supplier t3 on t1.FSupplierID=t3.FItemID
left join t_Emp t4 on t1.FEmpID=t4.FItemID
left join t_icitem t5 on  t2.FitemID=t5.FitemID
left join t_submessage t6 on t2.FOperID=t6.FInterID
left join t_Measureunit t7 on t2.FUnitID=t7.FMeasureUnitID

Where convert(datetime,convert(varchar(30),t1.FBillDate,111)) >= '2010-02-01' and convert(datetime,convert(varchar(30),t1.FBillDate,111)) <= '2010-10-21' 


update #Data set #Data.FScrapQty=t3.FSumScrapQty, #Data.FScrapItemQty=t3.FSumScrapItemQty
,FOperInQty=t3.FSumOperReceiveQty,FOperQualifiedQty=t3.FSumOperPassQty,FOperScrapQty=t3.FSumOperScrapQty
,FOperScrapItemQty=t3.FSumOperScrapItemQty
from #Data
inner join (select FSubcOutEntryID, sum(FScrapQty) as FSumScrapQty, sum(FScrapItemQty) as FSumScrapItemQty
,sum(FOperReceiveQty) as FSumOperReceiveQty,sum(FOperPassQty) as FSumOperPassQty ,sum(FOperScrapQty) as FSumOperScrapQty
,sum(FOperScrapItemQty) as FSumOperScrapItemQty
from ICShop_SubcInEntry t1 inner join ICShop_SubcOutEntry t2 on t1.FSubcOutEntryID=t2.FEntryID
group by t1.FSubcOutEntryID) t3 on #Data.FEntryID=t3.FSubcOutEntryID

update #Data set FBalanceQty=FOutQty-FInQty,FOperBalanceQty=FOperOutQty-FOperInQty
Insert Into #Data(FOutBill,FOutQty,FOperOutQty,FInQty,FQualifiedQty,FScrapQty,FScrapItemQty,FOperInQty
,FOperQualifiedQty,FOperScrapQty,FOperScrapItemQty,FBalanceQty,FOperBalanceQty,FSumSort)
select '�ϼ�' ,sum(FOutQty),sum(FOperOutQty),sum(FInQty),sum(FQualifiedQty),sum(FScrapQty),sum(FScrapItemQty),sum(FOperInQty)
,sum(FOperQualifiedQty),sum(FOperScrapQty),sum(FOperScrapItemQty),sum(FBalanceQty),sum(FOperBalanceQty),101
from #Data
 Where 1=1  

select FData as '�Ƶ�����',FOutBill as 'ת������',FClosed as '�йرձ�־',FInvoiceNumber as '�ӹ��̴���',FInvoiceName as '�ӹ�������',FEmpName as 'ҵ��Ա',
FNumber as '��Ʒ����',FName as '��Ʒ����',FModel as '���',FDeliDate as '��������',FUnit as '��λ',FOutQty as 'ת������',FInQty as '��������',FOutQty-FInQty as '����1',
FQualifiedQty as '�ϸ�����',FOutQty-FQualifiedQty as '����2',FScrapQty as '��������',FScrapItemQty as '�Ϸ�����',FBalanceQty as '�������',FSumSort from #Data  
 Where 1=1  
union select FData as '�Ƶ�����',FOutBill as 'ת������',FClosed as '�йرձ�־',FInvoiceNumber as '�ӹ��̴���',FInvoiceName as '�ӹ�������',FEmpName as 'ҵ��Ա',
FNumber as '��Ʒ����',FName as '��Ʒ����',FModel as '���',FDeliDate as '��������',FUnit as '��λ',FOutQty as 'ת������',FInQty as '��������',FOutQty-FInQty as '����1',
FQualifiedQty as '�ϸ�����',FOutQty-FQualifiedQty as '����2',FScrapQty as '��������',FScrapItemQty as '�Ϸ�����',FBalanceQty as '�������',FSumSort  from #Data where FSumSort=101
order by FSumSort,FData
drop table #Data



select * from ICShop_SubcInEntry   --���յ�
