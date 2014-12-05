EXEC sp_addlinkedserver 'local', '', 'SQLOLEDB', '192.168.1.73'

EXEC sp_addlinkedsrvlogin 'local', 'false', null, 'sa', '12369'

create table scrw_gxhb (
id int
,djbh nvarchar(255) default('')
,hgsl decimal(28,2) default(0)
,djlx nvarchar(255) default('')
)

INSERT INTO scrw_gxhb
    SELECT * FROM local.rss.dbo.scrw_gxhb

select * from scrw_gxhb

EXEC sp_dropserver 'local', 'droplogins'



\
