# Ascent Ladder

The system uses levels to track the maturity of a symbolic number idea.

## Level 0: Symbol

A vague phrase or intuition.

Example: `9 is completion.`

## Level 1: Candidate interpretation

One possible formal meaning.

Example: `digital_root_10(n) = 9`.

## Level 2: Computable function

The interpretation becomes executable.

Example: `f(n) = 1 + ((n - 1) mod 9)`.

## Level 3: Empirical pattern

The function is tested on a domain.

Example: primes greater than 3 never have digital root 9.

## Level 4: Null-model survival

The result survives fair comparison, or fails and is explained.

## Level 5: Conjecture

A precise statement is written.

## Level 6: Proof or counterexample

The statement is proved, disproved, or weakened.

## Level 7: Bridge

A reusable translation is recorded.

Example: digital root corresponds to modular arithmetic modulo `b - 1`.
