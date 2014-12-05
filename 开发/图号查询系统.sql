--Í¼ºÅ²éÑ¯
--drop procedure list_thcx drop procedure list_thcx_count

create procedure list_thcx 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
[id] int
,gsth nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,khth nvarchar(255) default('')
,cpcz nvarchar(255) default('')
,sslb nvarchar(255) default('')
,rq nvarchar(20) default('')          
,lc nvarchar(255) default('')
)

create table #Data(
[id] int
,gsth nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,khth nvarchar(255) default('')
,cpcz nvarchar(255) default('')
,sslb nvarchar(255) default('')
,rq nvarchar(20) default('')          
,lc nvarchar(255) default('')
)

Insert Into #temp([id],gsth,cpmc,khth,cpcz,sslb,rq,lc
)
select id,gsth,cpmc,khth,cpcz,sslb,convert(char(10),rq,120),lc from rss.dbo.thcx
where 1=1 
--AND rq>=@begindate AND  rq<=@enddate
AND (gsth like '%'+@query+'%' or cpmc like '%'+@query+'%' or khth like '%'+@query+'%' or cpcz like '%'+@query+'%' or sslb like '%'+@query+'%'
or lc like '%'+@query+'%')
order by gsth

if @orderby='null'
exec('Insert Into #Data([id],gsth,cpmc,khth,cpcz,sslb,rq,lc)select * from #temp')
else
exec('Insert Into #Data([id],gsth,cpmc,khth,cpcz,sslb,rq,lc)select * from #temp order by '+ @orderby +' '+ @ordertype)

select * from #Data
 
end

--count

create procedure list_thcx_count 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
[id] int
,gsth nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,khth nvarchar(255) default('')
,cpcz nvarchar(255) default('')
,sslb nvarchar(255) default('')
,rq nvarchar(20) default('')          
,lc nvarchar(255) default('')
)

Insert Into #temp([id],gsth,cpmc,khth,cpcz,sslb,rq,lc
)
select id,gsth,cpmc,khth,cpcz,sslb,convert(char(10),rq,120),lc from rss.dbo.thcx
where 1=1 
--AND rq>=@begindate AND  rq<=@enddate
AND (gsth like '%'+@query+'%' or cpmc like '%'+@query+'%' or khth like '%'+@query+'%' or cpcz like '%'+@query+'%' or sslb like '%'+@query+'%'
or lc like '%'+@query+'%')
order by rq

select count(id) from #temp
 
end

exec list_thcx 'PB9070EP','2010-01-01','2014-12-31','null',''

exec list_thcx_count '','2011-01-01','2014-12-31','null',''




execute list_thcx 'PB9070EP','2010-02-01','2014-05-15','null','null'

execute list_thcx_count 'PB9070EP','2010-02-01','2014-05-15','null','null'

execute list_thcx 'PB9070EP','2010-02-01','2014-05-15','null','null'

execute list_thcx_count 'PB9070EP','2010-02-01','2014-05-15','null','null'

execute list_thcx 'PB9070EN','2010-02-01','2014-05-15','null','null'


select distinct sslb from rss.dbo.thcx 


select convert(char(10),getdate(),120)



insert rss.dbo.thcx (gsth,cpmc,khth,cpcz,sslb,rq,lc) values ('111','222','333','444','555',convert(char(10),getDate(),120),'666')

select



select id,gsth,cpmc,khth,cpcz,sslb,convert(char(10),rq,120),lc from rss.dbo.thcx
where 1=1 
AND rq>='2012-01-01' AND  rq<='2014-05-015'
AND (gsth like '%PB9070EP%')
--order by gsth
