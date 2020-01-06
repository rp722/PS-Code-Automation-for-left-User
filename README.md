# PS-Code-Automation-for-left-User

powershell来针对离职的自动化执行。
结合mssql数据库的目的是更自动化，并保存一些用户信息到数据库中
powershell代码建议在AD中可手动执行，也可计划任务执行


数据库（以下我所用的方法，不能直接套用）
主要3张表
员工表Userlist记录员工在离职状态，加触发器，当是否离职状态改变自动加入离职员工表leftuser中
离职员工表leftuser结构如下，前提有工号和ad账号的对应关系表
离职用户所在组表leftusergroup，记录离职用户之前所在的组。


