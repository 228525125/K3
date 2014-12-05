/* 合计版本 */
select Convert(char(10),Max(a.FDate),111) as '制单日期',Max(d.FName) as '往来单位',Max(a.FBillNo) as '订单号',Max(c.FName) as '产品名称',Max(c.FModel) as '规格',Max(e.FName) as '单位',
sum(b.FQty) as '数量',
MIN(b.FPrice) as '单价',
MIN(b.FPriceDiscount) as '含税单价',
SUM(b.FTaxAmt) as '销项税',
SUM(b.FAllAmount) as '含税金额',
Convert(char(10),MAX(b.FDate),111) as '交货日期',
Convert(char(10),MAX(f.FFetchDate),111) as '实际交货日期',
SUM(f.FQty) as '通知数量',
SUM(f.FQty*b.FPriceDiscount) as '金额',
SUM(b.FQty)-SUM(f.FQty) as '差异a',
Convert(char(10),MAX(g.FDate),111) as '出库日期',
SUM(g.FQty) as '出库数量',
SUM(g.FQty*b.FPriceDiscount) as '出库金额',
SUM(f.FQty)-SUM(g.FQty) as '差异b',
Convert(char(10),MAX(h.FDate),111) as '开票日期',
SUM(h.FQty) as '开票数量',
SUM(h.FAmount) as '开票金额',
SUM(g.FQty)-SUM(h.FQty) as '差异c',a.*
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID
left join t_Organization d on a.FCustID=d.FItemID
left join t_MeasureUnit e on e.FItemID=b.FUnitID
left join (select FSourceBillNo,FItemID,max(FFetchDate) as FFetchDate,sum(FQty) as FQty/*,sum(FAmount) as FAmount*/ from SEOutStock a left join SEOutStockEntry b on a.FInterID=b.FInterID Group by FSourceBillNo,FItemID) f on a.FBillNo=f.FSourceBillNo and b.FItemID=f.FItemID
left join (select FOrderBillNo,FItemID,max(FDate) as FDate,sum(FQty) as FQty/*,sum(FAmount) as FAmount*/ from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID group by FOrderBillNo,FItemID) g on a.FBillNo=g.FOrderBillNo and b.FItemID=g.FItemID
left join (select FOrderBillNo,FItemID,max(FDate) as FDate,sum(FQty) as FQty,sum(FAmount) as FAmount from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID group by FOrderBillNo,FItemID) h on a.FBillNo=h.FOrderBillNo and b.FItemID=h.FItemID
where a.FCancellation=0 
and a.FDate>='2011-05-01' and a.FDate<='2011-05-30' and a.FBillNo='SEORD000104' and a.FStatus=1
group by Convert(char(10),a.FDate,111)+a.FBillNo+d.FName+c.FName+c.FModel+e.FName with rollup
order by Max(d.fName),Max(a.FDate),Max(c.FName),Max(c.FModel)


select * from SEOrder where FBillNo='SEORD000105'


--where a.FBillNo='SEORD001992'

select FBillNo,sum(FQty) from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID WHERE a.FDate>='2011-05-01' and a.FDate<='2011-05-30' group by FBillNo,FItemID,FUnitID

select a.FDate,a.FBillNo,b.FItemID from SEOrder a left join (
select FBillNo,FItemID,FUnitID,sum(FQty) as FQty from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID WHERE a.FDate>='2011-05-01' and a.FDate<='2011-05-30' and a.FCancellation=0 group by FBillNo,FItemID,FUnitID
) b on a.FBillNo=b.FBillNo WHERE a.FDate>='2011-05-01' and a.FDate<='2011-05-30' and a.FCancellation=0
group by a.FDate,a.FBillNo,b.FItemID

select FBillNo,FCheckerID,* from SEOrder where FBillNo in ('SEORD001781','SEORD002097','SEORD002098')

select * from SEOrderEntry where FInterID='3081'



