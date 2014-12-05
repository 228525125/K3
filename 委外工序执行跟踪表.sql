 SET NOCOUNT ON 
create table #data(
FData datetime --制单日期
,FOutBill nvarchar(255) default('') --委外工序转出单号
,FClosed nvarchar(20) default('')           --行关闭标志
,FInvoiceNumber varchar(255) default('')--加工商代码
,FInvoiceName varchar(80) default('')--加工商名称
,FEmpName varchar(255) default('')--业务员
,FNumber nvarchar(80) default('')--产品代码
,FShortNumber nvarchar(80) default('')--产品短代码
,FName nvarchar(80) default('')--产品名称
,FModel nvarchar(255) default('')--规格型号
,FOper nvarchar(30) default('')--工序代码
,FOperName nvarchar(80) default('')--工序名称
,FDeliDate datetime--交货日期
,FUnit nvarchar(80) default('')--计量单位
,FOutQty decimal(28,10) default(0)--转出数量
,FOperOutQty decimal(28,10) default(0)--转出数量(工序)
,FInQty decimal(28,10) default(0)--接收数量
,FQualifiedQty decimal(28,10) default(0)--合格数量
,FScrapQty decimal(28,10) default(0)--因工报废数量
,FScrapItemQty decimal(28,10) default(0)--因料报废数量
,FOperInQty decimal(28,10) default(0)--接收数量（工序）
,FOperQualifiedQty decimal(28,10) default(0)--合格数量（工序）
,FOperScrapQty decimal(28,10) default(0)--因工报废数量（工序）
,FOperScrapItemQty decimal(28,10) default(0)--因料报废数量（工序）
,FBalanceQty decimal(28,10) default(0)--结存数量
,FOperBalanceQty decimal(28,10) default(0)--结存数量（工序）
,FEntryID int default(0)--转出单分录内码
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
select '合计' ,sum(FOutQty),sum(FOperOutQty),sum(FInQty),sum(FQualifiedQty),sum(FScrapQty),sum(FScrapItemQty),sum(FOperInQty)
,sum(FOperQualifiedQty),sum(FOperScrapQty),sum(FOperScrapItemQty),sum(FBalanceQty),sum(FOperBalanceQty),101
from #Data
 Where 1=1  

select FData as '制单日期',FOutBill as '转出单号',FClosed as '行关闭标志',FInvoiceNumber as '加工商代码',FInvoiceName as '加工商名称',FEmpName as '业务员',
FNumber as '产品代码',FName as '产品名称',FModel as '规格',FDeliDate as '交货日期',FUnit as '单位',FOutQty as '转出数量',FInQty as '接收数量',FOutQty-FInQty as '差异1',
FQualifiedQty as '合格数量',FOutQty-FQualifiedQty as '差异2',FScrapQty as '工废数量',FScrapItemQty as '料废数量',FBalanceQty as '结存数量',FSumSort from #Data  
 Where 1=1  
union select FData as '制单日期',FOutBill as '转出单号',FClosed as '行关闭标志',FInvoiceNumber as '加工商代码',FInvoiceName as '加工商名称',FEmpName as '业务员',
FNumber as '产品代码',FName as '产品名称',FModel as '规格',FDeliDate as '交货日期',FUnit as '单位',FOutQty as '转出数量',FInQty as '接收数量',FOutQty-FInQty as '差异1',
FQualifiedQty as '合格数量',FOutQty-FQualifiedQty as '差异2',FScrapQty as '工废数量',FScrapItemQty as '料废数量',FBalanceQty as '结存数量',FSumSort  from #Data where FSumSort=101
order by FSumSort,FData
drop table #Data



select * from ICShop_SubcInEntry   --接收单
