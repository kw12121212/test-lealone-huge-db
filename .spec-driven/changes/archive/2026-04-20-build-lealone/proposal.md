# build-lealone

## What

Configure the build environment and compile the Lealone database from source using Maven, producing usable binaries/scripts for later cluster deployment.

## Why

Lealone must be built from source before any subsequent work (data generation, cluster deployment, data loading, performance testing) can proceed. The source code is already cloned at `lealone-source/`.

## Scope

- Run `mvn install -DskipTests` in the `lealone-source/` directory to compile Lealone.
- Verify the build completes without errors.
- Confirm that runnable scripts or JAR files are produced in the expected output locations.

## Unchanged Behavior

Behaviors that must not change as a result of this change (leave blank if nothing is at risk):