select FBillNo from SEOrder WHERE FDate>='2011-05-01' and FDate<='2011-05-30'

select sum(FQty) as FQty from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID WHERE a.FDate>='2011-05-01' and a.FDate<='2011-05-30' and a.FCancellation=0 

select * from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FBillNo='SEORD001763'



select FSourceBillNo,FCommitQty,FQty from SEOutStockEntry where FCommitQty<>FQty

select * from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FBillNo='SEORD001816'      --销售订单

select * from t_ICItem where FItemID=1467 --and FName='排气芯(SUS316)'        --产品表

select * from t_Organization   --客户表

select * from t_MeasureUnit    --计量单位

select * from SEOutStock a left join SEOutStockEntry b on a.FInterID=b.FInterID where b.FSourceBillNo='SEORD001816'    --发货通知

select * from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where FBillNo like 'XOUT%' --销售出库

select * from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID where FOrderBillNo='SEORD000098'   --销售发票

select * from T_user   --用户表

(select FOrderBillNo,FItemID,max(FDate) as FDate,sum(FQty) as FQty,sum(FAmount) as FAmount from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID group by FOrderBillNo,FItemID)

select * from ICSaleEntry a left join ICSale b on a.FInterID=b.FInterID where FOrderBillNo='SEORD000102'


select FBillID,min(FEntryID),sum(FSettleAmount) from t_rp_Exchange group by FBillID+FEntryID,FBillID with rollup

select sum(FSettleAmount) from t_rp_Exchange

select * from t_rp_Exchange

select * from t_RP_NewReceiveBill


select * from t_RP_NewReceiveBill



select FInterID from SEOrder

select * from SEOrderEntry

select convert(char(10),a.FDate,111) as 'djrq',convert(char(10),b.FDate,111) as 'jhrq',datediff(Day,getDate(), b.FDate) as 'sjc',a.FBillNo as 'djbh',d.FName as 'wldw',c.FName as 'cpmc',c.FModel as 'cpgg',e.FName as 'jldw', 
cast(b.FQty as decimal(18,2)) as '数量',
cast(b.FPriceDiscount as decimal(18,2)) as '含税单价',
cast(b.FAllAmount as decimal(18,2)) as '含税金额'
from SEOrder a 
left join SEOrderEntry b on a.FInterID=b.FInterID 
left join t_ICItem c on b.FItemID=c.FItemID
left join t_Organization d on a.FCustID=d.FItemID
left join t_MeasureUnit e on e.FItemID=b.FUnitID
where a.FBillNo='SEORD000105'
and a.FStatus<=1
and not exists(select * from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where b.FOrderBillNo=a.FBillNo)







SEORD001797
SEORD001795
SEORD001796
SEORD001798
SEORD001800
SEORD001799
SEORD001801
SEORD001802
SEORD001803
SEORD001804
SEORD001805
SEORD001806
SEORD001812
SEORD001807
SEORD001808
SEORD001809
SEORD001810
SEORD001811
SEORD001813
SEORD001814
SEORD001818
SEORD001815
SEORD001816
SEORD001817
SEORD001815
SEORD001819
SEORD001820
SEORD001821
SEORD001821
SEORD001822
SEORD001829
SEORD001823
SEORD001824
SEORD001825
SEORD001826
SEORD001827
SEORD001828
SEORD001831
SEORD001830
SEORD001833
SEORD001832
SEORD001834
SEORD001835
SEORD001841
SEORD001836
SEORD001837
SEORD001838
SEORD001839
SEORD001840
SEORD001842
SEORD001843
SEORD001844
SEORD001845
SEORD001846
SEORD001847
SEORD001848
SEORD001849
SEORD001850
SEORD001851
SEORD001852
SEORD001853
SEORD001855
SEORD001868
SEORD001870
SEORD001871
SEORD001871
SEORD001829
SEORD001849
SEORD001899
SEORD001830
SEORD001849
SEORD001961