# Bridge Theorem Leap Report - 2026-05-29

## Summary

The repo now has a Bridge Theorem layer above isolated calibration proofs:

```text
bridge-theorems.md
bridge-theorems/BT-0001-digit-collapse-is-modular-arithmetic.md
bridge-theorems/BT-0002-mirror-symmetry-creates-divisibility-gates.md
bridge-theorems/BT-0003-prime-completion-root-exclusions-are-residue-obstructions.md
lean/NumBridge/BridgeTheorems.lean
```

A Bridge Theorem is defined as a reusable theorem schema showing that a class
of numerology-like symbolic phrases corresponds to a precise mathematical
structure.

## 1. Which isolated theorem became a bridge schema?

BT-0001 promotes the digital-root calibration into the schema "digit collapse is
modular arithmetic." The isolated PrimeBridge theorem becomes an instance of
the broader residue view.

BT-0002 promotes the four-digit mirror theorem into the schema "mirror symmetry
creates divisibility gates." The new six-digit theorem is the next compiled
intermediate case.

BT-0003 promotes the prime digital-root exclusion into the schema "prime
completion-root exclusions are residue obstructions." This is the explicit
PrimeBridge generalization layer.

## 2. Which parts were proved in Lean?

Lean file:

```text
lean/NumBridge/BridgeTheorems.lean
```

Compiled theorem names:

```text
NumBridge.digital_root_10_mod_nine
NumBridge.residue_three_six_zero_mod_nine_implies_three_dvd
NumBridge.digital_root_10_eq_three_six_nine_implies_three_dvd
NumBridge.prime_completion_roots_vanish_bridge
NumBridge.six_digit_mirror_factorization
NumBridge.six_digit_mirror_divisible_by_11
NumBridge.mirror_symmetry_creates_divisibility_gates_bridge
```

The first requested modular PrimeBridge target was already closed and is now
part of the bridge theorem layer:

```text
NumBridge.prime_gt_three_mod_nine_allowed
```

The second requested target was proved:

```text
If n % 9 is 3, 6, or 0, then 3 divides n.
```

The six-digit mirror theorem was also proved:

```text
11 ∣ 100000*a + 10000*b + 1000*c + 100*c + 10*b + a
```

There is no `sorry`, `admit`, or `axiom`.

## 3. Which parts remain conjectural or engineering work?

BT-0001 still needs a full digit-list theorem: repeated digit sum in arbitrary
base `b` preserves residue modulo `b - 1`.

BT-0002 still needs the full digit-list/base-`b` theorem:

```text
value_b (xs ++ reverse xs) is divisible by b + 1
```

BT-0003 still needs the fully parameterized theorem for base `b` and a prime
divisor `q` of `b - 1`. The decimal `b = 10`, `q = 3` instance is closed.

## 4. Classification

BT-0001: useful. It is the core translation from digit-root language to modular
arithmetic, but the current Lean proof is only the lightweight decimal residue
instance.

BT-0002: strong target. The four- and six-digit mirror cases compile, and the
general theorem is mathematically clear, but the digit-list proof remains open.

BT-0003: shallow-real. It is a clean PrimeBridge theorem, but the phenomenon is
explained entirely by divisibility by 3.

Overall result: useful bridge-theorem layer established, with one shallow-real
PrimeBridge schema closed and one mirror schema advanced from four digits to
six digits.
