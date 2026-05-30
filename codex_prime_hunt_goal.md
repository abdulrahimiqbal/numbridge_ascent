# Codex Goal: PrimeBridge Hunting Mode

You are working inside the NumBridge Ascent repository.

## Mission

Run this repository in a prime-specific hunting mode. The goal is not to validate numerology. The goal is to find symbolic / numerology-like observations about prime numbers that translate into precise mathematical statements, survive strong null models where relevant, and produce at least one Lean-solvable theorem target.

## First principle

Separate two classes of output:

1. Lean-solvable structural bridges about primes.
2. Empirical prime-distribution leads that are interesting but not yet theorem-ready.

Do not confuse empirical evidence with proof.

## Starting commands

Run:

```bash
python bridge.py validate
python -m unittest discover -s tests
python bridge.py run-all
python bridge.py seek-lean-bridge
```

If Lean/Lake is installed, also run:

```bash
lake update
lake build
```

## Prime-specific hunting target

Start from lead `L-0001` and conjecture `C-0001`:

```text
Symbolic phrase: completion roots vanish from primes.
Formal bridge: digital roots of primes are modular residues modulo 9.
Lean target: prove that a prime p > 3 is not divisible by 3, then connect that to digital-root exclusion.
```

The first Lean theorem to verify is:

```text
For every natural p, if p is prime and p > 3, then not (3 divides p).
```

Then try to extend the bridge toward:

```text
For every prime p > 3, p mod 9 is in {1,2,4,5,7,8}.
```

Only after that, define a digital-root function and prove:

```text
For every prime p > 3, digital_root_10(p) is not 3, 6, or 9.
```

## Required skepticism

For any empirical prime pattern, compare against at least:

- odd integers
- odd nonmultiples of 3
- wheel-sieved candidates when available
- residue-class-matched nulls when the pattern involves digits or residues

If a pattern disappears under these controls, record it as a failure or shallow-real bridge.

## Definition of done

A successful PrimeBridge hunt has:

- Python validation passing.
- Unit tests passing.
- Built-in experiments regenerated.
- At least one prime-related Lean theorem compiling without `sorry` if Lean is available.
- Markdown updated across the path:
  - lead
  - experiment
  - conjecture
  - bridge card
  - bridges index
  - evolution log
- A new or updated report under `reports/` explaining what was found, what failed, and what should be tested next.

## Do not overclaim

The prime/digital-root bridge is likely real but shallow because it reduces to divisibility by 3. That is acceptable as a calibration theorem. The next objective is to search for prime-specific leads that survive stronger null models while remaining formalizable.
