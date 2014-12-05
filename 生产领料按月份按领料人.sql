
	select i.FNumber,convert(char(6),v1.FDate,112) as FDjyf,max(FPrice) as FPrice,sum(u1.FQty) as FQty 
	from ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
	LEFT JOIN t_emp e on v1.FSManagerID=e.FItemID
	LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
	where v1.FTranType=24 AND v1.FCancellation = 0 
	and v1.FDate>='2013-09-01' and v1.FDate<='2013-11-30' 
	--and v1.FDate>='2013-10-01' and v1.FDate<='2013-10-31' 
	--and v1.FDate>='2013-11-01' and v1.FDate<='2013-11-30' 
	--and e.FName = '¿µÓÂ'
	--and i.FNumber in ('02.02.02.039','02.02.02.039','02.02.02.039','02.02.02.200','02.02.02.199','02.02.05.003','02.02.07.002','02.02.02.124','02.02.02.079','02.02.02.030','02.02.02.032','02.02.02.216','02.02.03.093','02.02.04.050','02.02.04.079','02.02.03.029','02.02.03.052','02.02.03.003','02.02.07.012','02.02.05.020','02.02.07.013','02.02.04.048','02.02.02.085','02.02.02.222','02.02.02.146','01.02.05.096','01.02.05.081','01.02.05.005')
	--and i.FNumber in ('02.02.02.200','02.02.02.199','02.02.02.079','02.02.02.032')
	and i.FNumber in ('02.02.02.215','02.02.02.214','02.02.02.200','02.02.02.199','02.02.02.141')
	group by i.FNumber,convert(char(6),v1.FDate,112)
	order by i.FNumber,convert(char(6),v1.FDate,112)





select a.FNumber,FDjyf,b.FPrice,b.FQty from t_ICItem a
left join (

	select i.FNumber,convert(char(6),v1.FDate,112) as FDjyf,max(FPrice) as FPrice,sum(u1.FQty) as FQty 
	from ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
	LEFT JOIN t_emp e on v1.FSManagerID=e.FItemID
	LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
	where v1.FTranType=24 AND v1.FCancellation = 0 
	and v1.FDate>='2013-09-01' and v1.FDate<='2013-11-30' 
	--and v1.FDate>='2013-10-01' and v1.FDate<='2013-10-31' 
	--and v1.FDate>='2013-11-01' and v1.FDate<='2013-11-30' 
	and e.FName = '¿µÓÂ'
	and i.FNumber in ('02.02.02.039','02.02.02.039','02.02.02.039','02.02.02.200','02.02.02.199','02.02.05.003','02.02.07.002','02.02.02.124','02.02.02.079','02.02.02.030','02.02.02.032','02.02.02.216','02.02.03.093','02.02.04.050','02.02.04.079','02.02.03.029','02.02.03.052','02.02.03.003','02.02.07.012','02.02.05.020','02.02.07.013','02.02.04.048','02.02.02.085','02.02.02.222','02.02.02.146','01.02.05.096','01.02.05.081','01.02.05.005')
	group by i.FNumber,convert(char(6),v1.FDate,112)
	order by i.FNumber,convert(char(6),v1.FDate,112)

) b on a.FItemID=b.FItemID
where  1=1 and a.FNumber in ('02.02.02.039','02.02.02.039','02.02.02.039','02.02.02.200','02.02.02.199','02.02.05.003','02.02.07.002','02.02.02.124','02.02.02.079','02.02.02.030','02.02.02.032','02.02.02.216','02.02.03.093','02.02.04.050','02.02.04.079','02.02.03.029','02.02.03.052','02.02.03.003','02.02.07.012','02.02.05.020','02.02.07.013','02.02.04.048','02.02.02.085','02.02.02.222','02.02.02.146','01.02.05.096','01.02.05.081','01.02.05.005')


select * from t_emp where FName = 'Â¬Ç¿'





select i.FNumber,i.FName,convert(char(4),v1.FDate,112),sum(u1.FQty) as FQty ,sum(FAmount) as FAmount
	from ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
	LEFT JOIN t_emp e on v1.FSManagerID=e.FItemID
	LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
	where v1.FTranType=24 AND v1.FCancellation = 0 
	and v1.FDate>='2012-01-01' and v1.FDate<='2013-12-31' 
	group by i.FNumber,i.FName,convert(char(4),v1.FDate,112)
	order by convert(char(4),v1.FDate,112),i.FNumber



select * from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=24 AND v1.FCancellation = 0 


