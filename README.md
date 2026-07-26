# TartanBank Nightly Toolkit

A small nightly operations toolkit for TartanBank that reads a day's transaction
file, applies each transaction to the correct account, flags suspicious activity,
and produces a dated report. It combines **Bash**
with **Python**.

## Quiz result

My passing run of `quiz.sh` is included as `quiz_result.png`. It shows all
**4 out of 4** answers with my Andrew ID visible in both
the top and bottom banners.

![Quiz Result](https://github.com/Ganza-Kevin-Murinda/msit-tartanbank-toolkit/blob/main/quiz_result.png)

## Which parts are Bash, and which are Python (and why)

The **Bash** scripts handle everything to do with the environment and gluing tools
together: `setup.sh` creates the folder structure, `secure_creds.sh` hashes the
operator passphrase with SHA-256, and `run.sh` orchestrates the whole nightly run —
checking that the input file(`transactions.csv`) exists, building a dated report name, calling the
Python program, and printing a quick summary. Bash is the
right tool here because these are filesystem and command-line tasks, and Bash is
excellent at wiring existing tools together with very little code. The **Python**
program handles the actual banking logic: `bank.py` defines the `Account` and
`Ledger` classes, and `process.py` reads the CSV, applies each transaction, tracks
declined withdrawals, computes the deposit statistics, and writes the report.
Python is the right choice here because this part needs structured, testable logic,
object-oriented design, and arithmetic — things that would be painful and error-prone
to express in Bash.

## The hardest thing this week

By far the hardest part was a Git authentication problem when pushing to GitHub. My
pushes kept failing with `403 ... denied` to a different GitHub account, even though
the repository belonged to me. I checked everything obvious — the remote URL, the
macOS Keychain, and `~/.git-credentials` — and they were all clean, yet Git never
even prompted me for a login. The breakthrough came from inspecting my environment
variables, where I found that my VS Code integrated terminal had set `GIT_ASKPASS`
to VS Code's own askpass helper. That helper was silently supplying the credentials
of the wrong GitHub account I was signed into in VS Code. I fixed it by logging
in to VS Code using the correct account.

## How to run the toolkit from a fresh clone


### 1. Clone the repository and enter it

```bash
git https://github.com/Ganza-Kevin-Murinda/msit-tartanbank-toolkit.git
```

```bash
cd msit-tartanbank-toolkit
```

### 2. Make the scripts executable

```bash
chmod +x setup.sh secure_creds.sh run.sh quiz.sh
```

### 3. Run the full nightly job (creates folders, processes the data, writes a dated report)

```bash
./run.sh
```

### 4. View the generated report (date will match today)

```bash
cat reports/report_$(date +%F).txt
```

The provided `data/transactions.csv` is already included in the repository, so
`./run.sh` works immediately after cloning. The `reports/` folder and the plain
`secrets/credentials.txt` are intentionally excluded via `.gitignore`; only the
hashed `secrets/operator.hash` is committed.

> Note: this toolkit was developed on macOS, so `secure_creds.sh` uses
> `shasum -a 256`. On a Linux system you can use `sha256sum` instead — the resulting
> hash is identical.
