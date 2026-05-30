# Lean Workspace

This folder contains theorem targets exported from the Markdown ledger.

Try locally with Lean/Lake installed:

```bash
lake update
lake build
```

The current micro-targets are intentionally small and standard-library-only:

- `NumBridge.four_digit_mirror_divisible_by_11`
- `NumBridge.prime_gt_three_not_dvd_by_three`
- `NumBridge.digital_root_10_mod_nine`
- `NumBridge.six_digit_mirror_divisible_by_11`
- `NumBridge.triplet_mod_three_sieve_gate`
- `NumBridge.only_prime_triplet_three_five_seven`
- `NumBridge.resonance_cover_forces_sieve_hit`
- `NumBridge.resonance_zero_two_six_survives_mod_three`

`NumBridge.four_digit_mirror_divisible_by_11` is a closed
shallow-real calibration theorem for `B-0002` / `C-0002`.

`NumBridge.prime_gt_three_digital_root_10_not_three_six_nine`
is a closed shallow-real PrimeBridge theorem for `B-0001` / `C-0001`.

These targets are meant to be verified first, then generalized toward the
conjectures in `proof-roadmap.md`.

The bridge theorem layer lives in `NumBridge.BridgeTheorems` and records
intermediate theorem schemas before the full digit-list/base-`b`
formalizations are available.

Prime constellation sieve gates live in `NumBridge.PrimeConstellations`.

Residue-shadow and resonance facts live in `NumBridge.ResidueShadow` and
`NumBridge.PrimePatternResonance`.
