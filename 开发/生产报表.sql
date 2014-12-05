--drop procedure report_sczzp drop procedure report_sczzp_count

create procedure report_sczzp 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
Create Table #DATA100(
wldm nvarchar(255),
wlmc nvarchar(255),
wlgg nvarchar(255),
jldw nvarchar(255),
qichu decimal(28,2),
touru decimal(28,2),
xiaohao decimal(28,2),
qimo decimal(28,2)
)

Create Table #temp(
wldm nvarchar(255),
wlmc nvarchar(255),
wlgg nvarchar(255),
jldw nvarchar(255),
qichu decimal(28,2),
touru decimal(28,2),
xiaohao decimal(28,2),
qimo decimal(28,2)
)
----------创建满足条件的临时任务单表----------

Create Table #DATA2( 
   FIndex  int IDENTITY, 
   FICMOInterID int null, 
   FICMONumber varchar(355) null, 
   FDeptID int null, 
   FSupplyID int null, 
   FDeptType smallint default(0) null,
   FType varchar(255) null, 
   FTypeName varchar(355) null, 
   FStatus  smallint null, 
   FSuspend  smallint null, 
   FItemID int null, 
   FPlanQty decimal(28,10) default(0) null, 
   FProInQty  decimal(28,10) default(0) null, 
   FLeaveQty decimal(28,10) default(0) null) 

----------创建报表临时表----------
 CREATE TABLE #DATA(                    
     FRow int default(0),               --判断是车间汇总还是车间+任务单汇总
     FDeptID int Null,                  
     FDeptNumber varchar(355) Null,       
     FDeptName varchar(355) Null,       
     FDeptType smallint default(0) null,--0：生产车间，1：委外单位，2：总计
     FICMOInterID int null,             
     FICMOBillNo varchar(355) null,         
     FBillNo varchar(355) null, --投料单号        
     FPosPlace varchar(300) null,        
     FItemId int null,                  
     FChildItemId int null,             
     FNumber  varchar(355) null,        
     FShortNumber  varchar(355) null,   
     FName  varchar(355) null,          
     FModel  varchar(355) null,         
     FUnitName  varchar(355) null,      
     FProQtyDecimal smallint null,         
     FPriceDecimal smallint null,       
     FBillInterID int null,             
     FStatus varchar(30) null,          
     FSuspend varchar(30) null,         
     FPlanQty decimal(28,10) default(0) null,                                  
     FProInQty decimal(28,10) default(0) null,                                 
     FLeaveQty decimal(28,10) default(0) null,                                 
     FQtyDecimal int default(2) null,                                               
     FChildNumber varchar(355) null,                                          
     FChildShortNumber varchar(355) null,                                     
     FChildName varchar(355) null,                                            
     FChildModel varchar(355) null,                                           
     FChildUnitName varchar(355) null,                                        
     FChildNeedQty decimal(28,10) default(0) null,                             
     FChildOutQty decimal(28,10) default(0) null,                              
     FChildDiscardQty decimal(28,10) default(0) null,                          
     FChildWIPQty decimal(28,10) default(0) null,                              
     FUnitNameCu  varchar(355) null,   ---产品常用计量单位                    
     FPlanQtyCu decimal(28,10) default(0) null,  ----产品计划数量(常用)        
     FProInQtyCu decimal(28,10) default(0) null, ----产品入库数量(常用)        
     FLeaveQtyCu decimal(28,10) default(0) null, ----产品剩余数量(常用)        
     FChildUnitNameCu varchar(355) null,  ----物料基本计量单位(常用)          
     FChildNeedQtyCu decimal(28,10) default(0) null, ----物料需求数量(常用)    
     FChildOutQtyCu decimal(28,10) default(0) null,  ----物料已领数量(常用)    
     FChildDiscardQtyCu decimal(28,10) default(0) null,   ----物料报数量(常用) 
     FChildWIPQtyCu decimal(28,10) default(0) null, ----物料在制品量           
     FSumSort smallint not null Default(0),                                   
     FInterID int not null Default(0),                                   
     FTranType int not null Default(88))                                   

CREATE TABLE #TDATA(                    
     FRow int default(0),               --判断是车间汇总还是车间+任务单汇总
     FDeptID int Null,                  
     FDeptNumber varchar(355) Null,       
     FDeptName varchar(355) Null,       
     FDeptType smallint default(0) null,--0：生产车间，1：委外单位，2：总计
     FICMOInterID int null,             
     FICMOBillNo varchar(355) null,         
     FBillNo varchar(355) null, --投料单号        
     FPosPlace varchar(300) null,        
     FItemId int null,                  
     FChildItemId int null,             
     FNumber  varchar(355) null,        
     FShortNumber  varchar(355) null,   
     FName  varchar(355) null,          
     FModel  varchar(355) null,         
     FUnitName  varchar(355) null,      
     FProQtyDecimal smallint null,         
     FPriceDecimal smallint null,       
     FBillInterID int null,             
     FStatus varchar(30) null,          
     FSuspend varchar(30) null,         
     FPlanQty decimal(28,10) default(0) null,                                  
     FProInQty decimal(28,10) default(0) null,                                 
     FLeaveQty decimal(28,10) default(0) null,                                 
     FQtyDecimal int default(2) null,                                               
     FChildNumber varchar(355) null,                                          
     FChildShortNumber varchar(355) null,                                     
     FChildName varchar(355) null,                                            
     FChildModel varchar(355) null,                                           
     FChildUnitName varchar(355) null,                                        
     FChildNeedQty decimal(28,10) default(0) null,                             
     FChildOutQty decimal(28,10) default(0) null,                              
     FChildDiscardQty decimal(28,10) default(0) null,                          
     FChildWIPQty decimal(28,10) default(0) null,                              
     FUnitNameCu  varchar(355) null,   ---产品常用计量单位                    
     FPlanQtyCu decimal(28,10) default(0) null,  ----产品计划数量(常用)        
     FProInQtyCu decimal(28,10) default(0) null, ----产品入库数量(常用)        
     FLeaveQtyCu decimal(28,10) default(0) null, ----产品剩余数量(常用)        
     FChildUnitNameCu varchar(355) null,  ----物料基本计量单位(常用)          
     FChildNeedQtyCu decimal(28,10) default(0) null, ----物料需求数量(常用)    
     FChildOutQtyCu decimal(28,10) default(0) null,  ----物料已领数量(常用)    
     FChildDiscardQtyCu decimal(28,10) default(0) null,   ----物料报数量(常用) 
     FChildWIPQtyCu decimal(28,10) default(0) null, ----物料在制品量           
     FSumSort smallint not null Default(0),                                   
     FInterID int not null Default(0),                                   
     FTranType int not null Default(88))

