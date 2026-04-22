import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Entry point for the CSV-to-Lealone loader.
 * Usage: java LoaderMain <dataDir> <batchSize> <jdbcUrl>
 * Defaults: data/, 5000, jdbc:lealone:tcp://127.0.0.1:9210/lealone
 */
public class LoaderMain {

    public static void main(String[] args) throws Exception {
        Path dataDir = args.length > 0 ? Path.of(args[0]) : Path.of("data");
        int batchSize = args.length > 1 ? Integer.parseInt(args[1]) : 5000;
        String jdbcUrl = args.length > 2 ? args[2] : "jdbc:lealone:tcp://127.0.0.1:9210/lealone";

        System.out.println("=== Lealone Data Loader ===");
        System.out.printf("  Data dir:  %s%n", dataDir.toAbsolutePath());
        System.out.printf("  Batch size: %,d%n", batchSize);
        System.out.printf("  JDBC URL:  %s%n", jdbcUrl);
        System.out.println();

        List<Path> partitions = discoverPartitions(dataDir);
        if (partitions.isEmpty()) {
            System.out.println("No CSV partition files found. Run the data generator first.");
            return;
        }

        long totalRows = 0;
        long startMs = System.currentTimeMillis();
        int completed = 0;
        int skipped = 0;

        for (int i = 0; i < partitions.size(); i++) {
            Path partition = partitions.get(i);
            String name = partition.getFileName().toString();
            PartitionLoader loader = new PartitionLoader(jdbcUrl, partition, batchSize);

            if (loader.isCompleted()) {
                System.out.printf("  [%d/%d] %s — SKIPPED (already loaded)%n", i + 1, partitions.size(), name);
                skipped++;
                continue;
            }

            System.out.printf("  [%d/%d] Loading %s ...%n", i + 1, partitions.size(), name);
            long partStart = System.currentTimeMillis();
            long rows = loader.load();
            long partElapsed = System.currentTimeMillis() - partStart;
            totalRows += rows;
            completed++;
            System.out.printf("  [%d/%d] %s — DONE (%,d rows in %,.1fs)%n",
                    i + 1, partitions.size(), name, rows, partElapsed / 1000.0);
        }

        long elapsed = System.currentTimeMillis() - startMs;
        System.out.println();
        System.out.println("=== Load Summary ===");
        System.out.printf("  Partitions loaded:  %d%n", completed);
        System.out.printf("  Partitions skipped: %d%n", skipped);
        System.out.printf("  Total rows loaded:  %,d%n", totalRows);
        System.out.printf("  Elapsed:            %,.1fs%n", elapsed / 1000.0);
        if (elapsed > 0 && totalRows > 0) {
            System.out.printf("  Throughput:         %,d rows/sec%n", totalRows * 1000L / elapsed);
        }
    }

    private static List<Path> discoverPartitions(Path dataDir) throws IOException {
        if (!Files.isDirectory(dataDir)) {
            return List.of();
        }
        List<Path> files = new ArrayList<>();
        try (DirectoryStream<Path> stream = Files.newDirectoryStream(dataDir, "benchmark_part_*.csv")) {
            for (Path p : stream) {
                files.add(p);
            }
        }
        return files.stream().sorted().collect(Collectors.toList());
    }
}
