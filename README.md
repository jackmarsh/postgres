# PostgreSQL Binaries

This repository provides a tool to build PostgreSQL binaries from source, and it integrates seamlessly as a plugin for the [Please](https://please.build) build system.

Additionally, pre-built PostgreSQL Binary artifacts are available for download from the GitHub release assets.

## Basic Usage

### Option 1: Use as a Please Plugin

1. **Add the plugin to your project**

   In `plugins/BUILD`:
   ```python
   plugin_repo(
       name = "postgres",
       owner = "jackmarsh",
       revision = "v0.0.2",
   )
   ```

2. **Update your `.plzconfig`**

   Add the following section:
   ```ini
   [Plugin "postgres"]
   Target = //plugins:postgres
   ```

3. **Use the PostgreSQL build rules in your project**

   After setting up the plugin, you can use the `postgres` build rule to include PostgreSQL binaries in your project. Example:
   ```python
   subinclude("///postgres//build_defs:postgres")

   postgres(
       name = "psql",
       version = "17.2",
       visibility = ["PUBLIC"],
   )
   ```

   This will build the specified version of PostgreSQL binaries from source.

---

### Option 2: Use Pre-built Artifacts

If you prefer not to build PostgreSQL from source, you can directly download pre-built binaries from the [GitHub release assets](https://github.com/jackmarsh/postgres/releases).

Example:
```python
remote_file(
    name = "psql",
    url = "https://github.com/jackmarsh/postgres/releases/download/v0.0.2/psql-16.0-linux_x86_64.tar.gz",
    hashes = ["<sha256 hash of the file>"],
)
```

You can find pre-built binaries for supported OS and architecture combinations in the [release page](https://github.com/jackmarsh/postgres/releases).

---

## Features

- **Plugin Integration:** Add PostgreSQL build rules to your Please project with ease.
- **Pre-built Binaries:** Save time by downloading pre-built PostgreSQL binaries.
- **Cross-Platform Support:** Supports multiple operating systems and architectures.

---

## Releases

You can find all available versions and corresponding binaries on the [releases page](https://github.com/jackmarsh/postgres/releases).
