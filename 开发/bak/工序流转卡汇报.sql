select * from SHProcRptMain

select * from SHProcRpt


select 
a.FBillNo as '单据编号'
,convert(char(10),a.FDate,120) as '单据日期'
,b.FFlowCardNO as '流转卡编号' 
,b.FOperSN as '工序号'
,c.FName as '工序'
,case when b.FStatus=1 then '已派工' when b.FStatus=2 then '已打印' when b.FStatus=3 then '开工' when b.FStatus=4 then '完工' when b.FStatus=5 then '委外转出' when b.FStatus=6 then '委外接收' when b.FStatus=7 then '暂停' when b.FStatus=8 then '取消' end as '状态'
--,b.FIsOut as '是否外协'
--,b.FTeamTimeID as '班次'
,d.FName as '班组'
,emp.FName as '操作工'
,res1.FNumber as '设备编号1'
,res1.FName as '设备名称1'
,res2.FNumber as '设备编号2'
,res2.FName as '设备名称2'
,b.FStartWorkDate as '实际开工时间'
,b.FEndWorkDate as '实际完工时间'
,cast(cast(DATEDIFF(n,b.FStartWorkDate,b.FEndWorkDate) as decimal(28,2))/60 as decimal(28,2)) as '作业时间'
,mu.FName as '单位'
,b.FAuxQtyfinish as '实作数量'
--,b.FAuxQtyPass as '合格数量'
,b.FAuxQtyScrap as '因工报废数量'
,b.FAuxQtyForItem as '因料报废数量'
--,b.FAuxReprocessedQty as '返修数量'
,b.FTimeUnit as '时间单位'
,i.FNumber as '产品代码'
,i.FName as '产品名称'
,i.FModel as '产品规格'
,i.FHelpCode as '产品图号'
,b.FICMOBillNo as '生产任务单号'
from SHProcRptMain a
left join SHProcRpt b on a.FInterID=b.FInterID
left join (select FInterID,FName from t_SubMessage where FTypeID=61) c on c.FInterID=b.FOperID
left join (select FInterID,FName from t_SubMessage where FTypeID=62) d on d.FInterID=b.FTeamID
left join t_emp emp on b.FWorkerID=emp.FItemID
left join t_resource res1 on res1.FInterID=b.FShebei
left join t_resource res2 on res2.FInterID=b.FShebei2
left join t_ICItem i on b.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=i.FUnitID
where 1=1
and a.FDate>='2012-10-01' and a.FDate<='2012-10-31'
and b.FICMOBillNo ='WORK017537'


select b.FICMOBillNo as '生产任务单号'
,b.FOperSN as '工序号'
,c.FName as '工序'
,case when b.FStatus=1 then '已派工' when b.FStatus=2 then '已打印' when b.FStatus=3 then '开工' when b.FStatus=4 then '完工' when b.FStatus=5 then '委外转出' when b.FStatus=6 then '委外接收' when b.FStatus=7 then '暂停' when b.FStatus=8 then '取消' end as '状态'
,res1.FNumber as '设备编号'
,res1.FName as '设备名称'
,i.FNumber as '产品代码',i.FName as '产品名称',i.FModel as '产品规格',i.FHelpCode as '图号',mu.FName as '单位',sum(b.FAuxQtyfinish) as '实作数量',sum(b.FAuxQtyScrap) as '工废',sum(b.FAuxQtyForItem) as '料废','小时' as '时间单位',sum(cast(cast(DATEDIFF(n,b.FStartWorkDate,b.FEndWorkDate) as decimal(28,2))/60 as decimal(28,2))) as '作业时间'
from SHProcRptMain a
left join SHProcRpt b on a.FInterID=b.FInterID
left join (select FInterID,FName from t_SubMessage where FTypeID=61) c on c.FInterID=b.FOperID
left join (select FInterID,FName from t_SubMessage where FTypeID=62) d on d.FInterID=b.FTeamID
left join t_emp emp on b.FWorkerID=emp.FItemID
left join t_resource res1 on res1.FInterID=b.FShebei
left join t_resource res2 on res2.FInterID=b.FShebei2
left join t_ICItem i on b.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=i.FUnitID
LEFT JOIN ICMO icmo on b.FICMOBillNo=icmo.FBillNo
where 1=1
and a.FDate>='2012-10-01' and a.FDate<='2012-10-31'
and icmo.FStatus=1         --任务单状态是下达
group by b.FICMOBillNo,b.FOperSN,c.FName,b.FStatus,res1.FNumber,res1.FName,i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName
order by b.FICMOBillNo,b.FOperSN







select * from t_emp

select * from t_resource




--设备编号，设备名称，物料代码，物料名称，单位，实作数量，设备运行时间，人工操作时间，刀具消耗


select * from t_SubMesType 

select * from t_SubMessage where FTypeID=61

