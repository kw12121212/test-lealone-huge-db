import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.Random;
import java.util.UUID;

/**
 * Generates one random CSV row matching the benchmark table schema (excluding auto-increment id).
 * Fields: field_int, field_long, field_money, field_score, field_name, field_code, field_flag, field_ts, field_uuid
 */
public class RowGenerator {

    private static final long TS_START = LocalDateTime.of(2020, 1, 1, 0, 0)
            .toEpochSecond(ZoneOffset.UTC);
    private static final long TS_END = LocalDateTime.of(2026, 12, 31, 23, 59, 59)
            .toEpochSecond(ZoneOffset.UTC);
    private static final long TS_RANGE = TS_END - TS_START;

    private static final char[] ALPHANUMERIC =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".toCharArray();
    private static final char[] UPPER_ALPHANUMERIC =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toCharArray();

    private static final DateTimeFormatter TS_FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final Random random;

    public RowGenerator(long seed) {
        this.random = new Random(seed);
    }

    public String generateRow() {
        StringBuilder sb = new StringBuilder(256);
        sb.append(random.nextInt());                          // field_int
        sb.append(',');
        sb.append(random.nextLong());                        // field_long
        sb.append(',');
        sb.append(randomMoney());                            // field_money
        sb.append(',');
        sb.append(randomScore());                            // field_score
        sb.append(',');
        appendRandomAlpha(sb, random.nextInt(32) + 1);       // field_name (1-32 chars, mostly short)
        sb.append(',');
        appendRandomUpperAlpha(sb, 20);                      // field_code (exactly 20 chars)
        sb.append(',');
        sb.append(random.nextBoolean());                     // field_flag
        sb.append(',');
        sb.append(randomTimestamp());                        // field_ts
        sb.append(',');
        sb.append(UUID.randomUUID());                        // field_uuid
        return sb.toString();
    }

    private String randomMoney() {
        long unscaled = (long) (random.nextDouble() * 100_0000_0000L);
        return BigDecimal.valueOf(unscaled, 2)
                .setScale(2, RoundingMode.HALF_UP)
                .toPlainString();
    }

    private String randomScore() {
        return String.format("%.6f", random.nextDouble() * 100.0);
    }

    private void appendRandomAlpha(StringBuilder sb, int length) {
        for (int i = 0; i < length; i++) {
            sb.append(ALPHANUMERIC[random.nextInt(ALPHANUMERIC.length)]);
        }
    }

    private void appendRandomUpperAlpha(StringBuilder sb, int length) {
        for (int i = 0; i < length; i++) {
            sb.append(UPPER_ALPHANUMERIC[random.nextInt(UPPER_ALPHANUMERIC.length)]);
        }
    }

    private String randomTimestamp() {
        long epochSeconds = TS_START + (long) (random.nextDouble() * TS_RANGE);
        return Instant.ofEpochSecond(epochSeconds)
                .atOffset(ZoneOffset.UTC)
                .toLocalDateTime()
                .format(TS_FORMATTER);
    }
}