-------获得满足条件的生产任务单-----------
----非委外生产
 Insert Into #DATA2(FICMOInterID,FICMONumber,FItemID,FPlanQty,FDeptType,FDeptID,FType,FTypeName,FStatus,FSuspend,FProInQty,FLeaveQty) 
 Select a.FInterID,a.FBillNo,a.FItemID,a.FQty,a.FDeptType,a.FDeptID,a.FID,a.FName,a.FStatus,a.FSuspend,a.FStockQty,a.FLeaveQty 
 From (Select v1.FInterID,v1.FBillNo,v1.FItemID,round(v1.FQty,t1.FQtyDecimal) FQty ,
     0 FDeptType,v1.FWorkShop FDeptID,t5.FID,t5.FName,v1.FStatus,v1.FSuspend,v1.FStockQty,(v1.FQty-v1.FStockQty) as FLeaveQty  
 From ICMO v1,t_ICItem t1,t_DepartMent t2,t_WorkType t3,t_Submessage t5 
 Where v1.FItemID = t1.FItemID and v1.FWorkShop = t2.FItemID 
 and v1.FType = t5.FInterID and t5.FTypeID = 243 and v1.FWorkTypeId=t3.FInterId 
AND convert(datetime,convert(varchar(30),v1.FCheckDate,111)) >=@begindate
AND convert(datetime,convert(varchar(30),v1.FCheckDate,111)) <=@enddate AND (t5.FID = 'LX1' or t5.FID = 'LX2' or t5.FID = 'LX4'  or t5.FID = 'LX6' ) AND 
v1.FStatus IN (1,2,3) And v1.FCancelLation=0  and  v1.FTranType=85 AND V1.FType<>11060 

----委外生产
  Union 
 Select v1.FInterID,v1.FBillNo,v1.FItemID,round(v1.FQty,t1.FQtyDecimal) FQty ,
     1 FDeptType,v1.FSupplyID FDeptID,t5.FID,t5.FName,v1.FStatus,v1.FSuspend,v1.FStockQty,(v1.FQty-v1.FStockQty) as FLeaveQty 
 From ICMO v1,t_ICItem t1,t_Supplier t2,t_WorkType t3,t_Submessage t5 
 Where v1.FItemID = t1.FItemID and v1.FSupplyID= t2.FItemID 
 and v1.FType = t5.FInterID and t5.FTypeID = 243 and v1.FWorkTypeId=t3.FInterId 
AND convert(datetime,convert(varchar(30),v1.FCheckDate,111)) >=@begindate
AND convert(datetime,convert(varchar(30),v1.FCheckDate,111)) <=@enddate AND (t5.FID = 'LX1' or t5.FID = 'LX2' or t5.FID = 'LX4'  or t5.FID = 'LX6' ) AND 
v1.FStatus IN (1,2,3) And v1.FCancelLation=0  and  v1.FTranType=85 AND V1.FType<>11060 

 ) a Order by a.FBillNo 
-------原料计划投料数量、已领数量、报废数量、在制品数量 From PPBOM                                             
Insert Into #DATA (FDeptID,FDeptType,FICMOInterID,FICMOBillNo,FBillNo,FChildItemID,                                        
          FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FInterID)                                     
Select v1.FDeptID,v1.FDeptType,v1.FICMOInterID,v1.FICMONumber,u1.FBillNo,u2.FItemID,                                      
  round(u2.FQtyMust,t1.FQtyDecimal),                                                                        
  round(u2.FStockQty,t1.FQtyDecimal),                                                                       
  round(u2.FDiscardQty,t1.FQtyDecimal),                                                                     
  round(u2.FWIPQty,t1.FQtyDecimal),u1.FInterID                                                                          
From #DATA2 v1, PPBOM u1,PPBOMEntry u2,t_ICItem t1                                                             
Where u2.FMaterielType=371 and /*只处理普通件*/v1.FICMOInterID = u1.FICMOInterID and u1.FInterID = u2.FInterID 
and u2.FItemID = t1.FItemID  --AND t1.FNumber>='06.07.0045' AND t1.FNumber<='06.07.0045'
--and s2.FCheckDate>=@begindate and s2.FCheckDate<=@enddate

/*Insert Into #DATA (FDeptID,FDeptType,FICMOInterID,FICMOBillNo,FBillNo,FChildItemID,
          FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FInterID)
select v1.FDeptID,v1.FDeptType,v1.FICMOInterID,v1.FICMOBillNo,v1.FBillNo,v1.FChildItemID,v1.FChildNeedQty,v1.FChildOutQty,v1.FChildDiscardQty,v1.FChildWIPQty,v1.FInterID 
FROM #TDATA v1
LEFT JOIN ICStockBillEntry s1 ON s1.FICMOInterID=v1.FICMOInterID
LEFT JOIN ICStockBill s2 on s2.FInterID = s1.FInterID AND s1.FInterID <>0 
WHERE 1=1
and s2.FCheckDate>=@begindate and s2.FCheckDate<=@enddate*/

--------刷新产品数量                                                                                           
UPDATE T1 SET T1.FItemID=T2.FItemID,T1.FPlanQty=T2.FPlanQty,T1.FProInQty=T2.FProInQty,T1.FLeaveQty=T2.FLeaveQty
FROM #DATA T1,#DATA2 T2                                                                                        
WHERE T1.FICMOInterID=T2.FICMOInterID                                                                   
                                                                                                               
select min(FChildItemID) FChildItemID ,FICMOInterID into #Repdata from #data where FSumSort=0                  
    group by FICMOInterID having count(*)>1                                                                    
                                                                                                               
update t1 set FPlanQty=0,FLeaveQty=0,FProInQty=0 from #data t1,#Repdata t2                                     
    where t1.FICMOInterID=t2.FICMOInterID and t1.FChildItemID>t2.FChildItemID                                  

------按车间+任务单汇总----
--任务单小计
INSERT INTO #DATA(FDeptType,FDeptID,FICMOInterID,FItemID,FPlanQty,FProInQty,FLeaveQty,               
  FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FSumSort)                     
SELECT FDeptType,FDeptID,FICMOInterID,FItemID,SUM(FPlanQty), SUM(FProInQty),SUM(FLeaveQty),          
  SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty),101       
FROM #DATA                                                                                   
GROUP BY FDeptType,FDeptID,FICMOInterID,FItemID                                                      
UPDATE T1 SET T1.FICMOBillNo=T2.FBillNo FROM #DATA T1,ICMO T2 WHERE T1.FICMOInterID = T2.FInterID
--车间小计
INSERT INTO #DATA(FDeptType,FDeptID,FPlanQty,FProInQty,FLeaveQty,                            
  FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FSumSort)                     
SELECT FDeptType,FDeptID,SUM(FPlanQty),SUM(FProInQty),SUM(FLeaveQty),                        
  SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty),110       
FROM #DATA                                                                                   
WHERE FSumSort=101                                                                           
GROUP BY FDeptType,FDeptID                                                                   
--总计
INSERT INTO #DATA(FDeptType,FPlanQty,FProInQty,FLeaveQty,                                    
  FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FSumSort)                     
SELECT 2,SUM(FPlanQty),SUM(FProInQty),SUM(FLeaveQty),                                        
  SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty),100       
