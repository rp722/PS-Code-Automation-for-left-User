################
#Author:rp722
#version:6
################

#配置信息
#sql DBconfig
$Database   = 'DatabaseUserName'
$Server     = '"ipaddress"'
$UserName   = 'sa'
$Password   = 'password'

#创建连接对象
#create a connection
$SqlConn = New-Object System.Data.SqlClient.SqlConnection

#使用账号连接MSSQL
#connect to mssql
$SqlConn.ConnectionString = "Data Source=$Server;Initial Catalog=$Database;user id=$UserName;pwd=$Password"

#打开数据库连接
#open sqlConn
$SqlConn.open()

#查询数据库，获取当前离职用户表中用户数量
#query the left user from sql table
$SqlCmd = $SqlConn.CreateCommand()
$SqlCmd.commandtext = 'select COUNT(aduser) from leftUser'
$num=$SqlCmd.ExecuteScalar()

#遍历用户
#traversal users
for($i=1;$i -le $num;$i++)
{

$SqlCmd = $SqlConn.CreateCommand()
$SqlCmd.commandtext = "select aduser from leftUser where lid=$i"
$user=$SqlCmd.ExecuteScalar()

#获取用户
#get aduser
$aduser=Get-ADUser -Identity $user

#判断用户在AD中是否启用，若已禁用则跳过
#if the user is enabled then go
if ($aduser.enabled -eq $True)
{

#获取用户所在组
#get user's group
$groups=(get-aduser $user -properties memberof).memberof

#遍历各组
#traversal groups
foreach($gp in $groups)
{
#获取组的名称
#get group name
$gp1=$gp.Split(",")[0].Split("=")[1]

#保存用户和组的对应关系到数据库
#save the User‘s history group to sql
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.connection = $SqlConn
$SqlCmd.commandtext = "insert into dbo.leftusergroup(aduser,gname) values('$user','$gp1')"
$SqlCmd.ExecuteNonQuery()

#当前组内移除用户
#remove user from the current group
remove-adgroupmember -Identity $gp -Members $user -Confirm:$false
}

#设置备注
#add a note
set-aduser $aduser -Description "user has left company"

#已至禁用组
#move to disabled ou
Move-ADObject $aduser -TargetPath "OU=Disabled,DC=xxxx,DC=net"

#禁用账户
#disbale the user
Disable-ADAccount $aduser

}
}

#关闭数据库连接
#close the sql conn
$SqlConn.close()
