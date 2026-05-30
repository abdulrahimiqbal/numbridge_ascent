# Interface

## Human workflow

```bash
python bridge.py add-lead "9 is completion"
python bridge.py expand L-0005
python bridge.py run-all
python bridge.py seek-lean-bridge
python bridge.py export-lean C-0002
```

## Commands

```text
index                 show repository counts and top files
validate              validate Markdown frontmatter and links
add-lead CLAIM        create a new lead card
expand ID             add ontology-based interpretations to a lead
run ID                run an experiment by ID
run-all               run every experiment with a registered runner
seek-lean-bridge      rank bridge candidates by Lean tractability
export-lean ID        create/update a Lean skeleton for a conjecture
report ID             print a compact report for a lead/conjecture/bridge/experiment
```

## Agent workflow

An agent should read `codex_goal.md`, then operate by editing Markdown and code while keeping the ledger synchronized.
