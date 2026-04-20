import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * Entry point for the benchmark data generator.
 * Usage: java GeneratorMain [totalRows] [outputDir] [partitions]
 * Defaults: 70000000 rows, data/, 20 partitions
 */
public class GeneratorMain {

    public static void main(String[] args) throws Exception {
        long totalRows = args.length > 0 ? Long.parseLong(args[0]) : 70_000_000L;
        Path outputDir = args.length > 1 ? Path.of(args[1]) : Path.of("data");
        int partitions = args.length > 2 ? Integer.parseInt(args[2]) : 20;

        Files.createDirectories(outputDir);

        long rowsPerPartition = totalRows / partitions;
        long remainder = totalRows % partitions;

        System.out.printf("Generating %,d rows across %d partitions into %s/%n", totalRows, partitions, outputDir);

        long startMs = System.currentTimeMillis();
        long baseSeed = 42;

        List<Runnable> tasks = new ArrayList<>(partitions);
        for (int i = 0; i < partitions; i++) {
            long rows = rowsPerPartition + (i < remainder ? 1 : 0);
            tasks.add(new CsvPartitionWriter(i, rows, outputDir, baseSeed));
        }

        int cores = Runtime.getRuntime().availableProcessors();
        ExecutorService executor = Executors.newFixedThreadPool(Math.min(cores, partitions));
        tasks.forEach(executor::submit);
        executor.shutdown();
        executor.awaitTermination(1, TimeUnit.HOURS);

        long elapsed = System.currentTimeMillis() - startMs;
        System.out.printf("Done in %,.1f seconds (%,d rows/sec)%n",
                elapsed / 1000.0, elapsed > 0 ? (totalRows * 1000L / elapsed) : totalRows);
    }
}
