--
-- @(#)create_rel_tables.sql 1.134 2004/11/18
--
--      Copyright (c) 2003-2006 Oracle. All rights reserved.
--      This material is the confidential property of Oracle Corporation
--      or its licensors and may be used, reproduced, stored
--      or transmitted only in accordance with a valid Oracle license
--      or sublicense agreement.
--
-- sql source file to create the rel tables.

--
-- Function to check if a specific table exists or not
-- Returns true if specific table exists
--
CREATE OR REPLACE FUNCTION table_exists (
	i_table_name IN VARCHAR2, 
	io_errmsg IN OUT VARCHAR2)
RETURN BOOLEAN AS
	v_dummy VARCHAR2(1);
BEGIN
	SELECT '*' INTO v_dummy
	FROM user_tables
	WHERE table_name = UPPER(i_table_name);

	RETURN true;
EXCEPTION
	WHEN no_data_found THEN
		RETURN false;
	WHEN others THEN
		io_errmsg := sqlerrm;
		RETURN false;
END table_exists;
/
show error;

--
-- Function to check if a specific column exists in the table or not
-- Returns true if specific column exists
--
CREATE OR REPLACE FUNCTION column_exists (
	i_table_name VARCHAR2, i_column_name IN VARCHAR2,
	io_errmsg IN OUT VARCHAR2 )
RETURN BOOLEAN AS
	v_dummy VARCHAR2(1);
BEGIN
	SELECT '*' INTO v_dummy
	FROM user_tab_columns
	WHERE table_name = UPPER(i_table_name)
	AND column_name = UPPER(i_column_name);

	RETURN true;
EXCEPTION
	WHEN no_data_found THEN
		RETURN false;
	WHEN others THEN
		io_errmsg := sqlerrm;
		RETURN false;
END column_exists;
/
show error;

--
-- Function to check if a specific index exists or not
-- Returns true if specific index exists
--
CREATE OR REPLACE FUNCTION index_exists (i_index_name IN VARCHAR2, io_errmsg IN OUT VARCHAR2)
RETURN BOOLEAN AS
        v_dummy VARCHAR2(1);
BEGIN
        SELECT '*' INTO v_dummy
        FROM user_indexes
        WHERE index_name = UPPER(i_index_name);

        RETURN true;
EXCEPTION
        WHEN no_data_found THEN
                RETURN false;
        WHEN others THEN
                io_errmsg := sqlerrm;
                RETURN false;
END index_exists;
/
show error;

--
-- Procedure to create REL tables 
--
-- rel_update_status_t and rerel_balgrp_item_map_t and index i_d_balgrp_item__id
--
-- If table already exists (e.g. 6.5_SP1 or earlier version), it will 
-- upgrade the table.
-- For rel_update_status_t, add columns
--     session_obj_id0, start_obj_id0, tables, sproc_name, batch_size, 
--     flags, failure_message
-- rename columns
--     poid_id0 -> thread_id
--     num_events_updated -> num_processed
-- remove column
--     last_proc_id0
-- migrate columns
--     event_type -> creation_process (100 -> RATING_PIPELINE, 101 -> RERATING_PIPELINE)
-- For rerel_balgrp_item_map_t, no change
-- 

SET serveroutput on size 1000000

DECLARE
	ORACLE_STD_ERR_OFFSET CONSTANT INT := -20000;
	not_empty EXCEPTION;

	v_ddl_stmt VARCHAR(4000);
	v_errmsg VARCHAR2(200);
	v_count NUMBER := 0;

BEGIN
	-- drop the rerel_acct_item_map_t if it exists
	IF (table_exists('rerel_acct_item_map_t', v_errmsg)) THEN
		v_ddl_stmt := 'drop table rerel_acct_item_map_t';
		EXECUTE IMMEDIATE v_ddl_stmt;
	END IF;

	-- if rel_update_status_t does not exist, create a new table
	IF(NOT table_exists('rel_update_status_t', v_errmsg)) THEN
		v_ddl_stmt := 'CREATE TABLE rel_update_status_t
			(session_obj_id0                    NUMBER(38, 0),
			 thread_id                          NUMBER(38, 0),
			 start_obj_id0                      NUMBER(38, 0),
			 end_obj_id0                        NUMBER(38, 0),
			 num_processed                      INT,
			 sb_num_processed                      INT,
			 status                             INT,
			 creation_process                   VARCHAR2(32),
			 tables                             VARCHAR2(1000),
			 sproc_name                         VARCHAR2(64),
			 batch_size                         INT,
			 flags                              VARCHAR2(1000),
			 failure_message                    VARCHAR2(1000))
			$PIN_CONF_TBLSPACE17 
			$PIN_CONF_STORAGE_SMALL' ;

		EXECUTE IMMEDIATE v_ddl_stmt;

	ELSE 	-- if rel_update_status_t already exists
		--
		-- upgrade from 6.5_SP1 or earlier to 6.5_SP1_EBF or later if needed
		--
		--
		-- first delete data that has UPDATECOMPLETE (100) status
		--
		v_ddl_stmt := 'DELETE FROM rel_update_status_t WHERE status = 100';
		EXECUTE IMMEDIATE v_ddl_stmt;

		--
		-- since new rel_update_status_t is not backward compatible, therefore,
		-- before proceeding, rel_update_status_t should not have any unfinished job
		--
		v_ddl_stmt := 'SELECT count(*) FROM rel_update_status_t';
		EXECUTE IMMEDIATE v_ddl_stmt INTO v_count;
		IF (v_count > 0) THEN
			RAISE not_empty;
		END IF;

		--
		-- Create new columns 
		--

		-- add sessio_obj_id0 if not exists
		IF (NOT column_exists('rel_update_status_t', 'session_obj_id0', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t ADD (session_obj_id0 NUMBER(38, 0))';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;

		-- add thread_id if not exists
		IF (NOT column_exists('rel_update_status_t', 'thread_id', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t ADD (thread_id NUMBER(38, 0))';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;
		
		-- add start_obj_id0 if not exists
		IF (NOT column_exists('rel_update_status_t', 'start_obj_id0', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t ADD (start_obj_id0 NUMBER(38, 0))';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;
		
		-- add num_processed if not exists
		IF (NOT column_exists('rel_update_status_t', 'num_processed', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t ADD (num_processed INT)';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;
		
		-- add sb_num_processed if not exists
		IF (NOT column_exists('rel_update_status_t', 'sb_num_processed', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t ADD (sb_num_processed INT)';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;
		
		-- add creation_process if not exists
		IF (NOT column_exists('rel_update_status_t', 'creation_process', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t ADD (creation_process VARCHAR2(32))';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;
		
		-- add tables if not exists
		IF (NOT column_exists('rel_update_status_t', 'tables', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t ADD (tables VARCHAR2(1000))';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;
		
		-- add sproc_name if not exists
		IF (NOT column_exists('rel_update_status_t', 'sproc_name', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t ADD (sproc_name VARCHAR2(64))';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;
		
		-- add batch_size if not exists
		IF (NOT column_exists('rel_update_status_t', 'batch_size', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t ADD (batch_size INT)';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;
		
		-- add flags if not exists
		IF (NOT column_exists('rel_update_status_t', 'flags', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t ADD (flags VARCHAR2(1000))';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;
		
		-- add failure_message if not exists
		IF (NOT column_exists('rel_update_status_t', 'failure_message', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t ADD (failure_message VARCHAR2(1000))';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;		

		--
		-- Delete old columns if exists
		--

		-- drop poid_id0 if exists
		IF (column_exists('rel_update_status_t', 'poid_id0', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t DROP COLUMN poid_id0';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;

		-- drop last_proc_id0 if exists
		IF (column_exists('rel_update_status_t', 'last_proc_id0', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t DROP COLUMN last_proc_id0';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;

		-- drop num_events_updated if exists
		IF (column_exists('rel_update_status_t', 'num_events_updated', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t DROP COLUMN num_events_updated';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;
		
		-- drop event_type if exists
		IF (column_exists('rel_update_status_t', 'event_type', v_errmsg)) THEN
			v_ddl_stmt := 'ALTER TABLE rel_update_status_t DROP COLUMN event_type';
			EXECUTE IMMEDIATE v_ddl_stmt;
		END IF;
	END IF;


	-- add i_rel_upd_status__sess_thread if not exists

	IF (NOT index_exists('i_rel_upd_status__sess_thread', v_errmsg)) THEN

		v_ddl_stmt := 'CREATE UNIQUE INDEX i_rel_upd_status__sess_thread 
				ON rel_update_status_t ( session_obj_id0, thread_id )
				$PIN_CONF_TBLSPACEX17
				$PIN_CONF_STORAGE_SMALL' ;

		EXECUTE IMMEDIATE v_ddl_stmt;
	END IF;

	-- if rerel_balgrp_item_map_t deos not exist, create both table and index

	IF(NOT table_exists('rerel_balgrp_item_map_t', v_errmsg)) THEN
		v_ddl_stmt := 'CREATE TABLE rerel_balgrp_item_map_t
			(session_obj_id0                    NUMBER(38, 0),
			 bal_grp_obj_id0                    NUMBER(38, 0),
			 item_obj_id0                       NUMBER(38, 0))
			$PIN_CONF_TBLSPACE17 
			$PIN_CONF_STORAGE_SMALL' ;

		EXECUTE IMMEDIATE v_ddl_stmt;
	END IF;

	IF (NOT index_exists('i_d_balgrp_item__id', v_errmsg)) THEN
		v_ddl_stmt := 'CREATE UNIQUE INDEX i_d_balgrp_item__id 
				ON rerel_balgrp_item_map_t ( bal_grp_obj_id0, session_obj_id0 )
				$PIN_CONF_TBLSPACEX17 
				$PIN_CONF_STORAGE_SMALL' ;

		EXECUTE IMMEDIATE v_ddl_stmt;
	END IF;

	COMMIT;

EXCEPTION
	WHEN not_empty THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR (ORACLE_STD_ERR_OFFSET,
					'Table has unfinished job(s), ' ||
					'please run "pin_rel -update" to complete all job(s) ' ||
					'before upgrade.',
					TRUE);
	WHEN others THEN
		ROLLBACK;
		dbms_output.put_line(sqlerrm);
		RAISE_APPLICATION_ERROR (ORACLE_STD_ERR_OFFSET,
					'Error while executing ' || v_ddl_stmt,
					TRUE);
END;
/

