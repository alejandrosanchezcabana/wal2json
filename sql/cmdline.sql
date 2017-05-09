\set VERBOSITY terse

-- predictability
SET synchronous_commit = on;

SELECT 'init' FROM pg_create_logical_replication_slot('regression_slot', 'wal2json');

SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'nosuchopt', '42');

-- By default don't write in chunks
CREATE TABLE x ();
DROP TABLE x;
SELECT data FROM pg_logical_slot_peek_changes('regression_slot', NULL, NULL, 'include-xids', 'f');
SELECT data FROM pg_logical_slot_get_changes('regression_slot', NULL, NULL, 'include-xids', 'f', 'write-in-chunks', 't');

SELECT 'stop' FROM pg_drop_replication_slot('regression_slot');
