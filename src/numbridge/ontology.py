from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Interpretation:
    symbolic_term: str
    description: str
    formalization: str
    fields: tuple[str, ...]


ONTOLOGY: dict[str, list[Interpretation]] = {
    "completion": [
        Interpretation("completion", "terminal digital-root state", "digital_root_b(n) = b - 1", ("modular_arithmetic",)),
        Interpretation("completion", "zero residue modulo base-minus-one", "n ≡ 0 mod (b - 1)", ("number_theory",)),
        Interpretation("completion", "fixed point of an iterated map", "F^k(n) = F^{k+1}(n)", ("dynamical_systems",)),
    ],
    "mirror": [
        Interpretation("mirror", "palindrome", "digits_b(n) = reverse(digits_b(n))", ("combinatorics_on_words", "number_theory")),
        Interpretation("mirror", "digit reversal", "rev_b(n)", ("automata_theory",)),
        Interpretation("mirror", "involution", "T(T(x)) = x", ("algebra",)),
    ],
    "gate": [
        Interpretation("gate", "divisibility predicate", "m ∣ n", ("number_theory",)),
        Interpretation("gate", "residue transition", "n mod m ∈ A", ("modular_arithmetic",)),
    ],
    "resistance": [
        Interpretation("resistance", "primality", "is_prime(n)", ("number_theory",)),
        Interpretation("resistance", "low factor count", "omega(n) is small", ("factorization",)),
        Interpretation("resistance", "long orbit", "orbit_length_F(n) is large", ("dynamical_systems",)),
    ],
    "collapse": [
        Interpretation("collapse", "digital-root iteration", "iterate(digit_sum_b, n)", ("modular_arithmetic", "dynamical_systems")),
        Interpretation("collapse", "multiplicative persistence", "iterate(product_digits_b, n)", ("dynamical_systems",)),
        Interpretation("collapse", "factorization tree", "factor_tree(n)", ("number_theory",)),
    ],
    "root": [
        Interpretation("root", "digital root", "digital_root_b(n)", ("modular_arithmetic",)),
        Interpretation("root", "fixed point", "F(x) = x", ("dynamical_systems",)),
    ],
    "rhythm": [
        Interpretation("rhythm", "periodicity", "x_{n+k} = x_n", ("dynamical_systems",)),
        Interpretation("rhythm", "autocorrelation", "corr(x_n, x_{n+k})", ("statistics",)),
    ],
    "resonance": [
        Interpretation("resonance", "Fourier feature", "|FFT(sequence)|", ("harmonic_analysis",)),
        Interpretation("resonance", "residue frequency", "distribution(n mod m)", ("statistics", "number_theory")),
    ],
}


def interpret_claim(claim: str) -> list[Interpretation]:
    text = claim.lower()
    found: list[Interpretation] = []
    for token, interpretations in ONTOLOGY.items():
        if token in text:
            found.extend(interpretations)
    if "7" in text:
        found.extend([
            Interpretation("7", "decimal digit or residue", "n mod 10 = 7 or n mod m = 7", ("modular_arithmetic",)),
            Interpretation("7", "digital root 7", "digital_root_10(n) = 7", ("modular_arithmetic",)),
            Interpretation("7", "7-adic valuation", "v_7(n)", ("number_theory",)),
        ])
    if "11" in text:
        found.extend([
            Interpretation("11", "divisibility by 11", "11 ∣ n", ("number_theory",)),
            Interpretation("11", "base-10 mirror modulus", "10 ≡ -1 mod 11", ("modular_arithmetic",)),
        ])
    if "9" in text:
        found.extend([
            Interpretation("9", "decimal base-minus-one", "10 - 1 = 9", ("modular_arithmetic",)),
            Interpretation("9", "zero residue under digital root", "n ≡ 0 mod 9", ("number_theory",)),
        ])
    # Deduplicate while preserving order.
    seen: set[tuple[str, str]] = set()
    unique: list[Interpretation] = []
    for item in found:
        key = (item.symbolic_term, item.formalization)
        if key not in seen:
            unique.append(item)
            seen.add(key)
    if not unique:
        unique.append(Interpretation("generic", "computable integer feature", "f(n) over a chosen integer domain", ("experimental_math",)))
    return unique
