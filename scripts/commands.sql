use metrics;

/* Grafana Grant Test 
SELECT table_name FROM information_schema.tables WHERE table_schema = database() ORDER BY table_name
*/

CREATE OR REPLACE TABLE tests_data(
  ID     VARCHAR(255) NOT NULL,
  DATE   TIMESTAMP    NOT NULL,
  RESULT INT          NOT NULL,
  PRIMARY KEY (ID,DATE)
);

INSERT INTO tests_data(id, date, result)
VALUES
 ('wasp-global-1_test_01_001', '2022-02-03 15:00:00', 0)
,('wasp-global-1_test_01_002', '2022-02-03 15:00:00', 0)
,('wasp-global-1_test_01_003', '2022-02-03 15:00:00', 1)
,('wasp-global-1_test_01_001', '2022-02-04 07:00:00', 0)
,('wasp-global-1_test_01_002', '2022-02-04 07:00:00', 1)
,('wasp-global-1_test_01_003', '2022-02-04 07:00:00', 0)
,('wasp-global-1_test_01_004', '2022-02-04 07:00:00', 0)
,('wasp-global-1_test_01_005', '2022-02-04 07:00:00', 0)
,('wasp-global-1_test_01_003', '2022-02-05 15:00:00', 0)
;

COMMIT;
