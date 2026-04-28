# Local-exec and external data (runner stress scenarios)

Small Terraform module used to exercise how a **runner** handles **`data.external`** and a **`local-exec` provisioner** on `terraform_data`, including **memory and I/O heavy** commands supplied via tfvars.

## What the Terraform does

- **`data.external.test`** runs `bash -c` with the string in `program_for_data_external`. The program must print a single JSON object on stdout (default: `echo '{"result": "test"}'`).
- **`terraform_data.test`** runs **`local-exec`** once when the resource is created, using `command_for_local_exec` (default is a harmless echo-style command).
- **`terraform_data.always_recreated`** sets `triggers_replace = timestamp()` so Terraform **replaces that object every apply**. It has **no provisioner**; use it when you want **steady replace churn** on a lightweight resource (for example load or ordering checks). The **`local-exec` on `terraform_data.test`** still runs only when **`test`** is created; use `terraform apply -replace=...` or similar if you need to re-run that provisioner without changing config.

Defaults are safe; optional **`.tfvars`** under **`main/00_local_exec/`** (from **`base/`**) swap in demanding commands for platform testing.

## Var files (Scalr UI)

Runs are expected from the **Scalr** UI. Paths below are relative to **`base/`** (repo root). Pick one var file on the run when you need a stress profile (or run without a var file for defaults).

| Var file (from `base/`) | Intent (short) |
|-------------------------|----------------|
| `main/00_local_exec/command_warning.tfvars` | Python allocates many moderate chunks and holds them for a bounded time; useful for **high memory warning** style behavior without hanging forever. |
| `main/00_local_exec/command_active_file.tfvars` | Large file on disk plus **mmap** and many threads touching pages for ~30s; stresses **active / touched** memory around a big mapping. |
| `main/00_local_exec/command_inactive_file.tfvars` | Creates a **very large** file under `/tmp` and streams it; stresses **inactive/cached** memory and I/O without the mmap/thread pattern. |
| `main/00_local_exec/command_oom.tfvars` | Heavier allocation pattern then **long sleep**; oriented toward **OOM** or extreme memory pressure scenarios (use only where that is acceptable). |
| `main/00_local_exec/command_sigterm_trap.tfvars` | Runs **`term_trap.sh`**: **`trap`** on **`TERM`** and **`SIGTERM`** (prints `BOOM`), then an endless loop with **1 s** `sleep` and a counter. Same behavior as **`main/force_cancel_apply/script.sh`**. Use when testing **forced cancel** / signal delivery to **`local-exec`**. |
| `main/00_local_exec/program_data_external_sigterm_trap.tfvars` | Sets **`program_for_data_external`** only. Runs **`term_trap_data_external.sh`**: same wait loop as **`term_trap.sh`**, but **`Waiting…` lines go to stderr**; on **`TERM`** / **`SIGTERM`** the trap prints one JSON line on **stdout** (`{"result":"BOOM","reason":"signal"}`) and exits **0** so **`data.external`** can parse it after cancel. **`command_for_local_exec`** stays at default unless you add another var file or UI vars. |

## Memory and I/O (exact numbers)

Values below match the **`command_for_local_exec`** strings in the corresponding var files.

| Var file | Allocations / size | Other parameters |
|----------|-------------------|------------------|
| `main/00_local_exec/command_warning.tfvars` | **20** chunks × **`20 * 1024 * 1024`** bytes (**20 MiB** each) → up to **400 MiB** resident in the Python list | Touch every **4096** bytes per chunk; **0.1** s pause after each chunk; final **`time.sleep(30)`** |
| `main/00_local_exec/command_active_file.tfvars` | **`dd`**: **`bs=1M`**, **`count=497`** → **497 MiB** file `/tmp/active_big` | **60** threads; mmap full file read-only; touch every **4096** bytes per thread region; **`time.sleep(30)`** |
| `main/00_local_exec/command_inactive_file.tfvars` | **`dd`**: **`bs=1M`**, **`count=4000`** → **4000 MiB** file `/tmp/bigfile` | Full read via `cat` to `/dev/null` |
| `main/00_local_exec/command_oom.tfvars` | **26** chunks × **`20 * 1024 * 1024`** bytes (**20 MiB** each) → up to **520 MiB** in the list | Touch every **4096** bytes per chunk; **0.1** s pause after each chunk; then **`while True: time.sleep(3600)`** (holds memory) |
| `main/00_local_exec/command_sigterm_trap.tfvars` | **No** deliberate heap allocation | **1** s sleep per loop iteration; **`trap`** runs on **`TERM`** / **`SIGTERM`** |

**`data.external`** (var file **`main/00_local_exec/program_data_external_sigterm_trap.tfvars`**): **no** extra memory; **1** s sleep per iteration; **`trap`** on **`TERM`** / **`SIGTERM`** emits **`{"result":"BOOM","reason":"signal"}`** on stdout only when the signal is handled.

These commands assume a **Linux-style** runner (`bash`, `python3`, `dd`, `/tmp`). Adjust paths or drop-in equivalents if your environment differs.

Workspace working directory should be the Terraform root (**`main/00_local_exec/`** when the VCS root is **`base/`**) so **`bash term_trap.sh`** and **`bash term_trap_data_external.sh`** resolve next to the config.
