import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Collects per-operation latency samples and computes percentiles.
 */
public class LatencyRecorder {

    private final List<Long> samples = Collections.synchronizedList(new ArrayList<>());

    public void record(long nanos) {
        samples.add(nanos);
    }

    public void merge(LatencyRecorder other) {
        samples.addAll(other.samples);
    }

    public int count() {
        return samples.size();
    }

    public double percentile(double pct) {
        if (samples.isEmpty()) return 0.0;
        List<Long> sorted = new ArrayList<>(samples);
        Collections.sort(sorted);
        int idx = (int) Math.ceil(pct / 100.0 * sorted.size()) - 1;
        return sorted.get(Math.max(0, Math.min(idx, sorted.size() - 1))) / 1_000_000.0;
    }

    public double p50() { return percentile(50); }
    public double p95() { return percentile(95); }
    public double p99() { return percentile(99); }
}