FROM #DATA                                                                                   
WHERE FSumSort=110                                                                           

------------------按车间汇总                                                                                   
INSERT INTO #DATA(FRow,FDeptType,FDeptID,FChilDItemID,FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty)          
SELECT 1 FRow,FDeptType,FDeptID,FChildItemID,SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty)
FROM #DATA WHERE FSumSort=0 GROUP BY FDeptType,FDeptID,FChildItemID                                                      
                                                                                                               
INSERT INTO #DATA(FRow,FDeptType,FDeptID,FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FSumSort)    
SELECT 1,FDeptType,FDeptID,SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty),110    
FROM #DATA                                                                                                     
WHERE FRow=1 AND FSumSort=0                                                                                    
GROUP BY FDeptType,FDeptID                                                                                     
                                                                                                               
INSERT INTO #DATA(FRow,FDeptType,FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FSumSort)            
SELECT 1,2,SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty),100                    
FROM #DATA                                                                                                     
WHERE FRow=1 AND FSumSort=110                                                                                  
 Update u1 set u1.FDeptName = isnull(u2.FName,'(其他生产车间)'),u1.FDeptNumber=u2.FNumber                              
 from #DATA u1 Left Join t_DepartMent u2 on u1.FDeptID = u2.FItemID                                                             
 where u1.FDeptType = 0                                        
 Update u1 set u1.FDeptName =  isnull(u2.FName ,'(其他外协单位)'),u1.FDeptNumber=u2.FNumber                            
 from #DATA u1 Left join t_Supplier u2 on u1.FDeptID = u2.FItemID                                                               
 where u1.FDeptType = 1                                        
                                                                                            
 --Update #DATA set FDeptName = RTRIM(substring(FDeptName,4,255))                           
                                                                                            
 Update #DATA Set FDeptName = '总计' where FSumSort=100                                     
 Update #DATA Set FICMOBillNo = FICMOBillNo +'(小计)' Where FSumSort = 101                          
 Update #DATA Set FDeptName = FDeptName +'(小计)' Where FSumSort = 110                      
                                                                                            
 delete from #data where FChildItemId is null and FSumSort=0                                
                                                                                            
 Update v1 set v1.FItemId=u1.FItemId ,                                                      
     v1.FBillInterID = u1.FICMOInterID,v1.FPlanQty = u1.FPlanQty,                           
     v1.FProInQty = u1.FProInQty,v1.FLeaveQty = u1.FLeaveQty,                               
     v1.FStatus = (case u1.FStatus when 0 then '计划' when 3 then '结案' else '下达' end ), 
     v1.FSuspend = (case u1.Fsuspend when 1 then '挂起' else '未挂起' end )                 
 From #DATA v1,#DATA2 u1                                                                    
 Where v1.FICMOBillNo = u1.FICMONumber                                                          
 Update v1 set v1.FPosPlace = t2.FMachinepos                                           
 From #DATA v1,PPBom t1,PPBomEntry t2                                                       
 Where v1.FBillInterID = t1.FICMOInterID                                                    
     and t2.FInterID = t1.FInterID                                                          
 ---------产品基本信息                                                                             
 UPDATE t1 SET t1.FNumber=t2.FNumber,t1.FName=t2.FName,t1.FShortNumber=t2.FShortNumber,            
    t1.FModel=isnull(t2.FModel,''),t1.FProQtyDecimal=t2.FQtyDecimal,t1.FPriceDecimal=t2.FPriceDecimal,
    t1.FUnitName=t3.FName                                                                          
 FROM #DATA t1,t_ICItem t2,t_MeasureUnit t3                                                        
 WHERE t1.FItemId=t2.FItemId                                                                       
    AND t2.FUnitGroupID=t3.FUnitGroupID and t2.FUnitId=t3.FMeasureUnitId                           
---产品常用数据                                                                    
 UPDATE t1 SET t1.FUnitNameCu=t3.FName,                                            
    t1.FPlanQtyCu=round(t1.FPlanQty / isnull(t3.FCoefficient,1),t1.FProQtyDecimal),   
    t1.FProInQtyCu=round(t1.FProInQty / isnull(t3.FCoefficient,1),t1.FProQtyDecimal), 
    t1.FLeaveQtyCu=round(t1.FLeaveQty / isnull(t3.FCoefficient,1),t1.FProQtyDecimal)  
 FROM #DATA t1,t_ICItem t2,t_MeasureUnit t3  WHERE t1.FNumber=t2.FNumber           
    AND t2.FUnitGroupID=t3.FUnitGroupID  and t3.FCoefficient<>0                    
    and t2.FProductUnitID=t3.FMeasureUnitId                                             

---------物料基本数据                                                              
 Update v1 set                                                                     
     v1.FChildNumber=tt1.FNumber,                                                  
     v1.FChildShortNumber = tt1.FShortNumber,                                      
     v1.FChildName = tt1.FName, v1.FChildModel = tt1.FModel,                       
     v1.FChildUnitName = tt2.FName,                                                
     v1.FQtyDecimal=tt1.FQtyDecimal                                           
 From #DATA v1,t_ICItem tt1,t_MeasureUnit tt2                                      
 Where                                                                             
     v1.FChildItemID = tt1.FItemID                                                 
     and tt1.FUnitGroupID=tt2.FUnitGroupID and tt1.fUnitId=tt2.FMeasureUnitId      


 update #data set FChildNeedQty=round(FChildNeedQty,FQtyDecimal), 
    FChildOutQty=round(FChildOutQty,FQtyDecimal), 
    FChildDiscardQty=round(FChildDiscardQty,FQtyDecimal), 
    FChildWIPQty=round(FChildWIPQty,FQtyDecimal), 
    FPlanQty=round(FPlanQty,FProQtyDecimal), 
    FProInQty=round(FProInQty,FProQtyDecimal), 
    FLeaveQty=round(FLeaveQty,FProQtyDecimal)  where FSumSort=0

----物料常用数据
 Update v1 set  v1.FChildUnitNameCu = tt2.FName, 
    v1.FChildNeedQtyCu=round(v1.FChildNeedQty / isnull(tt2.FCoefficient,1),v1.FQtyDecimal), 
    v1.FChildOutQtyCu=round(v1.FChildOutQty /  isnull(tt2.FCoefficient,1),v1.FQtyDecimal), 
    v1.FChildDiscardQtyCu=round(v1.FChildDiscardQty / isnull(tt2.FCoefficient,1),v1.FQtyDecimal), 
    v1.FChildWIPQtyCu=round(v1.FChildWIPQty / isnull(tt2.FCoefficient,1),v1.FQtyDecimal) 
 From #DATA v1,t_ICItem t1, t_MeasureUnit tt2 
 where v1.FChildNumber = t1.FNumber 
    and t1.FUnitGroupID=tt2.FUnitGroupID  
    and t1.FProductUnitID=tt2.FMeasureUnitId  and  tt2.FCoefficient<>0


