# lupydev/homebrew-tap

Homebrew formulae for [lupydev](https://github.com/lupydev) projects.

## Install

```bash
brew tap lupydev/tap
brew install vigil
```

Or in one line:

```bash
brew install lupydev/tap/vigil
```

## Formulae

### vigil

A macOS menu bar watchdog for **work that outlived its purpose** — processes
still consuming a core long after the job that started them ended. Build and
test daemons orphaned by a cancelled run, language servers wedged after a crash,
container runtimes left with nothing to run.

It reads the kernel's cumulative CPU accounting instead of sampling, so it
identifies a wedged process from a single reading. It never acts on your
machine, and it writes nothing to your disk.

→ [github.com/lupydev/vigil](https://github.com/lupydev/vigil)

After installing:

```bash
open $(brew --prefix)/opt/vigil/Vigil.app   # menu bar app
vigil --scan                                 # one-off terminal check
```

## Why these build from source

A prebuilt `.app` downloaded from the internet needs Developer ID signing and
Apple notarization to get past Gatekeeper. Without that, macOS refuses to open
it and the user has to dig through System Settings — worse than no packaging at
all, because the install appears to succeed.

Compiling on the installing machine sidesteps the problem entirely: a locally
built binary is never quarantined. Homebrew already requires the Command Line
Tools, which include the Swift toolchain, so this asks for nothing a Homebrew
user does not already have. The cost is about a minute of compilation.

If a project here ever gets signed and notarized builds, a cask will be added
alongside the formula rather than replacing it.
