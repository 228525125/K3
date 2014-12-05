--drop procedure report_xsddhztj drop procedure report_xsddhztj_count

create procedure report_xsddhztj 
@query varchar(10),
@begindate varchar(10),
@enddate varchar(10),
@huizong int,
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
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

DECLARE @sqlstring nvarchar(255)

Insert Into #temp(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje
)
select d.FName as 'wldw',c.FNumber as 'cpdm',c.FName as 'cpmc',c.FModel as 'cpgg',c.FHelpCode as 'cpth',e.FName as 'jldw',
b.FQty as 'fssl',
b.FPrice as 'wsdj',
b.FPriceDiscount as 'hsdj',
b.FTaxAmt as 'xxs',
b.FAllAmount as 'hsje'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FStatus>=1
and a.FCancellation=0     --δ���ϵĵ���
and a.FDate>=@begindate and a.FDate<=@enddate 
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
order by d.fName,c.FName,c.FModel

if @huizong=1          -- �������ݣ��ͻ�
set @sqlstring='Insert Into #Data(wldw,fssl,wsdj,hsdj,xxs,hsje)select wldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje) from #temp group by wldw'
else if @huizong=2     -- �������ݣ��ͻ���Ʒ��
set @sqlstring = 'Insert Into #Data(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje)select wldw,cpdm,cpmc,cpgg,cpth,jldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje) from #temp group by wldw,cpdm,cpmc,cpgg,cpth,jldw'

if @orderby='null'
exec(@sqlstring)
else
exec(@sqlstring + ' order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(wldw,fssl,xxs,hsje)
select '�ϼ�',sum(b.FQty) as FQty,SUM(b.FTaxAmt) as FTaxAmt,SUM(b.FAllAmount) as FAllAmount from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FStatus>=1 
and a.FCancellation=0     --δ���ϵĵ���
and a.FDate>=@begindate and a.FDate<=@enddate
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
select * from #Data
end

--------------------count----------------------
create procedure report_xsddhztj_count 
@query varchar(10),
@begindate varchar(10),
@enddate varchar(10),
@huizong int,
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
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

DECLARE @sqlstring nvarchar(255)

Insert Into #temp(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje
)
select d.FName as 'wldw',c.FNumber as 'cpdm',c.FName as 'cpmc',c.FModel as 'cpgg',c.FHelpCode as 'cpth',e.FName as 'jldw',
b.FQty as 'fssl',
b.FPrice as 'wsdj',
b.FPriceDiscount as 'hsdj',
b.FTaxAmt as 'xxs',
b.FAllAmount as 'hsje'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FStatus>=1
and a.FCancellation=0     --δ���ϵĵ���
and a.FDate>=@begindate and a.FDate<=@enddate 
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
order by d.fName,c.FName,c.FModel

if @huizong=1          -- �������ݣ��ͻ�
set @sqlstring='Insert Into #Data(wldw,fssl,wsdj,hsdj,xxs,hsje)select wldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje) from #temp group by wldw'
else if @huizong=2     -- �������ݣ��ͻ���Ʒ��
set @sqlstring = 'Insert Into #Data(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje)select wldw,cpdm,cpmc,cpgg,cpth,jldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje) from #temp group by wldw,cpdm,cpmc,cpgg,cpth,jldw'

if @orderby='null'
exec(@sqlstring)
else
exec(@sqlstring + ' order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(wldw,fssl,xxs,hsje)
select '�ϼ�',sum(b.FQty) as FQty,SUM(b.FTaxAmt) as FTaxAmt,SUM(b.FAllAmount) as FAllAmount from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FStatus>=1 
and a.FCancellation=0     --δ���ϵĵ���
and a.FDate>=@begindate and a.FDate<=@enddate
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
select count(*) from #Data
end


execute report_xsddhztj '������','2011-11-01','2011-11-30',2,'null',''

execute report_xsddhztj_count '������','2011-11-01','2011-11-30',2,'null',''



/*select * from SEOrder where FBillNo='SEORD000105' 
and FClosed=1        --0��δ��ҵ��رգ�1����ҵ��ر�
and FStatus=1        --0�����棻1�����״̬��3���ر�״̬*/


113554.00	1965.81	2300.00	253120.33	1742064.11

