

SELECT * FROM t_RP_NewReceiveBill WHERE FNumber='XSKD000060'

SELECT * FROM  WHERE FBillNo='ZSEFP000011'

select u1.FAllHookQTY as '��������',u1.FCurrentHookAmount as '���ڹ������', u1.FCurrentHookQTY as '���ڹ�������',u1.FAmount_Commit as '�������',u1.FCheckAmount as '�������',u1.FCheckQty as '��������',* from ICSale v1 INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 where FBillNo='ZSEFP000011'

