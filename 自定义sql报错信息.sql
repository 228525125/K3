EXEC sp_addmessage 50021, 10, '�������� > �������� - �ͼ�����','us_english',false,replace

EXEC sp_addmessage 50022, 10, '������� > �������� - �������������鱨��������','us_english',false,replace

EXEC sp_dropmessage 50021

RAISERROR (50021,16,1 )

RAISERROR (50022,16,1 )

select * from master..sysmessages where error in (50021,50022)




