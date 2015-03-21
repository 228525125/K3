EXEC sp_addmessage 50021, 10, '报废数量 > 领料数量 - 送检数量','us_english',false,replace

EXEC sp_addmessage 50022, 10, '入库数量 > 领料数量 - 报废数量，请检查报废数量！','us_english',false,replace

EXEC sp_dropmessage 50021

RAISERROR (50021,16,1 )

RAISERROR (50022,16,1 )

select * from master..sysmessages where error in (50021,50022)




