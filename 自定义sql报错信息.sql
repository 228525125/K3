EXEC sp_addmessage 50021, 10, '�������� > �������� - �ͼ�����1','us_english',false,replace

EXEC sp_dropmessage 50021

RAISERROR (50021,16,1 )

select * from master..sysmessages where error=50021




