
select a.FBatchManager,b.FProChkMde,b.* from t_ICItem a left join t_ICItemQuality b on a.FItemID=b.FItemID where FNumber in ('05.08.3001')

-- 1:���ι��� �� 0:�����ι���
update t_ICItem set FBatchManager=1 where FNumber IN ('05.08.3001')





