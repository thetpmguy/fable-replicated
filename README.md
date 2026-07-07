# fable-replicated

A behavioral spec that makes any Claude model respond like Claude Fable 5: lead with the answer, right-size the length, prose over heavy formatting, zero sycophancy, candid pushback, calibrated confidence, strict scope discipline.

It ships as a Claude Code skill (`fable-style`) plus four domain playbooks, and doubles as a reference for training or steering models toward the Fable register.

## What's here

```
.claude/skills/fable-style/
├── SKILL.md                 # core behavioral rules, loaded every conversation
└── references/
    ├── coding.md            # writing, editing, debugging, agentic work
    ├── research.md          # facts that change over time, search and sources
    ├── feedback.md          # reviews, critique, strategy
    └── stability.md         # long, emotional, or high-pushback conversations
```

`SKILL.md` holds the always-on core rules. Each reference file is a playbook loaded only when the task enters its domain, so the base prompt stays small.

## How to use it

### As a Claude Code skill

The skill lives in `.claude/skills/`, so any Claude Code session started in this repo discovers it automatically. Discovery is project-scoped: cloning the repo does not touch your `~/.claude`, and the skill is only visible when Claude Code runs from a directory that has it under `.claude/skills/`.

To enable it in every project, install it into your home config with the script below.

**One-liner (no clone needed):**

```bash
curl -fsSL https://raw.githubusercontent.com/thetpmguy/fable-replicated/main/install.sh | sh
```

**From a clone:**

```bash
./install.sh
```

Both copy `fable-style` into `~/.claude/skills/`. To target a single project instead of your home config, set `CLAUDE_SKILLS_DIR`:

```bash
CLAUDE_SKILLS_DIR=/path/to/project/.claude/skills ./install.sh
```

Or copy the folder by hand:

```bash
cp -r .claude/skills/fable-style ~/.claude/skills/
```

The one-liner downloads the repo tarball, so it requires the repo to be public (or otherwise reachable without auth). If the repo is private, clone it and run `./install.sh`, which copies from the local checkout.

Once installed, Claude reads `SKILL.md` when the skill loads and applies the core rules to the rest of the conversation. It pulls in a reference file when the work matches that domain (for example `references/coding.md` before editing code). Discovery makes the skill available; the model still decides when to load it based on the task.

### As a system prompt or steering spec

The rules are model-agnostic. Paste the contents of `SKILL.md` into a system prompt, developer message, or fine-tuning instruction set to push any Claude model toward the Fable register. Add the relevant reference file for domain-specific tasks.

### As a rubric for a training pipeline

To be clear about what this is: a behavioral spec, not training data and not a training pipeline. Loading the skill steers a model at inference time by prompt. It changes the model's output, not its weights, and nothing persists once the skill is unloaded. This repo produces no dataset and trains nothing on its own.

It can still feed a training effort you build separately, as the grading standard rather than the data:

- **Labeling guidance.** The playbooks define voice, answer shape, honesty, epistemics, and scope, with good-versus-bad examples. Hand them to annotators (people or a model) as the rubric for scoring generated outputs.
- **Reward-model / preference criteria.** Use the same rules to define what "better" means when collecting the preference pairs behind an RLHF reward model.

Either way the model only learns the Fable register once you (1) generate outputs, (2) label them against these rules, and (3) run SFT or RLHF on the labels. This repo is step 0, the target definition.

## Verifying it works

`SKILL.md` includes a self-test. After loading the skill, run three probes:

1. Ask a simple factual question and expect a one-sentence answer.
2. Share a plan with an obvious flaw and expect the flaw named before any help.
3. Ask something ambiguous and expect a best-effort answer, one stated assumption, and at most one clarifying question.
