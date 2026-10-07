# DxzCode

> Personal AI coding agent — based on [OpenCode](https://github.com/anomalyco/opencode)

**DxzCode** is a personal fork of the open-source AI coding agent OpenCode.
It is maintained independently and is **not affiliated** with the official OpenCode / Anomaly team.

- Official upstream: [github.com/anomalyco/opencode](https://github.com/anomalyco/opencode)
- Official site: [opencode.ai](https://opencode.ai)

---

### What is this?

An AI coding agent that runs in your terminal (and desktop). It can read your repo, edit files, run commands, and work with many LLM providers.

This repository (`dxzdcx26-alt/opencode`) is being rebranded to **DxzCode** for personal use and experimentation.

### Quick start (using upstream installs for now)

Until a full local rebrand + build is complete, you can still install and run the upstream binary:

```bash
# Official install (upstream)
curl -fsSL https://opencode.ai/install | bash

# or
npm i -g opencode-ai@latest
```

After you run the local rebrand script and build, the CLI name will become `dxzcode`.

### Rebrand status

| Item | Status |
|------|--------|
| Repo name target | `dxzcode` |
| Branding / README | Done |
| Package scope `@opencode-ai` → `@dxzcode` | Run script locally |
| CLI binary `opencode` → `dxzcode` | Run script locally |
| Config dir `.opencode` → `.dxzcode` | Run script locally |

### How to finish the full rebrand on your machine

```bash
# Clone this fork
gh repo clone dxzdcx26-alt/opencode
cd opencode

# Download & run the rebrand script
curl -fsSL -o rebrand-to-dxzcode.sh https://raw.githubusercontent.com/dxzdcx26-alt/opencode/dev/rebrand-to-dxzcode.sh
bash rebrand-to-dxzcode.sh

# Then
bun install
bun run typecheck

# Optional: rename the GitHub repo
gh repo rename dxzcode
```

(If the script is not yet in the repo, use the copy provided in the conversation.)

### License

MIT (same as upstream OpenCode)

---

**Not affiliated with OpenCode / Anomaly.**  
Upstream project: [opencode.ai](https://opencode.ai) · [Discord](https://discord.gg/opencode)