------刷新产品车间小计和总计常用数据---------
UPDATE T1 SET T1.FPlanQtyCu=T2.FPlanQtyCu,T1.FProInQtyCu=T2.FProInQtyCu,                        
              T1.FLeaveQtyCu=T2.FLeaveQtyCu                   
FROM #DATA T1,(SELECT FDeptID,SUM(FPlanQtyCu) FPlanQtyCu,SUM(FProInQtyCu) FProInQtyCu,     
                              SUM(FLeaveQtyCu) FLeaveQtyCu
               FROM #DATA WHERE FSumSort=101 GROUP BY FDeptID) T2                                            
Where T1.FDeptID = T2.FDeptID And T1.FSumSort = 110                                                   
UPDATE T1 SET T1.FPlanQtyCu=T2.FPlanQtyCu,T1.FProInQtyCu=T2.FProInQtyCu,                        
              T1.FLeaveQtyCu=T2.FLeaveQtyCu   
FROM #DATA T1,(SELECT FRow,SUM(FPlanQtyCu) FPlanQtyCu,SUM(FProInQtyCu) FProInQtyCu,             
                           SUM(FLeaveQtyCu) FLeaveQtyCu  
               FROM #DATA WHERE FSumSort=110 GROUP BY FRow) T2                                                  
Where T1.FRow=T2.FRow AND T1.FSumSort = 100     
------刷新子项物料的小计和总计常用数据---------
UPDATE T1 SET T1.FChildNeedQtyCu=T2.FChildNeedQtyCu,T1.FChildOutQtyCu=T2.FChildOutQtyCu,                        
              T1.FChildDiscardQtyCu=T2.FChildDiscardQtyCu,T1.FChildWIPQtyCu=T2.FChildWIPQtyCu                   
FROM #DATA T1,(SELECT FICMOInterID,SUM(FChildNeedQtyCu) FChildNeedQtyCu,SUM(FChildOutQtyCu) FChildOutQtyCu,     
                                   SUM(FChildDiscardQtyCu) FChildDiscardQtyCu,SUM(FChildWIPQtyCu) FChildWIPQtyCu
               FROM #DATA WHERE FSumSort=0 GROUP BY FICMOInterID) T2                                            
Where T1.FICMOInterID = T2.FICMOInterID And T1.FSumSort = 101                                                   
UPDATE T1 SET T1.FChildNeedQtyCu=T2.FChildNeedQtyCu,T1.FChildOutQtyCu=T2.FChildOutQtyCu,                        
              T1.FChildDiscardQtyCu=T2.FChildDiscardQtyCu,T1.FChildWIPQtyCu=T2.FChildWIPQtyCu                   
FROM #DATA T1,(SELECT FDeptID,SUM(FChildNeedQtyCu) FChildNeedQtyCu,SUM(FChildOutQtyCu) FChildOutQtyCu,          
                              SUM(FChildDiscardQtyCu) FChildDiscardQtyCu,SUM(FChildWIPQtyCu) FChildWIPQtyCu     
               FROM #DATA WHERE FSumSort=101 GROUP BY FDeptID) T2                                               
Where T1.FDeptID = T2.FDeptID And T1.FSumSort = 110                                                             
UPDATE T1 SET T1.FChildNeedQtyCu=T2.FChildNeedQtyCu,T1.FChildOutQtyCu=T2.FChildOutQtyCu,                        
              T1.FChildDiscardQtyCu=T2.FChildDiscardQtyCu,T1.FChildWIPQtyCu=T2.FChildWIPQtyCu                   
FROM #DATA T1,(SELECT FRow,SUM(FChildNeedQtyCu) FChildNeedQtyCu,SUM(FChildOutQtyCu) FChildOutQtyCu,             
                           SUM(FChildDiscardQtyCu) FChildDiscardQtyCu,SUM(FChildWIPQtyCu) FChildWIPQtyCu        
               FROM #DATA WHERE FSumSort=110 GROUP BY FRow) T2                                                  
Where T1.FRow=T2.FRow AND T1.FSumSort = 100                                                                     
-------去除小计中的产品信息----
update t1 set /*FPlanQty=0,FLeaveQty=0,FProInQty=0,*/FItemID=NULL,FNumber=NULL,FShortNumber=NULL,
              FName=NULL,FModel=NULL,FUnitName=NUll,FUnitNameCu=Null  from #data t1,#Repdata t2
Where t1.FICMOInterID = t2.FICMOInterID And t1.FChildItemID IS NULL

UPDATE t1 SET t1.FQtyDecimal=(case when t2.fqtydecimal>t3.fqtydecimal then t2.fqtydecimal else t3.fqtydecimal end)
from #DATA t1,t_icitembase t2,t_icitembase t3 where t1.fitemid=t2.fitemid and t1.fchilditemid=t3.fitemid and t1.FSumSort=0 

------合计项数量进度取物料数量精度最大值----
UPDATE #DATA SET FQtyDecimal=(SELECT MAX(FQtyDecimal) FROM #DATA) WHERE FSumSort<>0

--SELECT * FROM #DATA WHERE FRow=1 order by FDeptType,FDeptName                   
Drop Table #DATA2                                                     
drop table #RepData                                                   
--drop table #RepData2                                                   

Insert Into #temp(wldm,wlmc,wlgg,jldw,qichu,touru,xiaohao,qimo
)
SELECT i.FNumber,i.FName,i.FModel,mu.FName,isnull(sc.qichu,0) as qichu,isnull(b.FChildOutQty,0) as touru,isnull(b.FChildOutQty,0)-isnull(b.FChildWIPQty,0) as xiaohao,isnull(sc.qichu,0)+isnull(b.FChildOutQty,0)-(isnull(b.FChildOutQty,0)-isnull(b.FChildWIPQty,0)) as qimo 
FROM t_ICItem i
LEFT JOIN t_MeasureUnit mu on mu.FItemID=i.FUnitID 
LEFT JOIN rss.dbo.sc_report sc on i.FNumber=sc.wldm
/*LEFT JOIN (
select u1.FItemID,sum(FQty) as FQty from ICStockBill v1 
inner join ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
group by u1.FItemID
) a on a.FItemID=i.FItemID*/
LEFT JOIN #DATA b on i.FItemID=b.FChildItemID and b.FRow=1
where 1=1
AND (qichu<>0 /*or a.FQty<>0*/ or b.FChildOutQty<>0 or (isnull(b.FChildOutQty,0)-isnull(b.FChildWIPQty,0))<>0)
AND (i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%')
order by i.FNumber

DROP TABLE #DATA

if @orderby='null'
exec('Insert Into #DATA100(wldm,wlmc,wlgg,jldw,qichu,touru,xiaohao,qimo)select * from #temp')
else
exec('Insert Into #DATA100(wldm,wlmc,wlgg,jldw,qichu,touru,xiaohao,qimo)select * from #temp order by '+ @orderby+' '+ @ordertype)

select * from #DATA100
end

--count--
create procedure report_sczzp_count 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
Create Table #DATA100(
wldm nvarchar(255),
wlmc nvarchar(255),
wlgg nvarchar(255),
jldw nvarchar(255),
qichu decimal(28,2),
touru decimal(28,2),
xiaohao decimal(28,2),
qimo decimal(28,2)
)

