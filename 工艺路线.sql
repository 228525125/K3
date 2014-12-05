select c.FNumber,c.FHelpCode,b.FOperSN,d.FName from t_Routing a 
left join t_RoutingOper b on a.FInterID=b.FInterID and b.FInterID>0
left join t_ICItem c on a.FItemID=c.FItemID
left join t_SubMessage d on b.FOperID=d.FInterID

--
select i.FNumber,FIsOut,FqualityChkID,a.* from t_Routing a left join t_RoutingOper b on a.FInterID=b.FInterID left join t_ICItem i on a.FItemID=i.FItemID 
where 1=1 
and FIsOut=1059         --是否外协 为否
and FQualityChkID=352 
and FWorkCenterID=3599  --加工中心 为外协

update t_RoutingOper set FIsOut=1058 where FIsOut=1059 and FWorkCenterID=3599 

--FIsOut 是否外协,FqualityChkID 检验方式
select i.FNumber,FIsOut,FqualityChkID,* from t_RoutingOper a left join t_ICItem i on a.FItemID=i.FItemID where FIsOut=1058 and FQualityChkID=352

update t_RoutingOper set FqualityChkID=353 where FIsOut=1058 and FQualityChkID=352

select * from t_RoutingGroup

select * from t_SubMessage where FParentID=61


----删除工艺路线有外协后面跟包装工序
select i.FNumber,b.* from t_Routing a left join t_RoutingOper b on a.FInterID=b.FInterID left join t_ICItem i on a.FItemID=i.FItemID where 1=1 
--and i.FNumber = '05.02.2180'
and b.FOperID=40070 and exists(select 1 from t_RoutingOper r where a.FInterID=r.FInterID and r.FOperID=40037) 
and a.FDefault = 1058
and b.FEntryID=2
order by i.FNumber

delete b from t_Routing a left join t_RoutingOper b on a.FInterID=b.FInterID left join t_ICItem i on a.FItemID=i.FItemID where 1=1 
and b.FOperID=40070 and exists(select 1 from t_RoutingOper r where a.FInterID=r.FInterID and r.FOperID=40037) 
and a.FDefault = 1058
and b.FEntryID=2
