/* 查看哪些是无效代码，哪些无BOM数据*/
select a.wldm,b.FNumber,c.FBOMNumber 
from rss.dbo.zzpb201212 a 
left join t_ICItem b on a.wldm=b.FNumber
left join (
select d.FNumber as cpdm,d.FName as cpmc,d.FModel as cpgg,a.FBOMNumber 
from ICBOM a 
left join t_ICItem d on a.FItemID=d.FItemID
where a.FStatus=1 and a.FUseStatus=1072
) c on b.FNumber=c.cpdm
group by a.wldm,b.FNumber,c.FBOMNumber 

/* 根据产品倒推物料构成*/
select cpdm,cpmc,cpgg,zzps,c.wldm,wlmc,jldw,zzps*FQty as zccl from t_ICItem a 
inner join (select wldm,sum(zzps) as zzps from rss.dbo.zzpb201212 group by wldm) b on a.FNumber=b.wldm
inner join (
select d.FNumber as cpdm,d.FName as cpmc,d.FModel as cpgg,a.FBOMNumber,c.FNumber as wldm,c.FName as wlmc,mu.FName as jldw,b.FQty 
from ICBOM a 
left join ICBOMCHILD b on a.FInterID=b.FInterID
left join t_ICItem c on b.FItemID=c.FItemID
left join t_ICItem d on a.FItemID=d.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID
where a.FStatus=1 and a.FUseStatus=1072
) c on b.wldm=c.cpdm
order by cpdm





select d.FNumber as cpdm,d.FName as cpmc,d.FModel as cpgg,a.FBOMNumber,c.FNumber as wldm,c.FName as wlmc,c.FModel as wlgg,mu.FName as jldw,b.FQty 
from ICBOM a 
left join ICBOMCHILD b on a.FInterID=b.FInterID
left join t_ICItem c on b.FItemID=c.FItemID
left join t_ICItem d on a.FItemID=d.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID
where a.FStatus=1 and a.FUseStatus=1072
AND d.FNumber >= '05.01.0002' AND d.FNumber <='05.01.0004'
order by d.FNumber









select d.FNumber as cpdm,d.FName as cpmc,d.FModel as cpgg,a.FBOMNumber,c.FNumber as wldm,c.FName as wlmc,mu.FName as jldw,b.FQty 
from ICBOM a 
left join ICBOMCHILD b on a.FInterID=b.FInterID
left join t_ICItem c on b.FItemID=c.FItemID
left join t_ICItem d on a.FItemID=d.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID
where a.FStatus=1 and a.FUseStatus=1072
and d.FNumber = '05.02.2025'



