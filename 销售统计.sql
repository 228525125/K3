--drop procedure report_xsddhztj
--drop procedure report_xsddhztj_count

create procedure report_xsddhztj 
@query varchar(10),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
wldw nvarchar(100) default('')          --�ͻ�����
,cpdm nvarchar(20) default('')           --���ϴ���
,cpmc nvarchar(255) default('')           --��������
,cpgg nvarchar(255) default('')           --���
,cpth nvarchar(20) default('')           --ͼ��
,jldw nvarchar(20) default('')           --������λ
,fssl decimal(28,2) default(0)          --��������
,wsdj decimal(28,2) default(0)          --��˰����
,hsdj decimal(28,2) default(0)          --��˰����
,xxs decimal(28,2) default(0)          --˰��
,hsje decimal(28,2) default(0)          --��˰���
)

Insert Into #Data(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje
)
select d.FName as 'wldw',c.FNumber as 'cpdm',c.FName as 'cpmc',c.FModel as 'cpgg',c.FHelpCode as 'cpth',e.FName as 'jldw',
sum(b.FQty) as 'fssl',
MIN(b.FPrice) as 'wsdj',
MIN(b.FPriceDiscount) as 'hsdj',
SUM(b.FTaxAmt) as 'xxs',
SUM(b.FAllAmount) as 'hsje'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FCancellation=0 
and a.FDate>=@begindate and a.FDate<=@enddate 
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
group by d.FName,c.FNumber,c.FName,c.FModel,c.FHelpCode,e.FName 
order by d.fName,c.FName,c.FModel 

Insert Into  #Data(wldw,fssl,xxs,hsje)
select '�ϼ�',sum(b.FQty) as FQty,SUM(b.FTaxAmt) as FTaxAmt,SUM(b.FAllAmount) as FAllAmount from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FCancellation=0 
and a.FDate>=@begindate and a.FDate<=@enddate
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
select * from #Data 
end

--------------------count----------------------
create procedure report_xsddhztj_count 
@query varchar(10),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
wldw nvarchar(100) default('')          --�ͻ�����
,cpdm nvarchar(20) default('')           --���ϴ���
,cpmc nvarchar(255) default('')           --��������
,cpgg nvarchar(255) default('')           --���
,cpth nvarchar(20) default('')           --ͼ��
,jldw nvarchar(20) default('')           --������λ
,fssl decimal(28,2) default(0)          --��������
,wsdj decimal(28,2) default(0)          --��˰����
,hsdj decimal(28,2) default(0)          --��˰����
,xxs decimal(28,2) default(0)          --˰��
,hsje decimal(28,2) default(0)          --��˰���
)

Insert Into #Data(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje
)
select d.FName as 'wldw',c.FNumber as 'cpdm',c.FName as 'cpmc',c.FModel as 'cpgg',c.FHelpCode as 'cpth',e.FName as 'jldw',
sum(b.FQty) as 'fssl',
MIN(b.FPrice) as 'wsdj',
MIN(b.FPriceDiscount) as 'hsdj',
SUM(b.FTaxAmt) as 'xxs',
SUM(b.FAllAmount) as 'hsje'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FCancellation=0 
and a.FDate>=@begindate and a.FDate<=@enddate 
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
group by d.FName,c.FNumber,c.FName,c.FModel,c.FHelpCode,e.FName 
order by d.fName,c.FName,c.FModel 

Insert Into  #Data(wldw,fssl,xxs,hsje)
select '�ϼ�',sum(b.FQty) as FQty,SUM(b.FTaxAmt) as FTaxAmt,SUM(b.FAllAmount) as FAllAmount from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FCancellation=0 
and a.FDate>=@begindate and a.FDate<=@enddate
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
select count(*) from #Data
end


execute report_xsddhztj '�����Ӵ���','2011-05-01','2011-05-31'

execute report_xsddhztj_count '2011-05-01','2011-05-31'





