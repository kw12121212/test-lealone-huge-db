import java.io.BufferedReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * Reads a CSV file and returns batches of parsed rows.
 * Each row is a String[] with fields matching the benchmark table columns
 * (excluding auto-increment id).
 */
public class CsvBatchReader implements AutoCloseable {

    private final BufferedReader reader;
    private final int batchSize;

    public CsvBatchReader(Path csvFile, int batchSize) throws IOException {
        this.reader = Files.newBufferedReader(csvFile);
        this.batchSize = batchSize;
    }

    /**
     * Reads up to batchSize rows. Returns empty list at EOF.
     */
    public List<String[]> readBatch() throws IOException {
        List<String[]> batch = new ArrayList<>(batchSize);
        String line;
        while (batch.size() < batchSize && (line = reader.readLine()) != null) {
            if (line.isEmpty()) continue;
            batch.add(line.split(",", -1));
        }
        return batch;
    }

    @Override
    public void close() throws IOException {
        reader.close();
    }
}
