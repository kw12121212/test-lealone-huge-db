# Questions: deploy-and-smoke-test

## Open

## Resolved

- [x] Q: Is JAVA_HOME set in the current environment, or should the scripts detect/configure it?
  Context: The startup script and smoke test both require JAVA_HOME to find the Java binary.
  A: JAVA_HOME is set (`/home/wx766/.sdkman/candidates/java/current`, OpenJDK 25.0.2). No detection logic needed.

- [x] Q: Should the smoke test script start the cluster itself, or assume it is already running?
  Context: Determines whether the smoke test is standalone or depends on a separate cluster startup step. Recommendation: assume already running.
  A: Assume already running. Smoke test only tests SQL, cluster lifecycle managed by separate scripts.