Create Table #temp(
wldm nvarchar(255),
wlmc nvarchar(255),
wlgg nvarchar(255),
jldw nvarchar(255),
qichu decimal(28,2),
touru decimal(28,2),
xiaohao decimal(28,2),
qimo decimal(28,2)
)
----------创建满足条件的临时任务单表----------

Create Table #DATA2( 
   FIndex  int IDENTITY, 
   FICMOInterID int null, 
   FICMONumber varchar(355) null, 
   FDeptID int null, 
   FSupplyID int null, 
   FDeptType smallint default(0) null,
   FType varchar(255) null, 
   FTypeName varchar(355) null, 
   FStatus  smallint null, 
   FSuspend  smallint null, 
   FItemID int null, 
   FPlanQty decimal(28,10) default(0) null, 
   FProInQty  decimal(28,10) default(0) null, 
   FLeaveQty decimal(28,10) default(0) null) 

----------创建报表临时表----------
 CREATE TABLE #DATA(                    
     FRow int default(0),               --判断是车间汇总还是车间+任务单汇总
     FDeptID int Null,                  
     FDeptNumber varchar(355) Null,       
     FDeptName varchar(355) Null,       
     FDeptType smallint default(0) null,--0：生产车间，1：委外单位，2：总计
     FICMOInterID int null,             
     FICMOBillNo varchar(355) null,         
     FBillNo varchar(355) null, --投料单号        
     FPosPlace varchar(300) null,        
     FItemId int null,                  
     FChildItemId int null,             
     FNumber  varchar(355) null,        
     FShortNumber  varchar(355) null,   
     FName  varchar(355) null,          
     FModel  varchar(355) null,         
     FUnitName  varchar(355) null,      
     FProQtyDecimal smallint null,         
     FPriceDecimal smallint null,       
     FBillInterID int null,             
     FStatus varchar(30) null,          
     FSuspend varchar(30) null,         
     FPlanQty decimal(28,10) default(0) null,                                  
     FProInQty decimal(28,10) default(0) null,                                 
     FLeaveQty decimal(28,10) default(0) null,                                 
     FQtyDecimal int default(2) null,                                               
     FChildNumber varchar(355) null,                                          
     FChildShortNumber varchar(355) null,                                     
     FChildName varchar(355) null,                                            
     FChildModel varchar(355) null,                                           
     FChildUnitName varchar(355) null,                                        
     FChildNeedQty decimal(28,10) default(0) null,                             
     FChildOutQty decimal(28,10) default(0) null,                              
     FChildDiscardQty decimal(28,10) default(0) null,                          
     FChildWIPQty decimal(28,10) default(0) null,                              
     FUnitNameCu  varchar(355) null,   ---产品常用计量单位                    
     FPlanQtyCu decimal(28,10) default(0) null,  ----产品计划数量(常用)        
     FProInQtyCu decimal(28,10) default(0) null, ----产品入库数量(常用)        
     FLeaveQtyCu decimal(28,10) default(0) null, ----产品剩余数量(常用)        
     FChildUnitNameCu varchar(355) null,  ----物料基本计量单位(常用)          
     FChildNeedQtyCu decimal(28,10) default(0) null, ----物料需求数量(常用)    
     FChildOutQtyCu decimal(28,10) default(0) null,  ----物料已领数量(常用)    
     FChildDiscardQtyCu decimal(28,10) default(0) null,   ----物料报数量(常用) 
     FChildWIPQtyCu decimal(28,10) default(0) null, ----物料在制品量           
     FSumSort smallint not null Default(0),                                   
     FInterID int not null Default(0),                                   
     FTranType int not null Default(88))                                   

CREATE TABLE #TDATA(                    
     FRow int default(0),               --判断是车间汇总还是车间+任务单汇总
     FDeptID int Null,                  
     FDeptNumber varchar(355) Null,       
     FDeptName varchar(355) Null,       
     FDeptType smallint default(0) null,--0：生产车间，1：委外单位，2：总计
     FICMOInterID int null,             
     FICMOBillNo varchar(355) null,         
     FBillNo varchar(355) null, --投料单号        
     FPosPlace varchar(300) null,        
     FItemId int null,                  
     FChildItemId int null,             
     FNumber  varchar(355) null,        
     FShortNumber  varchar(355) null,   
     FName  varchar(355) null,          
     FModel  varchar(355) null,         
     FUnitName  varchar(355) null,      
     FProQtyDecimal smallint null,         
     FPriceDecimal smallint null,       
     FBillInterID int null,             
     FStatus varchar(30) null,          
     FSuspend varchar(30) null,         
     FPlanQty decimal(28,10) default(0) null,                                  
     FProInQty decimal(28,10) default(0) null,                                 
     FLeaveQty decimal(28,10) default(0) null,                                 
     FQtyDecimal int default(2) null,                                               
     FChildNumber varchar(355) null,                                          
     FChildShortNumber varchar(355) null,                                     
     FChildName varchar(355) null,                                            
     FChildModel varchar(355) null,                                           
     FChildUnitName varchar(355) null,                                        
     FChildNeedQty decimal(28,10) default(0) null,                             
     FChildOutQty decimal(28,10) default(0) null,                              
     FChildDiscardQty decimal(28,10) default(0) null,                          
     FChildWIPQty decimal(28,10) default(0) null,                              
     FUnitNameCu  varchar(355) null,   ---产品常用计量单位                    
     FPlanQtyCu decimal(28,10) default(0) null,  ----产品计划数量(常用)        
     FProInQtyCu decimal(28,10) default(0) null, ----产品入库数量(常用)        
     FLeaveQtyCu decimal(28,10) default(0) null, ----产品剩余数量(常用)        
     FChildUnitNameCu varchar(355) null,  ----物料基本计量单位(常用)          
     FChildNeedQtyCu decimal(28,10) default(0) null, ----物料需求数量(常用)    
     FChildOutQtyCu decimal(28,10) default(0) null,  ----物料已领数量(常用)    
     FChildDiscardQtyCu decimal(28,10) default(0) null,   ----物料报数量(常用) 
     FChildWIPQtyCu decimal(28,10) default(0) null, ----物料在制品量           
     FSumSort smallint not null Default(0),                                   
     FInterID int not null Default(0),                                   
     FTranType int not null Default(88))

