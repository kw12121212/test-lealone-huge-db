import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Writes a subset of rows to a single CSV part file.
 */
public class CsvPartitionWriter implements Runnable {

    private final int partitionIndex;
    private final long rowCount;
    private final Path outputDir;
    private final long baseSeed;

    public CsvPartitionWriter(int partitionIndex, long rowCount, Path outputDir, long baseSeed) {
        this.partitionIndex = partitionIndex;
        this.rowCount = rowCount;
        this.outputDir = outputDir;
        this.baseSeed = baseSeed;
    }

    @Override
    public void run() {
        String filename = String.format("benchmark_part_%02d.csv", partitionIndex);
        Path filePath = outputDir.resolve(filename);
        RowGenerator generator = new RowGenerator(baseSeed + partitionIndex);

        try (BufferedWriter writer = Files.newBufferedWriter(filePath)) {
            for (long i = 0; i < rowCount; i++) {
                writer.write(generator.generateRow());
                writer.newLine();
            }
            System.out.printf("  Partition %02d: %,d rows -> %s%n", partitionIndex, rowCount, filePath.getFileName());
        } catch (IOException e) {
            throw new RuntimeException("Failed to write partition " + partitionIndex, e);
        }
    }
}
