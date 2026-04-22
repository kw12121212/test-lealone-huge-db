import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;
import java.util.concurrent.Callable;

/**
 * Executes a single benchmark operation type for a fixed number of iterations.
 */
public class BenchmarkWorker implements Callable<LatencyRecorder> {

    enum OpType { POINT_SELECT, RANGE_SELECT, INSERT }

    private final String jdbcUrl;
    private final OpType opType;
    private final int iterations;
    private final int warmup;
    private final Random rng = new Random();

    public BenchmarkWorker(String jdbcUrl, OpType opType, int iterations, int warmup) {
        this.jdbcUrl = jdbcUrl;
        this.opType = opType;
        this.iterations = iterations;
        this.warmup = warmup;
    }

    @Override
    public LatencyRecorder call() throws Exception {
        LatencyRecorder recorder = new LatencyRecorder();
        try (Connection conn = DriverManager.getConnection(jdbcUrl)) {
            switch (opType) {
                case POINT_SELECT -> runPointSelect(conn, recorder);
                case RANGE_SELECT -> runRangeSelect(conn, recorder);
                case INSERT -> runInsert(conn, recorder);
            }
        }
        return recorder;
    }

    private void runPointSelect(Connection conn, LatencyRecorder recorder) throws Exception {
        String sql = "SELECT * FROM benchmark WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < warmup + iterations; i++) {
                long id = Math.abs(rng.nextLong()) % 70_000_000 + 1;
                ps.setLong(1, id);
                long start = System.nanoTime();
                try (ResultSet rs = ps.executeQuery()) {
                    rs.next();
                }
                long elapsed = System.nanoTime() - start;
                if (i >= warmup) recorder.record(elapsed);
            }
        }
    }

    private void runRangeSelect(Connection conn, LatencyRecorder recorder) throws Exception {
        String sql = "SELECT * FROM benchmark WHERE field_int BETWEEN ? AND ? LIMIT 100";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < warmup + iterations; i++) {
                int lo = rng.nextInt(2_000_000_000);
                int hi = lo + rng.nextInt(1000) + 1;
                ps.setInt(1, lo);
                ps.setInt(2, hi);
                long start = System.nanoTime();
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {}
                }
                long elapsed = System.nanoTime() - start;
                if (i >= warmup) recorder.record(elapsed);
            }
        }
    }

    private void runInsert(Connection conn, LatencyRecorder recorder) throws Exception {
        String sql = "INSERT INTO benchmark (field_int, field_long, field_money, field_score, field_name, field_code, field_flag, field_ts, field_uuid) VALUES (?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < warmup + iterations; i++) {
                ps.setInt(1, rng.nextInt());
                ps.setLong(2, rng.nextLong());
                ps.setBigDecimal(3, java.math.BigDecimal.valueOf((long)(rng.nextDouble() * 10000), 2));
                ps.setDouble(4, rng.nextDouble() * 100);
                ps.setString(5, "bench_" + rng.nextInt(1_000_000));
                ps.setString(6, "CD" + String.format("%018d", rng.nextInt(1_000_000)));
                ps.setBoolean(7, rng.nextBoolean());
                ps.setString(8, "2026-01-01 00:00:00");
                ps.setString(9, java.util.UUID.randomUUID().toString());
                long start = System.nanoTime();
                ps.executeUpdate();
                long elapsed = System.nanoTime() - start;
                if (i >= warmup) recorder.record(elapsed);
            }
        }
    }
}
