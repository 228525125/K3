select FDeviceNum,FPersonNum,* from t_WorkCenter where FNumber='015'

select * from t_WorkCenter where FDeviceNum=0 and FPersonNum=0

update t_WorkCenter set FDeviceNum=1,FPersonNum=1 where FDeviceNum=0 and FPersonNum=0



update t_WorkCenter set FDeviceNum=1 where FNumber='017'        --设备数

update t_WorkCenter set FPersonNum=1 where FNumber='017'        --人员数


