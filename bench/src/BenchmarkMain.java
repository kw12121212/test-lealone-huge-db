import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/**
 * Entry point for the Lealone benchmark tool.
 * Usage: java BenchmarkMain [iterations] [concurrencyLevels] [jdbcUrl]
 * Defaults: 10000  1,10,50,100  jdbc:lealone:tcp://127.0.0.1:9210/lealone
 */
public class BenchmarkMain {

    private static final int WARMUP_PER_WORKER = 50;

    public static void main(String[] args) throws Exception {
        if (args.length > 0 && ("--help".equals(args[0]) || "-h".equals(args[0]))) {
            System.out.println("Usage: java BenchmarkMain [iterations] [concurrencyLevels] [jdbcUrl]");
            System.out.println("  iterations          Per-worker iterations (default: 10000)");
            System.out.println("  concurrencyLevels   Comma-separated thread counts (default: 1,10,50,100)");
            System.out.println("  jdbcUrl             JDBC connection URL (default: jdbc:lealone:tcp://127.0.0.1:9210/lealone)");
            return;
        }

        int iterations = args.length > 0 ? Integer.parseInt(args[0]) : 10000;
        int[] concurrencies = args.length > 1
                ? parseCommaInts(args[1])
                : new int[]{1, 10, 50, 100};
        String jdbcUrl = args.length > 2 ? args[2] : "jdbc:lealone:tcp://127.0.0.1:9210/lealone";

        System.out.println("=== Lealone Benchmark ===");
        System.out.printf("  Iterations:    %,d%n", iterations);
        System.out.printf("  Concurrency:   %s%n", joinInts(concurrencies));
        System.out.printf("  JDBC URL:      %s%n", jdbcUrl);
        System.out.println();

        // Verify connectivity and detect row count
        Properties props = new Properties();
        props.setProperty("user", "root");
        long maxId = 0;
        try (Connection conn = DriverManager.getConnection(jdbcUrl, props)) {
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM benchmark")) {
                rs.next();
                maxId = rs.getLong(1);
            }
            System.out.printf("  Table rows:    %,d%n", maxId);
        } catch (Exception e) {
            System.err.println("ERROR: Cannot connect to cluster: " + e.getMessage());
            System.exit(1);
        }
        if (maxId == 0) {
            System.err.println("ERROR: benchmark table is empty");
            System.exit(1);
        }

        BenchmarkWorker.OpType[] ops = BenchmarkWorker.OpType.values();

        // Print header
        System.out.println("operation\tthreads\tops_sec\tp50_ms\tp95_ms\tp99_ms");

        for (BenchmarkWorker.OpType op : ops) {
            for (int threads : concurrencies) {
                long startMs = System.currentTimeMillis();
                int perWorker = iterations / threads;

                ExecutorService pool = Executors.newFixedThreadPool(threads);
                List<Future<LatencyRecorder>> futures = new ArrayList<>();
                for (int t = 0; t < threads; t++) {
                    futures.add(pool.submit(new BenchmarkWorker(jdbcUrl, op, perWorker, WARMUP_PER_WORKER, maxId)));
                }

                // Merge all worker samples into one recorder
                LatencyRecorder merged = new LatencyRecorder();
                for (Future<LatencyRecorder> f : futures) {
                    merged.merge(f.get());
                }
                pool.shutdown();

                long elapsedMs = System.currentTimeMillis() - startMs;
                int totalOps = threads * perWorker;
                double opsSec = elapsedMs > 0 ? totalOps * 1000.0 / elapsedMs : 0;

                System.out.printf("%s\t%d\t%.0f\t%.2f\t%.2f\t%.2f%n",
                        op.name().toLowerCase(), threads, opsSec,
                        merged.p50(), merged.p95(), merged.p99());
            }
        }

        System.out.println();
        System.out.println("=== Benchmark Complete ===");
    }

    private static int[] parseCommaInts(String s) {
        String[] parts = s.split(",");
        int[] result = new int[parts.length];
        for (int i = 0; i < parts.length; i++) {
            result[i] = Integer.parseInt(parts[i].trim());
        }
        return result;
    }

    private static String joinInts(int[] arr) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < arr.length; i++) {
            if (i > 0) sb.append(",");
            sb.append(arr[i]);
        }
        return sb.toString();
    }
}
