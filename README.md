# NumBridge Ascent

NumBridge Ascent is a Markdown-led research operating system for finding bridges from symbolic / numerological number intuitions into empirical mathematics and, eventually, Lean-checkable theorems.

It does **not** assume numerology is true. It treats numerology-like language as a hypothesis generator, then forces every claim through formalization, experiment, null models, counterexample search, and proof scaffolding.

> Generate like a mystic. Test like a statistician. Prove like an arithmetician. Record like a scientist.

## What this repo gives you

- A Markdown research brain: `leads.md`, `conjectures.md`, `bridges.md`, `evolution.md`, `failures.md`, `ontology.md`, `ascent.md`, and more.
- A runnable Python CLI with no required third-party packages.
- Built-in arithmetic feature functions: primes, residues, digital roots, digit lists, palindromes, factor signatures, persistence, null models.
- PrimeBridge Resonance Engine for residue shadows, gate deficits, admissibility witnesses, local survival factors, resonance ranking, and empirical prime-pattern counts.
- Wheel-shadow finite-sieve distribution checks and a formal branch-truth taxonomy for interpreted numerology claims.
- Built-in experiments for calibration bridges:
  - digital roots of primes
  - palindromes and divisibility by 11
  - base-invariance of digit-root claims
  - prime-gap digital-root rhythm
  - "7 resists factor collapse"
- A schema validator for Markdown entries.
- A Lean export scaffold for theorem candidates.
- A Codex goal file: `codex_goal.md`, designed to instruct an agent to search for a bridge that is fully solvable in Lean.

## Fast start

```bash
cd numbridge_ascent
python bridge.py index
python bridge.py validate
python bridge.py run-all
python bridge.py seek-lean-bridge
python bridge.py prime-pattern H=0,2,6
python bridge.py wheel-shadow H=0,2,6 W=30
python bridge.py wheel-theorem-check H=0,2,6 primes=2,3,5
python bridge.py rank-resonance --k 4 --diameter 50 --prime-bound 31
python bridge.py report B-0002
```

Run tests:

```bash
python -m unittest discover -s tests
```

Create a new lead:

```bash
python bridge.py add-lead "11 is a mirror gate"
python bridge.py expand L-0005
```

Export a Lean skeleton for a conjecture:

```bash
python bridge.py export-lean C-0002
```

## The core workflow

```text
symbolic phrase
  ↓
lead
  ↓
formal interpretations
  ↓
experiment
  ↓
null-model comparison
  ↓
conjecture
  ↓
counterexample search
  ↓
Lean proof target
  ↓
bridge card
```

## Repository map

```text
README.md                project entrypoint
codex_goal.md            copy/paste goal for Codex or another coding agent
doctrine.md              reasoning rules and anti-self-deception constraints
ascent.md                maturity ladder from symbol to theorem
leads.md                 index of active leads
conjectures.md           index of formal claims
bridges.md               index of reusable bridge translations
bridge-theorems.md       reusable theorem schemas above individual bridges
primebridge.md           PrimeBridge search-engine overview
resonance.md             residue-shadow resonance definitions
formal-truth.md          proof/computation/heuristic label taxonomy
numerology-branches.md   formally true branches under explicit interpretation
evolution.md             how the system changes as it learns
failures.md              failed leads and methodological lessons
ontology.md              symbolic phrase → mathematical candidates
null-models.md           approved comparison models
scoring.md               bridge scoring rubric
interface.md             CLI and human workflow
AGENTS.md                Codex/agent navigation rules
agents.md                human-readable agent role notes
proof-roadmap.md         Lean/proof assistant roadmap
open-questions.md        live research questions

leads/                   individual lead cards
conjectures/             individual conjecture cards
bridge-cards/            polished bridge cards
bridge-theorems/         individual bridge theorem cards
experiments/             experiment specs and narratives
reports/                 generated reports
data/experiment-results/ generated JSON results
src/bridge/              PrimeBridge resonance/search engine
src/numbridge/           Python infrastructure
lean/NumBridge/          Lean theorem skeletons / targets
tests/                   unit tests
```

## Design principle

Markdown is not decoration here. Markdown is the operating memory of the research system.

The code reads Markdown, acts on it, writes results back to Markdown, and produces proof targets. This makes the research traceable, auditable, and steerable by humans and agents.

## What counts as a bridge?

A bridge is a reusable translation from symbolic language into a mathematical structure.

Examples:

```text
digital root       → modular arithmetic modulo b - 1
mirror number      → palindrome / digit reversal / involution
completion root    → residue 0 modulo b - 1
resistance         → primality, low factor count, long orbit, invariant under maps
collapse           → digit iteration, factorization, convergence to fixed point
resonance          → residue-shadow survival / local sieve factor
shadow             → occupied residue classes of an offset pattern
```

A strong bridge becomes one or more of:

- a theorem
- a known structure
- a compact predictor
- a reusable definition
- a Lean-checkable statement
- a generator of new precise conjectures

## Honest current status

This repo now includes closed calibration Lean theorems, a bridge-theorem layer,
and a PrimeBridge Resonance Engine. It does not prove the prime k-tuples
conjecture; it builds a search-enabling bridge from symbolic resonance language
to local residue structure used in sieve heuristics.
