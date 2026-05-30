# Prime Constellation Sieve-Gate Breakthrough Report - 2026-05-29

## 1. Symbolic Phrase Formalized

"Prime patterns survive only when they avoid total residue collapse."

This was formalized as a sieve/admissibility bridge: if a finite set of offsets
covers every residue class modulo a prime `q`, then every translate of that
pattern contains a multiple of `q`.

## 2. Exact Lean Theorems Proved

Lean file:

```text
lean/NumBridge/PrimeConstellations.lean
```

Closed theorem names:

```text
NumBridge.triplet_mod_three_sieve_gate
NumBridge.prime_triplet_start_eq_three
NumBridge.only_prime_triplet_three_five_seven
NumBridge.residue_cover_translate_hits_multiple
NumBridge.offsets_zero_two_four_cover_mod_three
NumBridge.triplet_offsets_cover_hits_multiple
```

Concrete statement proved:

```text
For every natural number n,
3 ∣ n or 3 ∣ n + 2 or 3 ∣ n + 4.
```

Prime-triplet consequence proved under the repo's lightweight local prime
predicate:

```text
If n, n+2, and n+4 are all prime, then n = 3.
The only such triplet is 3,5,7.
```

General finite-cover schema proved:

```text
If offsets cover all residues modulo q, then every translate hits a multiple of q.
```

There is no `sorry`, `admit`, or `axiom`.

## 3. Why This Matters More Than Digital Roots

The digital-root bridge is true but shallow-real: it mostly says that digit-root
language is modular arithmetic.

BT-0004 is more important because it moves from digit phenomena into prime
constellation structure. The symbolic word "gate" now corresponds to a real
sieve obstruction: local residue coverage blocks an entire prime pattern except
for the exceptional case where the forced multiple is the modulus itself.

This is still elementary, but it is now pointing at admissibility, which is a
central concept in prime-pattern hunting.

## 4. Classification

Useful / prime-structural.

It is not deep yet: the concrete triplet obstruction is classical and small.
But it is a genuine step from numerological gates into sieve theory, and the
finite-cover lemma is reusable.

## 5. Next Admissibility Target

Define a reusable API:

```text
ResidueCover q offsets
Admissible offsets := for every prime q, offsets do not cover all residues mod q
Obstructed offsets := exists prime q, ResidueCover q offsets
```

Then prove:

```text
Obstructed offsets -> every translate contains a member divisible by q.
```

After that, add automated finite checks for small offset sets such as
`[0, 2]`, `[0, 2, 6]`, and `[0, 4, 6]` to separate admissible constellations
from residue-collapsed failures.
