import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Properties;

/**
 * Loads one CSV partition file into the benchmark table via JDBC batch INSERT.
 * Writes a .done marker file upon successful completion.
 */
public class PartitionLoader {

    private static final String INSERT_SQL =
            "INSERT INTO benchmark (field_int, field_long, field_money, field_score, field_name, field_code, field_flag, field_ts, field_uuid) VALUES (?,?,?,?,?,?,?,?,?)";

    private final String jdbcUrl;
    private final Path csvFile;
    private final int batchSize;

    public PartitionLoader(String jdbcUrl, Path csvFile, int batchSize) {
        this.jdbcUrl = jdbcUrl;
        this.csvFile = csvFile;
        this.batchSize = batchSize;
    }

    /**
     * Returns true if this partition is already marked as completed.
     */
    public boolean isCompleted() {
        return Files.exists(doneMarkerPath());
    }

    /**
     * Loads the CSV partition into the database.
     * @return number of rows inserted
     */
    public long load() throws SQLException, IOException {
        long totalRows = 0;
        String partitionName = csvFile.getFileName().toString();

        Properties props = new Properties();
        props.setProperty("user", "root");
        try (Connection conn = DriverManager.getConnection(jdbcUrl, props);
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL);
             CsvBatchReader reader = new CsvBatchReader(csvFile, batchSize)) {

            conn.setAutoCommit(false);

            List<String[]> batch;
            while (!(batch = reader.readBatch()).isEmpty()) {
                for (String[] row : batch) {
                    bindRow(ps, row);
                    ps.addBatch();
                }
                ps.executeBatch();
                conn.commit();
                totalRows += batch.size();

                if (totalRows % 500_000 < batchSize) {
                    System.out.printf("    %s: %,d rows loaded%n", partitionName, totalRows);
                }
            }
        }

        Files.writeString(doneMarkerPath(), totalRows + "\n");
        return totalRows;
    }

    private void bindRow(PreparedStatement ps, String[] row) throws SQLException {
        ps.setInt(1, Integer.parseInt(row[0]));           // field_int
        ps.setLong(2, Long.parseLong(row[1]));            // field_long
        ps.setBigDecimal(3, new java.math.BigDecimal(row[2])); // field_money
        ps.setDouble(4, Double.parseDouble(row[3]));      // field_score
        ps.setString(5, row[4]);                          // field_name
        ps.setString(6, row[5]);                          // field_code
        ps.setBoolean(7, Boolean.parseBoolean(row[6]));   // field_flag
        ps.setString(8, row[7]);                          // field_ts
        ps.setString(9, row[8]);                          // field_uuid
    }

    private Path doneMarkerPath() {
        String name = csvFile.getFileName().toString();
        String baseName = name.endsWith(".csv") ? name.substring(0, name.length() - 4) : name;
        return csvFile.resolveSibling(baseName + ".done");
    }
}
