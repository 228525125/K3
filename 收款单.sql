

SELECT * FROM t_RP_NewReceiveBill WHERE FNumber='XSKD000060'

SELECT * FROM  WHERE FBillNo='ZSEFP000011'

select u1.FAllHookQTY as '勾稽数量',u1.FCurrentHookAmount as '本期勾稽金额', u1.FCurrentHookQTY as '本期勾稽数量',u1.FAmount_Commit as '关联金额',u1.FCheckAmount as '核销金额',u1.FCheckQty as '核销数量',* from ICSale v1 INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 where FBillNo='ZSEFP000011'

