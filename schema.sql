CREATE TABLE IF NOT EXISTS benchmark (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    field_int   INT,
    field_long  BIGINT,
    field_money DECIMAL(10, 2),
    field_score DOUBLE,
    field_name  VARCHAR(255),
    field_code  CHAR(20),
    field_flag  BOOLEAN,
    field_ts    TIMESTAMP,
    field_uuid  UUID
);
