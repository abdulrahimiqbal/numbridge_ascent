# Codex Goal: Find a Lean-Solvable Bridge

You are working inside the NumBridge Ascent repository.

## Mission

Find a bridge from symbolic / numerological number language into a precise mathematical theorem that is fully solvable in Lean. The bridge should be simple enough to formalize, nontrivial enough to be meaningful, and well-supported by this repo's experiment/null-model infrastructure.

## Primary objective

Produce at least one Lean file under `lean/NumBridge/` that compiles without `sorry`, proving a bridge theorem. Then update the relevant Markdown files so the full path is traceable:

```text
lead → experiment → conjecture → Lean proof → bridge card → bridges index
```

## Preferred first target

Start with the strongest calibration bridge:

```text
Symbolic phrase: mirror numbers pass through the 11 gate.
Mathematical bridge: even-length base-10 palindromes are divisible by 11.
```

If that proof becomes too heavy because of digit-list infrastructure, switch to the smaller but still valid bridge:

```text
Symbolic phrase: completion roots vanish from primes.
Mathematical bridge: every prime p > 3 is not divisible by 3, so its base-10 digital root is not 3, 6, or 9.
```

## Use the infrastructure

Run:

```bash
python bridge.py validate
python bridge.py run-all
python bridge.py seek-lean-bridge
```

Read:

```text
README.md
doctrine.md
ascent.md
ontology.md
scoring.md
proof-roadmap.md
leads/L-0002-mirror-numbers-and-11.md
conjectures/C-0002-even-palindromes-divisible-by-11.md
bridge-cards/B-0002-mirror-symmetry-to-divisibility.md
```

## Rules

1. Do not merely add documentation. Close the loop with a compiling Lean theorem if Lean is available.
2. Prefer small definitions over broad abstractions.
3. If a theorem is too ambitious, weaken it until it becomes provable while preserving the bridge.
4. Keep the Markdown ledger synchronized with the code and proof state.
5. Never delete failed paths. Move them to `failures.md` or mark them as weakened.
6. Favor bridges with short proof dependencies and strong explanatory value.

## Definition of done

A successful run has:

- `python bridge.py validate` passing.
- Unit tests passing.
- At least one Lean theorem compiling without `sorry` if Lean is installed.
- Relevant Markdown files updated:
  - lead status
  - conjecture status
  - bridge card status
  - `bridges.md`
  - `evolution.md`
- A short report in `reports/lean_bridge_candidates.md` or a new proof report.

## Strong hints

The even-palindrome theorem can be attacked by avoiding a full general digit library at first. You may formalize a narrower theorem about numbers built from a list of digits and its reverse, or even a fixed construction:

```text
value(xs ++ reverse xs) is divisible by 11 in base 10
```

A useful algebraic identity:

```text
10 ≡ -1 mod 11
```

So a base-10 numeral evaluated at 10 is congruent to its alternating digit sum modulo 11. For an even-length palindrome, mirrored terms cancel in the alternating sum.

If needed, prove a simpler bridge first:

```text
For natural a b, the 4-digit mirror number 1000a + 100b + 10b + a is divisible by 11.
```

This still captures the bridge: mirror symmetry creates an 11-divisibility gate.
