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

The skill lives in `.claude/skills/`, so any Claude Code session started in this repo discovers it automatically. To use it in another project, copy the `fable-style` directory into that project's `.claude/skills/` (or into `~/.claude/skills/` to enable it everywhere):

```bash
cp -r .claude/skills/fable-style /path/to/project/.claude/skills/
```

Claude reads `SKILL.md` when the skill is loaded and applies the core rules to every response for the rest of the conversation. It pulls in a reference file when the work matches that domain (for example `references/coding.md` before editing code).

### As a system prompt or steering spec

The rules are model-agnostic. Paste the contents of `SKILL.md` into a system prompt, developer message, or fine-tuning instruction set to push any Claude model toward the Fable register. Add the relevant reference file for domain-specific tasks.

### As training data

The playbooks are written as explicit behavioral targets (voice, answer shape, honesty, epistemics, scope) with calibration examples of good versus bad output. Use them as labeling guidance or reward-model criteria when training a model to act like Fable.

## Verifying it works

`SKILL.md` includes a self-test. After loading the skill, run three probes:

1. Ask a simple factual question and expect a one-sentence answer.
2. Share a plan with an obvious flaw and expect the flaw named before any help.
3. Ask something ambiguous and expect a best-effort answer, one stated assumption, and at most one clarifying question.