-------获得满足条件的生产任务单-----------
----非委外生产
 Insert Into #DATA2(FICMOInterID,FICMONumber,FItemID,FPlanQty,FDeptType,FDeptID,FType,FTypeName,FStatus,FSuspend,FProInQty,FLeaveQty) 
 Select a.FInterID,a.FBillNo,a.FItemID,a.FQty,a.FDeptType,a.FDeptID,a.FID,a.FName,a.FStatus,a.FSuspend,a.FStockQty,a.FLeaveQty 
 From (Select v1.FInterID,v1.FBillNo,v1.FItemID,round(v1.FQty,t1.FQtyDecimal) FQty ,
     0 FDeptType,v1.FWorkShop FDeptID,t5.FID,t5.FName,v1.FStatus,v1.FSuspend,v1.FStockQty,(v1.FQty-v1.FStockQty) as FLeaveQty  
 From ICMO v1,t_ICItem t1,t_DepartMent t2,t_WorkType t3,t_Submessage t5 
 Where v1.FItemID = t1.FItemID and v1.FWorkShop = t2.FItemID 
 and v1.FType = t5.FInterID and t5.FTypeID = 243 and v1.FWorkTypeId=t3.FInterId 
AND convert(datetime,convert(varchar(30),v1.FCheckDate,111)) >=@begindate
AND convert(datetime,convert(varchar(30),v1.FCheckDate,111)) <=@enddate AND (t5.FID = 'LX1' or t5.FID = 'LX2' or t5.FID = 'LX4'  or t5.FID = 'LX6' ) AND 
v1.FStatus IN (1,2,3) And v1.FCancelLation=0  and  v1.FTranType=85 AND V1.FType<>11060 

----委外生产
  Union 
 Select v1.FInterID,v1.FBillNo,v1.FItemID,round(v1.FQty,t1.FQtyDecimal) FQty ,
     1 FDeptType,v1.FSupplyID FDeptID,t5.FID,t5.FName,v1.FStatus,v1.FSuspend,v1.FStockQty,(v1.FQty-v1.FStockQty) as FLeaveQty 
 From ICMO v1,t_ICItem t1,t_Supplier t2,t_WorkType t3,t_Submessage t5 
 Where v1.FItemID = t1.FItemID and v1.FSupplyID= t2.FItemID 
 and v1.FType = t5.FInterID and t5.FTypeID = 243 and v1.FWorkTypeId=t3.FInterId 
AND convert(datetime,convert(varchar(30),v1.FCheckDate,111)) >=@begindate
AND convert(datetime,convert(varchar(30),v1.FCheckDate,111)) <=@enddate AND (t5.FID = 'LX1' or t5.FID = 'LX2' or t5.FID = 'LX4'  or t5.FID = 'LX6' ) AND 
v1.FStatus IN (1,2,3) And v1.FCancelLation=0  and  v1.FTranType=85 AND V1.FType<>11060 

 ) a Order by a.FBillNo 
-------原料计划投料数量、已领数量、报废数量、在制品数量 From PPBOM                                             
Insert Into #TDATA (FDeptID,FDeptType,FICMOInterID,FICMOBillNo,FBillNo,FChildItemID,                                        
          FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FInterID)                                     
Select v1.FDeptID,v1.FDeptType,v1.FICMOInterID,v1.FICMONumber,u1.FBillNo,u2.FItemID,                                      
  round(u2.FQtyMust,t1.FQtyDecimal),                                                                        
  round(u2.FStockQty,t1.FQtyDecimal),                                                                       
  round(u2.FDiscardQty,t1.FQtyDecimal),                                                                     
  round(u2.FWIPQty,t1.FQtyDecimal),u1.FInterID                                                                          
From #DATA2 v1, PPBOM u1,PPBOMEntry u2,t_ICItem t1                                                             
Where u2.FMaterielType=371 and /*只处理普通件*/v1.FICMOInterID = u1.FICMOInterID and u1.FInterID = u2.FInterID 
and u2.FItemID = t1.FItemID  --AND t1.FNumber>='06.07.0045' AND t1.FNumber<='06.07.0045'
--and s2.FCheckDate>=@begindate and s2.FCheckDate<=@enddate

Insert Into #DATA (FDeptID,FDeptType,FICMOInterID,FICMOBillNo,FBillNo,FChildItemID,
          FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FInterID)
select v1.FDeptID,v1.FDeptType,v1.FICMOInterID,v1.FICMOBillNo,v1.FBillNo,v1.FChildItemID,v1.FChildNeedQty,v1.FChildOutQty,v1.FChildDiscardQty,v1.FChildWIPQty,v1.FInterID 
FROM #TDATA v1
LEFT JOIN ICStockBillEntry s1 ON s1.FICMOInterID=v1.FICMOInterID
LEFT JOIN ICStockBill s2 on s2.FInterID = s1.FInterID AND s1.FInterID <>0 
WHERE 1=1
and s2.FCheckDate>=@begindate and s2.FCheckDate<=@enddate

--------刷新产品数量                                                                                           
UPDATE T1 SET T1.FItemID=T2.FItemID,T1.FPlanQty=T2.FPlanQty,T1.FProInQty=T2.FProInQty,T1.FLeaveQty=T2.FLeaveQty
FROM #DATA T1,#DATA2 T2                                                                                        
WHERE T1.FICMOInterID=T2.FICMOInterID                                                                   
                                                                                                               
select min(FChildItemID) FChildItemID ,FICMOInterID into #Repdata from #data where FSumSort=0                  
    group by FICMOInterID having count(*)>1                                                                    
                                                                                                               
update t1 set FPlanQty=0,FLeaveQty=0,FProInQty=0 from #data t1,#Repdata t2                                     
    where t1.FICMOInterID=t2.FICMOInterID and t1.FChildItemID>t2.FChildItemID                                  

------按车间+任务单汇总----
--任务单小计
INSERT INTO #DATA(FDeptType,FDeptID,FICMOInterID,FItemID,FPlanQty,FProInQty,FLeaveQty,               
  FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FSumSort)                     
SELECT FDeptType,FDeptID,FICMOInterID,FItemID,SUM(FPlanQty), SUM(FProInQty),SUM(FLeaveQty),          
  SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty),101       
FROM #DATA                                                                                   
GROUP BY FDeptType,FDeptID,FICMOInterID,FItemID                                                      
UPDATE T1 SET T1.FICMOBillNo=T2.FBillNo FROM #DATA T1,ICMO T2 WHERE T1.FICMOInterID = T2.FInterID
--车间小计
INSERT INTO #DATA(FDeptType,FDeptID,FPlanQty,FProInQty,FLeaveQty,                            
  FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FSumSort)                     
SELECT FDeptType,FDeptID,SUM(FPlanQty),SUM(FProInQty),SUM(FLeaveQty),                        
  SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty),110       
FROM #DATA                                                                                   
WHERE FSumSort=101                                                                           
GROUP BY FDeptType,FDeptID                                                                   
--总计
INSERT INTO #DATA(FDeptType,FPlanQty,FProInQty,FLeaveQty,                                    
  FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FSumSort)                     
SELECT 2,SUM(FPlanQty),SUM(FProInQty),SUM(FLeaveQty),                                        
  SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty),100       
FROM #DATA                                                                                   
WHERE FSumSort=110                                                                           

