# SQL Notes

crm.sql was exported from SuiteCRM version 8 from MariaDB for MS SQL.

It may be necessary to delete the following when running crm.sql for an import into MS SQL Azure

	CREATE INDEX idx_user_name ON users (user_name,is_group,status,last_name(30),dbo.first_name(30),id)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 /* COLLATE= */utf8mb3_general_ci;

TO DO: We'll remove the table drop lines from crm.sql to avoid accidental data loss.