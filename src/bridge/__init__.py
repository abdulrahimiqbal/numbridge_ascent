"""PrimeBridge search engine modules."""

from .prime_patterns import count_prime_translates, normalize_offsets, primes_up_to
from .residue_shadow import (
    admissibility_witnesses,
    gate_deficit,
    is_admissible,
    is_obstructed_mod,
    residue_shadow,
    residue_shadow_size,
)
from .resonance import (
    compare_observed_to_resonance,
    local_survival_factor,
    rank_patterns_by_resonance,
    search_admissible_patterns,
    truncated_singular_series,
)
from .wheel_shadow import (
    compare_patterns_by_wheel_distribution,
    exact_wheel_distribution_holds,
    local_shadow_count,
    local_survival_count,
    normalized_wheel_density,
    primorial,
    product_local_survival_count,
    squarefree_part,
    wheel_resonance_factor,
    wheel_survivor_count,
    wheel_survivors,
)

__all__ = [
    "admissibility_witnesses",
    "compare_observed_to_resonance",
    "compare_patterns_by_wheel_distribution",
    "count_prime_translates",
    "exact_wheel_distribution_holds",
    "gate_deficit",
    "is_admissible",
    "is_obstructed_mod",
    "local_survival_factor",
    "local_shadow_count",
    "local_survival_count",
    "normalize_offsets",
    "normalized_wheel_density",
    "primorial",
    "product_local_survival_count",
    "primes_up_to",
    "rank_patterns_by_resonance",
    "residue_shadow",
    "residue_shadow_size",
    "search_admissible_patterns",
    "squarefree_part",
    "truncated_singular_series",
    "wheel_resonance_factor",
    "wheel_survivor_count",
    "wheel_survivors",
]