------------------按车间汇总                                                                                   
INSERT INTO #DATA(FRow,FDeptType,FDeptID,FChilDItemID,FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty)          
SELECT 1 FRow,FDeptType,FDeptID,FChildItemID,SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty)
FROM #DATA WHERE FSumSort=0 GROUP BY FDeptType,FDeptID,FChildItemID                                                      
                                                                                                               
INSERT INTO #DATA(FRow,FDeptType,FDeptID,FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FSumSort)    
SELECT 1,FDeptType,FDeptID,SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty),110    
FROM #DATA                                                                                                     
WHERE FRow=1 AND FSumSort=0                                                                                    
GROUP BY FDeptType,FDeptID                                                                                     
                                                                                                               
INSERT INTO #DATA(FRow,FDeptType,FChildNeedQty,FChildOutQty,FChildDiscardQty,FChildWIPQty,FSumSort)            
SELECT 1,2,SUM(FChildNeedQty),SUM(FChildOutQty),SUM(FChildDiscardQty),SUM(FChildWIPQty),100                    
FROM #DATA                                                                                                     
WHERE FRow=1 AND FSumSort=110                                                                                  
 Update u1 set u1.FDeptName = isnull(u2.FName,'(其他生产车间)'),u1.FDeptNumber=u2.FNumber                              
 from #DATA u1 Left Join t_DepartMent u2 on u1.FDeptID = u2.FItemID                                                             
 where u1.FDeptType = 0                                        
 Update u1 set u1.FDeptName =  isnull(u2.FName ,'(其他外协单位)'),u1.FDeptNumber=u2.FNumber                            
 from #DATA u1 Left join t_Supplier u2 on u1.FDeptID = u2.FItemID                                                               
 where u1.FDeptType = 1                                        
                                                                                            
 --Update #DATA set FDeptName = RTRIM(substring(FDeptName,4,255))                           
                                                                                            
 Update #DATA Set FDeptName = '总计' where FSumSort=100                                     
 Update #DATA Set FICMOBillNo = FICMOBillNo +'(小计)' Where FSumSort = 101                          
 Update #DATA Set FDeptName = FDeptName +'(小计)' Where FSumSort = 110                      
                                                                                            
 delete from #data where FChildItemId is null and FSumSort=0                                
                                                                                            
 Update v1 set v1.FItemId=u1.FItemId ,                                                      
     v1.FBillInterID = u1.FICMOInterID,v1.FPlanQty = u1.FPlanQty,                           
     v1.FProInQty = u1.FProInQty,v1.FLeaveQty = u1.FLeaveQty,                               
     v1.FStatus = (case u1.FStatus when 0 then '计划' when 3 then '结案' else '下达' end ), 
     v1.FSuspend = (case u1.Fsuspend when 1 then '挂起' else '未挂起' end )                 
 From #DATA v1,#DATA2 u1                                                                    
 Where v1.FICMOBillNo = u1.FICMONumber                                                          
 Update v1 set v1.FPosPlace = t2.FMachinepos                                           
 From #DATA v1,PPBom t1,PPBomEntry t2                                                       
 Where v1.FBillInterID = t1.FICMOInterID                                                    
     and t2.FInterID = t1.FInterID                                                          
 ---------产品基本信息                                                                             
 UPDATE t1 SET t1.FNumber=t2.FNumber,t1.FName=t2.FName,t1.FShortNumber=t2.FShortNumber,            
    t1.FModel=isnull(t2.FModel,''),t1.FProQtyDecimal=t2.FQtyDecimal,t1.FPriceDecimal=t2.FPriceDecimal,
    t1.FUnitName=t3.FName                                                                          
 FROM #DATA t1,t_ICItem t2,t_MeasureUnit t3                                                        
 WHERE t1.FItemId=t2.FItemId                                                                       
    AND t2.FUnitGroupID=t3.FUnitGroupID and t2.FUnitId=t3.FMeasureUnitId                           
---产品常用数据                                                                    
 UPDATE t1 SET t1.FUnitNameCu=t3.FName,                                            
    t1.FPlanQtyCu=round(t1.FPlanQty / isnull(t3.FCoefficient,1),t1.FProQtyDecimal),   
    t1.FProInQtyCu=round(t1.FProInQty / isnull(t3.FCoefficient,1),t1.FProQtyDecimal), 
    t1.FLeaveQtyCu=round(t1.FLeaveQty / isnull(t3.FCoefficient,1),t1.FProQtyDecimal)  
 FROM #DATA t1,t_ICItem t2,t_MeasureUnit t3  WHERE t1.FNumber=t2.FNumber           
    AND t2.FUnitGroupID=t3.FUnitGroupID  and t3.FCoefficient<>0                    
    and t2.FProductUnitID=t3.FMeasureUnitId                                             

---------物料基本数据                                                              
 Update v1 set                                                                     
     v1.FChildNumber=tt1.FNumber,                                                  
     v1.FChildShortNumber = tt1.FShortNumber,                                      
     v1.FChildName = tt1.FName, v1.FChildModel = tt1.FModel,                       
     v1.FChildUnitName = tt2.FName,                                                
     v1.FQtyDecimal=tt1.FQtyDecimal                                           
 From #DATA v1,t_ICItem tt1,t_MeasureUnit tt2                                      
 Where                                                                             
     v1.FChildItemID = tt1.FItemID                                                 
     and tt1.FUnitGroupID=tt2.FUnitGroupID and tt1.fUnitId=tt2.FMeasureUnitId      


 update #data set FChildNeedQty=round(FChildNeedQty,FQtyDecimal), 
    FChildOutQty=round(FChildOutQty,FQtyDecimal), 
    FChildDiscardQty=round(FChildDiscardQty,FQtyDecimal), 
    FChildWIPQty=round(FChildWIPQty,FQtyDecimal), 
    FPlanQty=round(FPlanQty,FProQtyDecimal), 
    FProInQty=round(FProInQty,FProQtyDecimal), 
    FLeaveQty=round(FLeaveQty,FProQtyDecimal)  where FSumSort=0

----物料常用数据
 Update v1 set  v1.FChildUnitNameCu = tt2.FName, 
    v1.FChildNeedQtyCu=round(v1.FChildNeedQty / isnull(tt2.FCoefficient,1),v1.FQtyDecimal), 
    v1.FChildOutQtyCu=round(v1.FChildOutQty /  isnull(tt2.FCoefficient,1),v1.FQtyDecimal), 
    v1.FChildDiscardQtyCu=round(v1.FChildDiscardQty / isnull(tt2.FCoefficient,1),v1.FQtyDecimal), 
    v1.FChildWIPQtyCu=round(v1.FChildWIPQty / isnull(tt2.FCoefficient,1),v1.FQtyDecimal) 
 From #DATA v1,t_ICItem t1, t_MeasureUnit tt2 
 where v1.FChildNumber = t1.FNumber 
    and t1.FUnitGroupID=tt2.FUnitGroupID  
    and t1.FProductUnitID=tt2.FMeasureUnitId  and  tt2.FCoefficient<>0


