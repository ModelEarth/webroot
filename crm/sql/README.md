# SQL Notes

crm.sql was exported from SuiteCRM version 8 from MariaDB for MS SQL.

It may be necessary to delete the following when running crm.sql for an import into MS SQL Azure

	CREATE INDEX idx_user_name ON users (user_name,is_group,status,last_name(30),dbo.first_name(30),id)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 /* COLLATE= */utf8mb3_general_ci;

TO DO: We'll remove the table drop lines from crm.sql to avoid accidental data loss.


MariaDB SQL EXPORT

1. Login to MariaDB via terminal : mysql -u root -p
2. Export schema in another terminal after successful login :  

		mysqldump -u root -p --no-data CRM > ~/Desktop/schema.sql

3. Go to SQLines Online: https://sqlines.com/online
4. Convert the schema from MySQL to SQL Server

RE: DROP tables in the script 
sql server does not have the command CREATE TABLE IF NOT EXISTS, so we need to figure that out.

