

select v1.* from ICStockBill v1 
LEFT JOIN ICStockBillEntry u1 on v1.FInterID=u1.FInterID 
where v1.FTranType=41
and FBillNo in ('CHG000161')

update ICStockBill set FEmpID='237' where FTranType=41
and FBillNo in ('CHG000161')



select * from t_emp where FName like '%÷‹∂¨%'