------刷新产品车间小计和总计常用数据---------
UPDATE T1 SET T1.FPlanQtyCu=T2.FPlanQtyCu,T1.FProInQtyCu=T2.FProInQtyCu,                        
              T1.FLeaveQtyCu=T2.FLeaveQtyCu                   
FROM #DATA T1,(SELECT FDeptID,SUM(FPlanQtyCu) FPlanQtyCu,SUM(FProInQtyCu) FProInQtyCu,     
                              SUM(FLeaveQtyCu) FLeaveQtyCu
               FROM #DATA WHERE FSumSort=101 GROUP BY FDeptID) T2                                            
Where T1.FDeptID = T2.FDeptID And T1.FSumSort = 110                                                   
UPDATE T1 SET T1.FPlanQtyCu=T2.FPlanQtyCu,T1.FProInQtyCu=T2.FProInQtyCu,                        
              T1.FLeaveQtyCu=T2.FLeaveQtyCu   
FROM #DATA T1,(SELECT FRow,SUM(FPlanQtyCu) FPlanQtyCu,SUM(FProInQtyCu) FProInQtyCu,             
                           SUM(FLeaveQtyCu) FLeaveQtyCu  
               FROM #DATA WHERE FSumSort=110 GROUP BY FRow) T2                                                  
Where T1.FRow=T2.FRow AND T1.FSumSort = 100     
------刷新子项物料的小计和总计常用数据---------
UPDATE T1 SET T1.FChildNeedQtyCu=T2.FChildNeedQtyCu,T1.FChildOutQtyCu=T2.FChildOutQtyCu,                        
              T1.FChildDiscardQtyCu=T2.FChildDiscardQtyCu,T1.FChildWIPQtyCu=T2.FChildWIPQtyCu                   
FROM #DATA T1,(SELECT FICMOInterID,SUM(FChildNeedQtyCu) FChildNeedQtyCu,SUM(FChildOutQtyCu) FChildOutQtyCu,     
                                   SUM(FChildDiscardQtyCu) FChildDiscardQtyCu,SUM(FChildWIPQtyCu) FChildWIPQtyCu
               FROM #DATA WHERE FSumSort=0 GROUP BY FICMOInterID) T2                                            
Where T1.FICMOInterID = T2.FICMOInterID And T1.FSumSort = 101                                                   
UPDATE T1 SET T1.FChildNeedQtyCu=T2.FChildNeedQtyCu,T1.FChildOutQtyCu=T2.FChildOutQtyCu,                        
              T1.FChildDiscardQtyCu=T2.FChildDiscardQtyCu,T1.FChildWIPQtyCu=T2.FChildWIPQtyCu                   
FROM #DATA T1,(SELECT FDeptID,SUM(FChildNeedQtyCu) FChildNeedQtyCu,SUM(FChildOutQtyCu) FChildOutQtyCu,          
                              SUM(FChildDiscardQtyCu) FChildDiscardQtyCu,SUM(FChildWIPQtyCu) FChildWIPQtyCu     
               FROM #DATA WHERE FSumSort=101 GROUP BY FDeptID) T2                                               
Where T1.FDeptID = T2.FDeptID And T1.FSumSort = 110                                                             
UPDATE T1 SET T1.FChildNeedQtyCu=T2.FChildNeedQtyCu,T1.FChildOutQtyCu=T2.FChildOutQtyCu,                        
              T1.FChildDiscardQtyCu=T2.FChildDiscardQtyCu,T1.FChildWIPQtyCu=T2.FChildWIPQtyCu                   
FROM #DATA T1,(SELECT FRow,SUM(FChildNeedQtyCu) FChildNeedQtyCu,SUM(FChildOutQtyCu) FChildOutQtyCu,             
                           SUM(FChildDiscardQtyCu) FChildDiscardQtyCu,SUM(FChildWIPQtyCu) FChildWIPQtyCu        
               FROM #DATA WHERE FSumSort=110 GROUP BY FRow) T2                                                  
Where T1.FRow=T2.FRow AND T1.FSumSort = 100                                                                     
-------去除小计中的产品信息----
update t1 set /*FPlanQty=0,FLeaveQty=0,FProInQty=0,*/FItemID=NULL,FNumber=NULL,FShortNumber=NULL,
              FName=NULL,FModel=NULL,FUnitName=NUll,FUnitNameCu=Null  from #data t1,#Repdata t2
Where t1.FICMOInterID = t2.FICMOInterID And t1.FChildItemID IS NULL

UPDATE t1 SET t1.FQtyDecimal=(case when t2.fqtydecimal>t3.fqtydecimal then t2.fqtydecimal else t3.fqtydecimal end)
from #DATA t1,t_icitembase t2,t_icitembase t3 where t1.fitemid=t2.fitemid and t1.fchilditemid=t3.fitemid and t1.FSumSort=0 

------合计项数量进度取物料数量精度最大值----
UPDATE #DATA SET FQtyDecimal=(SELECT MAX(FQtyDecimal) FROM #DATA) WHERE FSumSort<>0

--SELECT * FROM #DATA WHERE FRow=1 order by FDeptType,FDeptName                   
Drop Table #DATA2                                                     
drop table #RepData                                                   
--drop table #RepData2                                                   

Insert Into #temp(wldm,wlmc,wlgg,jldw,qichu,touru,xiaohao,qimo
)
SELECT i.FNumber,i.FName,i.FModel,mu.FName,isnull(sc.qichu,0) as qichu,isnull(b.FChildOutQty,0) as touru,isnull(b.FChildOutQty,0)-isnull(b.FChildWIPQty,0) as xiaohao,isnull(sc.qichu,0)+isnull(b.FChildOutQty,0)-(isnull(b.FChildOutQty,0)-isnull(b.FChildWIPQty,0)) as qimo FROM t_ICItem i
LEFT JOIN t_MeasureUnit mu on mu.FItemID=i.FUnitID 
LEFT JOIN rss.dbo.sc_report sc on i.FNumber=sc.wldm
/*LEFT JOIN (
select u1.FItemID,sum(FQty) as FQty from ICStockBill v1 
inner join ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
group by u1.FItemID
) a on a.FItemID=i.FItemID*/
LEFT JOIN #DATA b on i.FItemID=b.FChildItemID and b.FRow=1
where 1=1
AND (qichu<>0 /*or a.FQty<>0*/ or b.FChildOutQty<>0 or (isnull(b.FChildOutQty,0)-isnull(b.FChildWIPQty,0))<>0)
AND (i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%')

DROP TABLE #DATA

if @orderby='null'
exec('Insert Into #DATA100(wldm,wlmc,wlgg,jldw,qichu,touru,xiaohao,qimo)select * from #temp')
else
exec('Insert Into #DATA100(wldm,wlmc,wlgg,jldw,qichu,touru,xiaohao,qimo)select * from #temp order by '+ @orderby+' '+ @ordertype)

select count(*) from #DATA100
end


execute report_sczzp '','2013-01-01','2013-01-31','null','null'

execute report_sczzp_count '','2012-01-01','2012-01-31','null','null'



select * from rss.dbo.sc_report

