SELECT * FROM ICBatchNoRule a
LEFT JOIN t_ICItem b on a.FItemID=b.FItemID
WHERE a.FSelDefine='13E01'
and b.FNumber in ('07.02.1002'
,'07.02.1004'
,'07.02.1006'
,'07.02.1018'
,'07.02.1019'
,'07.02.1020'
,'07.02.1021'
,'07.02.1022'
,'07.02.1024'
,'07.02.1062'
,'07.02.1063')

update a set a.FSelDefine='13K02' 
FROM ICBatchNoRule a
LEFT JOIN t_ICItem b on a.FItemID=b.FItemID
WHERE a.FSelDefine='13E01'
and b.FNumber in ('07.02.1002'
,'07.02.1004'
,'07.02.1006'
,'07.02.1018'
,'07.02.1019'
,'07.02.1020'
,'07.02.1021'
,'07.02.1022'
,'07.02.1024'
,'07.02.1062'
,'07.02.1063')


update ICBatchNoRule set FSelDefine='13K01' WHERE FSelDefine='13E01'

select b.FNumber,b.FModel,b.FHelpCode,a.* from ICBatchNoRule a 
left join t_ICItem b on a.FItemID=b.FItemID where a.FSelDefine='13e04'


select * from ICBatchNoRule
