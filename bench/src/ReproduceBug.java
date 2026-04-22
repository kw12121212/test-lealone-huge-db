import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.*;

/**
 * Minimal reproducer for concurrent insert ClassCastException.
 * Usage: java ReproduceBug [threads] [iterations] [jdbcUrl]
 */
public class ReproduceBug {
    public static void main(String[] args) throws Exception {
        int threads = args.length > 0 ? Integer.parseInt(args[0]) : 10;
        int iterations = args.length > 1 ? Integer.parseInt(args[1]) : 200;
        String jdbcUrl = args.length > 2 ? args[2] : "jdbc:lealone:tcp://127.0.0.1:9210/lealone";

        System.out.printf("Reproducing bug: %d threads x %d inserts%n", threads, iterations);

        ExecutorService pool = Executors.newFixedThreadPool(threads);
        List<Future<String>> futures = new ArrayList<>();

        for (int t = 0; t < threads; t++) {
            final int threadId = t;
            futures.add(pool.submit(() -> {
                Properties props = new Properties();
                props.setProperty("user", "root");
                try (Connection conn = DriverManager.getConnection(jdbcUrl, props)) {
                    String sql = "INSERT INTO benchmark (field_int, field_long, field_money, field_score, field_name, field_code, field_flag, field_ts, field_uuid) VALUES (?,?,?,?,?,?,?,?,?)";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        for (int i = 0; i < iterations; i++) {
                            ps.setInt(1, threadId * 100000 + i);
                            ps.setLong(2, threadId * 100000L + i);
                            ps.setBigDecimal(3, java.math.BigDecimal.valueOf(i, 2));
                            ps.setDouble(4, i * 1.1);
                            ps.setString(5, "repro_" + threadId + "_" + i);
                            ps.setString(6, "RC" + String.format("%018d", i));
                            ps.setBoolean(7, true);
                            ps.setString(8, "2026-01-01 00:00:00");
                            ps.setString(9, java.util.UUID.randomUUID().toString());
                            ps.executeUpdate();
                        }
                    }
                    return "thread " + threadId + " OK";
                } catch (Exception e) {
                    return "thread " + threadId + " FAILED: " + e.getMessage();
                }
            }));
        }

        int ok = 0, fail = 0;
        for (Future<String> f : futures) {
            String result = f.get(60, TimeUnit.SECONDS);
            System.out.println("  " + result);
            if (result.contains("OK")) ok++; else fail++;
        }
        pool.shutdown();

        System.out.printf("%nResult: %d OK, %d FAILED%n", ok, fail);
        if (fail > 0) {
            System.out.println("BUG REPRODUCED");
        } else {
            System.out.println("No crash this time");
        }
    }
}
