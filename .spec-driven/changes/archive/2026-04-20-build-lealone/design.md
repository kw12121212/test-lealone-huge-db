# Design: build-lealone

## Approach

Run `mvn install -DskipTests` inside `lealone-source/`. The `-DskipTests` flag matches the project's own `build.bat -i` command. After a successful build, verify that JAR artifacts exist under the local Maven repository or the project's output directories.

## Key Decisions

- **Skip tests during build**: The project's own build script uses `-DskipTests`. Lealone's unit tests require a running database instance, which is not yet available. Tests will be validated during cluster deployment instead.
- **Use `mvn install`**: Installs artifacts to the local Maven repo, making them available for any tools or scripts that need to reference Lealone JARs later.

## Alternatives Considered

- **`mvn package`**: Would produce JARs without installing to the local repo. Rejected because later stages may need to reference Lealone as a Maven dependency.
- **`mvn assembly:assembly`**: Produces a distribution bundle but is heavier. Can be used later if a packaged distribution is needed.
