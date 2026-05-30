# Prime Digital-Root Lean Bridge Report - 2026-05-29

## Bridge attempted

Symbolic phrase: "completion roots vanish from primes."

Mathematical bridge: in base 10, digital roots `3`, `6`, and `9` correspond to
divisibility by 3. Therefore primes greater than 3 cannot have those digital
roots.

## Lean result

Compiled theorem path:

```text
lean/NumBridge/PrimeDigitalRoot.lean
NumBridge.PrimeDigitalRoot.prime_gt_three_not_dvd_by_three
NumBridge.PrimeDigitalRoot.prime_gt_three_mod_three_ne_zero
NumBridge.PrimeDigitalRoot.prime_gt_three_mod_nine_allowed
NumBridge.PrimeDigitalRoot.prime_gt_three_digital_root_10_not_three_six_nine
```

The file defines a lightweight local predicate
`NumBridge.PrimeDigitalRoot.Prime` because the project is currently kept
standard-library-only. The final theorem defines a lightweight
`digital_root_10` by modulo 9 and proves that a prime `p > 3` cannot have
digital root `3`, `6`, or `9`. There is no `sorry`.

Label: shallow-real. The bridge is true and useful as a translation, but the
prime-specific phenomenon is completely explained by divisibility by 3.

## Validation

Commands run with `python3` because `python` is not on PATH:

```text
python3 bridge.py validate
python3 -m unittest discover -s tests
python3 bridge.py run-all
python3 bridge.py seek-lean-bridge
lake build
```

All passed in the final verification run.

## Markdown files changed

- `leads.md`
- `leads/L-0001-digital-roots-of-primes.md`
- `experiments/E-0001-prime-digital-roots.md`
- `conjectures.md`
- `conjectures/C-0001-prime-digital-root-exclusion.md`
- `bridge-cards/B-0001-digital-root-to-modular-arithmetic.md`
- `bridges.md`
- `proof-roadmap.md`
- `evolution.md`
- `lean/README.md`
- `reports/lean_bridge_candidates.md`
- `reports/prime_digital_root_lean_bridge_2026-05-29.md`

Other implementation files changed:

- `lean/NumBridge/PrimeDigitalRoot.lean`
- `src/numbridge/cli.py`
- `src/numbridge/lean.py`
- `src/numbridge/reports.py`
- `src/numbridge/scoring.py`

## Next strongest target

Do not keep optimizing only palindrome bridges. Treat both mirror/11 and prime
digital-root exclusion as calibration closures.

The next PrimeBridge hunt should look for a prime-specific residue or digit
pattern that survives the fair null model of odd nonmultiples of 3. If none
survives, record it as a failure or shallow-real bridge rather than promoting
it.
