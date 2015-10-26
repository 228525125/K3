--投料单增加物料属性
--DROP TRIGGER IC_PPBOM_WLSX

CREATE TRIGGER IC_PPBOM_WLSX ON PPBOMEntry    
AFTER UPDATE,INSERT
AS
SET NOCOUNT ON
IF EXISTS(select 1 from inserted where FEntrySelfY0262 is null or FEntrySelfY0262='')
BEGIN
	DECLARE @FInterID int
	SELECT @FInterID=FInterID FROM inserted

	UPDATE b set b.FEntrySelfY0262=case when i.FErpClsID=1 then '外购' else '自制' end 
	FROM PPBOM a 
	INNER JOIN PPBOMEntry b ON a.FInterID = b.FInterID AND b.FInterID<>0
	LEFT JOIN t_ICItem i on b.FItemID=i.FItemID
	WHERE a.FInterID=@FInterID
END



select i.FNumber,i.FErpClsID,b.FEntrySelfY0262 from PPBOM a 
INNER JOIN PPBOMEntry b ON a.FInterID = b.FInterID  AND b.FInterID<>0
LEFT JOIN t_ICItem i on b.FItemID=i.FItemID
where a.FBillNo='PBOM042502'
and (b.FEntrySelfY0262 is null or b.FEntrySelfY0262='')


update b set b.FEntrySelfY0262=case when i.FErpClsID=1 then '外购' else '自制' end from PPBOM a 
INNER JOIN PPBOMEntry b ON a.FInterID = b.FInterID  AND b.FInterID<>0
LEFT JOIN t_ICItem i on b.FItemID=i.FItemID
where a.FBillNo='PBOM042484'


1:外购
2：自制

select * from PPBOMEntry