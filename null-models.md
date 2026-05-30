# Null Models

## NM-0001: Uniform integers

Use for broad first-pass integer properties. Do not use as a final comparator for primes.

## NM-0002: Odd integers

Use for prime comparisons after removing evenness.

## NM-0003: Odd nonmultiples of 3

Use for base-10 digital-root comparisons involving primes.

## NM-0004: Wheel-sieved candidates

Integers coprime to a primorial such as `2·3·5` or `2·3·5·7`.

Use for prime-like residue comparisons.

## NM-0005: Base-matched digit randoms

Use for digit pattern claims such as palindrome, repeated digits, digit sums, and roots.

## NM-0006: Shuffled sequence

Use for testing whether local ordering matters after preserving marginal distribution.
