from __future__ import annotations

import argparse
import sys
from pathlib import Path

from .experiments import RUNNERS, write_result
from .lean import export_lean
from .md import append_section, write_doc
from .ontology import interpret_claim
from .paths import RepoPaths, find_repo_root
from .registry import find_card, iter_markdown, load_cards, next_id, slugify
from .reports import write_lean_bridge_report


REQUIRED_BY_TYPE = {
    "lead": ["id", "type", "title", "status"],
    "conjecture": ["id", "type", "title", "status"],
    "experiment": ["id", "type", "title", "status", "runner"],
    "bridge": ["id", "type", "title", "status"],
    "bridge-theorem": ["id", "type", "title", "status"],
}


def _paths(args: argparse.Namespace) -> RepoPaths:
    root = Path(args.repo).resolve() if getattr(args, "repo", None) else find_repo_root()
    return RepoPaths(root=root)


def cmd_index(args: argparse.Namespace) -> int:
    paths = _paths(args)
    cards = load_cards(paths)
    counts: dict[str, int] = {}
    for card in cards:
        typ = str(card.meta.get("type", "unknown"))
        counts[typ] = counts.get(typ, 0) + 1
    print(f"Repo: {paths.root}")
    for key in sorted(counts):
        print(f"{key}: {counts[key]}")
    print("\nTop cards:")
    for card in cards[:12]:
        print(f"- {card.meta.get('id', '?')} {card.meta.get('title', card.path.name)} [{card.meta.get('type', 'unknown')}]")
    return 0


def cmd_validate(args: argparse.Namespace) -> int:
    paths = _paths(args)
    errors: list[str] = []
    ids: dict[str, Path] = {}
    for path in iter_markdown(paths):
        doc = load_doc_safe(path, errors)
        if doc is None:
            continue
        typ = doc.meta.get("type")
        if not typ:
            errors.append(f"{path}: missing type")
            continue
        required = REQUIRED_BY_TYPE.get(str(typ), ["id", "type", "title"])
        for key in required:
            if key not in doc.meta or doc.meta.get(key) in (None, ""):
                errors.append(f"{path}: missing {key}")
        identifier = doc.meta.get("id")
        if identifier:
            if str(identifier) in ids:
                errors.append(f"duplicate id {identifier}: {path} and {ids[str(identifier)]}")
            ids[str(identifier)] = path
        if typ == "experiment" and doc.meta.get("runner") not in RUNNERS:
            errors.append(f"{path}: unknown runner {doc.meta.get('runner')!r}")
    if errors:
        print("Validation failed:")
        for err in errors:
            print(f"- {err}")
        return 1
    print(f"Validation passed for {len(ids)} cards.")
    return 0


def load_doc_safe(path: Path, errors: list[str]):
    from .md import read_doc
    try:
        return read_doc(path)
    except Exception as exc:  # pragma: no cover
        errors.append(f"{path}: failed to parse: {exc}")
        return None


def _parse_offsets(raw: str) -> list[int]:
    value = raw
    if raw.startswith("H="):
        value = raw.split("=", 1)[1]
    try:
        return [int(part.strip()) for part in value.split(",") if part.strip()]
    except ValueError as exc:
        raise argparse.ArgumentTypeError(f"invalid offset list {raw!r}") from exc


def _parse_primes(raw: str) -> list[int]:
    value = raw
    if raw.startswith("primes="):
        value = raw.split("=", 1)[1]
    try:
        primes = [int(part.strip()) for part in value.split(",") if part.strip()]
    except ValueError as exc:
        raise argparse.ArgumentTypeError(f"invalid prime list {raw!r}") from exc
    if any(p <= 1 for p in primes):
        raise argparse.ArgumentTypeError("all primes must be > 1")
    return primes


def _parse_gates(raw: str) -> list[int]:
    value = raw
    if raw.startswith("gates="):
        value = raw.split("=", 1)[1]
    try:
        gates = [int(part.strip()) for part in value.split(",") if part.strip()]
    except ValueError as exc:
        raise argparse.ArgumentTypeError(f"invalid gate list {raw!r}") from exc
    if any(g <= 1 for g in gates):
        raise argparse.ArgumentTypeError("all gates must be > 1")
    return gates


def _parse_named_int(name: str):
    def parse(raw: str) -> int:
        value = raw
        if raw.startswith(f"{name}="):
            value = raw.split("=", 1)[1]
        try:
            return int(value)
        except ValueError as exc:
            raise argparse.ArgumentTypeError(f"invalid {name} value {raw!r}") from exc

    return parse


def _format_pattern(pattern: list[int]) -> str:
    return "[" + ",".join(str(h) for h in pattern) + "]"


def _print_pattern_row(row: dict[str, object], rank: int | None = None) -> None:
    prefix = f"{rank:>3}. " if rank is not None else ""
    labels = ", ".join(str(x) for x in row.get("labels", []))
    witnesses = row.get("obstruction_witnesses", [])
    witness_text = ""
    if witnesses:
        witness_text = f" obstruction={witnesses}"
    print(
        f"{prefix}{_format_pattern(list(row['pattern']))} "
        f"resonance={float(row['resonance']):.6g} "
        f"{labels}{witness_text}"
    )


def cmd_prime_pattern(args: argparse.Namespace) -> int:
    from bridge.residue_shadow import admissibility_witnesses, shadow_profile
    from bridge.resonance import classify_pattern, truncated_singular_series
    from bridge.prime_patterns import normalize_offsets

    offsets = normalize_offsets(args.H)
    witnesses = admissibility_witnesses(offsets)
    labels = classify_pattern(offsets, args.prime_bound, args.N)
    print(f"Pattern: {_format_pattern(offsets)}")
    print(f"Classification: {', '.join(labels)}")
    print(f"Admissible: {not witnesses}")
    print(f"Truncated singular series up to {args.prime_bound}: {truncated_singular_series(offsets, args.prime_bound):.8g}")
    if witnesses:
        print(f"Obstruction witnesses: {witnesses}")
    print("Residue shadows:")
    for row in shadow_profile(offsets, args.prime_bound):
        print(
            f"- p={row['prime']}: shadow={row['shadow']} "
            f"deficit={row['gate_deficit']} obstructed={row['obstructed']}"
        )
    return 0


def cmd_search_admissible(args: argparse.Namespace) -> int:
    from bridge.resonance import search_admissible_patterns

    patterns = search_admissible_patterns(args.k, args.diameter)
    print(f"Admissible patterns: k={args.k}, diameter<={args.diameter}, count={len(patterns)}")
    for pattern in patterns[: args.limit]:
        print(f"- {_format_pattern(pattern)}")
    if len(patterns) > args.limit:
        print(f"... {len(patterns) - args.limit} more")
    return 0


def cmd_rank_resonance(args: argparse.Namespace) -> int:
    from bridge.resonance import rank_patterns_by_resonance

    rows = rank_patterns_by_resonance(args.k, args.diameter, args.prime_bound)
    print(
        f"Resonance ranking: k={args.k}, diameter<={args.diameter}, "
        f"prime_bound={args.prime_bound}"
    )
    for i, row in enumerate(rows[: args.limit], 1):
        _print_pattern_row(row, i)
    return 0


def cmd_primebridge_report(args: argparse.Namespace) -> int:
    from bridge.resonance import compare_observed_to_resonance, rank_patterns_by_resonance

    rows = rank_patterns_by_resonance(args.k, args.diameter, args.prime_bound)
    top = [row for row in rows if row["admissible"]][: args.limit]
    print("# PrimeBridge Resonance Search")
    print()
    print(f"k={args.k}, diameter<={args.diameter}, prime_bound={args.prime_bound}, N={args.N}")
    print()
    print("## Top Resonance Patterns")
    for i, row in enumerate(top, 1):
        _print_pattern_row(row, i)
    print()
    print("## Empirical Counts")
    for row in top:
        comparison = compare_observed_to_resonance(list(row["pattern"]), args.N, args.prime_bound)
        print(
            f"- {_format_pattern(list(row['pattern']))}: observed={comparison['observed']} "
            f"expected_rough={float(comparison['expected_rough']):.3f} "
            f"ratio={comparison['observed_to_expected']}"
        )
    return 0


def cmd_wheel_shadow(args: argparse.Namespace) -> int:
    from bridge.wheel_shadow import (
        local_shadow_count,
        local_survival_count,
        squarefree_part,
        wheel_resonance_factor,
        wheel_survivor_count,
        wheel_survivors,
    )
    from bridge.prime_patterns import normalize_offsets
    from bridge.prime_patterns import primes_up_to

    offsets = normalize_offsets(args.H)
    W = args.W
    sf = squarefree_part(W)
    primes = [p for p in primes_up_to(W) if sf % p == 0]
    survivors = wheel_survivors(offsets, W)
    print(f"Pattern: {_format_pattern(offsets)}")
    print(f"W: {W} squarefree_part={sf} primes={primes}")
    print(f"Survivor count: {wheel_survivor_count(offsets, W)}")
    print(f"Survivors: {survivors}")
    for p in primes:
        print(
            f"- p={p}: shadow_count={local_shadow_count(offsets, p)} "
            f"survival_count={local_survival_count(offsets, p)}"
        )
    print(f"Wheel resonance factor: {wheel_resonance_factor(offsets, primes):.8g}")
    return 0


def cmd_wheel_theorem_check(args: argparse.Namespace) -> int:
    from bridge.wheel_shadow import exact_wheel_distribution_holds, normalized_wheel_density, wheel_resonance_factor

    check = exact_wheel_distribution_holds(args.H, args.primes)
    print(f"Pattern: {_format_pattern(list(check['pattern']))}")
    print(f"Primes: {check['primes']} W={check['W']}")
    print(f"Survivor count: {check['survivor_count']}")
    print(f"Product local survival count: {check['product_local_survival_count']}")
    print(f"Product formula holds: {check['holds']}")
    print(f"Normalized density: {normalized_wheel_density(args.H, args.primes):.8g}")
    print(f"Wheel resonance factor: {wheel_resonance_factor(args.H, args.primes):.8g}")
    print(f"Survivors: {check['survivors']}")
    return 0 if check["holds"] else 1


def cmd_wheel_product_general(args: argparse.Namespace) -> int:
    from bridge.wheel_product_general import verify_general_wheel_product

    try:
        check = verify_general_wheel_product(args.gates, args.H)
    except ValueError as exc:
        print(f"Rejected: {exc}", file=sys.stderr)
        return 2
    print(f"Pattern: {_format_pattern(list(check['pattern']))}")
    print(f"Gates: {check['gates']} W={check['W']}")
    print(f"Pairwise coprime: {check['pairwise_coprime']}")
    print(f"Survivor count: {check['survivor_count']}")
    print(f"Product local survivor counts: {check['product_local_survivor_counts']}")
    print(f"Product formula holds: {check['holds']}")
    return 0 if check["holds"] else 1


def cmd_wheel_product_counterexample_search(args: argparse.Namespace) -> int:
    from bridge.wheel_product_general import search_for_counterexample_to_wheel_product

    result = search_for_counterexample_to_wheel_product(
        args.max_gate,
        args.max_offset,
        args.max_len,
    )
    print("# Wheel Product Counterexample Search")
    print(f"Checked pairwise-coprime cases: {result['checked_coprime']}")
    print(f"Checked non-coprime cases: {result['checked_non_coprime']}")
    coprime_counterexample = result["coprime_counterexample"]
    if coprime_counterexample:
        print("Pairwise-coprime counterexample found:")
        print(coprime_counterexample)
        return 1
    print("Pairwise-coprime counterexample found: none")
    non_coprime_counterexample = result["non_coprime_counterexample"]
    if non_coprime_counterexample:
        print("First non-coprime failure:")
        print(non_coprime_counterexample)
    else:
        print("Non-coprime failure found: none in search window")
    return 0


def cmd_resonance_lattice_max(args: argparse.Namespace) -> int:
    from bridge.resonance_lattice_maximizer import brute_force_verify_bt0008

    result = brute_force_verify_bt0008(args.k, args.D, args.gates)
    print(f"BT-0008 resonance lattice check: k={args.k} D={args.D} gates={result['gates']}")
    print(f"W={result['W']} upper_bound={result['upper_bound']}")
    print(f"threshold_attainable={result['threshold_attainable']}")
    print(f"canonical={_format_pattern(list(result['canonical_pattern']))}")
    print(f"canonical_valid={result['canonical_valid']} canonical_score={result['canonical_score']}")
    print(f"max_score={result['max_score']} maximizer_count={result['maximizer_count']}")
    print(f"upper_attainer_count={result['upper_attainer_count']}")
    for pattern in list(result["maximizers"])[:20]:
        print(f"- maximizer {_format_pattern(list(pattern))}")
    if result["maximizer_count"] > 20:
        print(f"... {result['maximizer_count'] - 20} more")
    print(f"holds={result['holds']}")
    return 0 if result["holds"] else 1


def cmd_verify_bt0008(args: argparse.Namespace) -> int:
    from bridge.resonance_lattice_maximizer import verify_bt0008

    result = verify_bt0008(args.max_k, args.max_D, args.gates)
    print(f"BT-0008 verifier: gates={result['gates']} max_k={args.max_k} max_D={args.max_D}")
    print(f"checked={result['checked']} holds={result['holds']}")
    if result["failures"]:
        print("Failures:")
        for failure in result["failures"][:10]:
            print(f"- k={failure['k']} D={failure['D']} max_score={failure['max_score']} upper={failure['upper_bound']}")
        if len(result["failures"]) > 10:
            print(f"... {len(result['failures']) - 10} more")
    return 0 if result["holds"] else 1


def cmd_subcritical_resonance_search(args: argparse.Namespace) -> int:
    from bridge.resonance_lattice_maximizer import search_subcritical_maximizers

    result = search_subcritical_maximizers(args.k, args.D, args.gates)
    print(f"BT-0008 subcritical resonance search: k={args.k} D={args.D} gates={result['gates']}")
    print(f"W={result['W']} upper_bound={result['upper_bound']}")
    print(f"threshold_attainable={result['threshold_attainable']} note={result['note']}")
    print(f"max_score={result['max_score']} maximizer_count={result['maximizer_count']}")
    for pattern in list(result["maximizers"])[:25]:
        print(f"- {_format_pattern(list(pattern))}")
    if result["maximizer_count"] > 25:
        print(f"... {result['maximizer_count'] - 25} more")
    print(f"upper_attainer_count={result['upper_attainer_count']}")
    return 0 if result["holds"] else 1


def cmd_subcritical_bt009(args: argparse.Namespace) -> int:
    from bridge.subcritical_resonance import (
        explain_bt0009_maximizers,
        verify_bt0009_subcritical_235,
    )

    if args.verify:
        result = verify_bt0009_subcritical_235()
        print("BT-0009 subcritical 235 verifier")
        print(f"gates={result['gates']} W={result['W']} k={result['k']} D={result['D']}")
        print(f"checked_patterns={result['checked_patterns']}")
        print(f"max_score={result['max_score']} expected={result['expected_max_score']}")
        print(f"maximizer_count={len(result['maximizers'])}")
        print(f"holds={result['holds']}")
        if not result["holds"]:
            print(f"over_bound={result['over_bound']}")
            print(f"bad_maximizers={result['bad_maximizers']}")
            print(f"missed_structural={result['missed_structural']}")
        return 0 if result["holds"] else 1

    explanation = explain_bt0009_maximizers()
    print("BT-0009 subcritical 235 structural theorem")
    print(f"gates={explanation['gates']} W={explanation['W']} k={explanation['k']} D={explanation['D']}")
    print(f"max_score={explanation['max_score']} maximizer_count={explanation['maximizer_count']}")
    print(explanation["structural_explanation"])
    if args.explain:
        print("Maximizers:")
        for pattern in explanation["maximizers"]:
            print(f"- {_format_pattern(list(pattern))}")
    return 0


def cmd_bt0010_first_subcritical(args: argparse.Namespace) -> int:
    from bridge.first_subcritical_sacrifice import verify_first_subcritical_sacrifice

    try:
        result = verify_first_subcritical_sacrifice(args.q)
    except ValueError as exc:
        print(f"Rejected: {exc}", file=sys.stderr)
        return 2
    print("BT-0010 first subcritical sacrifice")
    print(f"q={result['q']} gates={result['gates']} W={result['W']} D={result['D']}")
    print(f"checked_patterns={result['checked_patterns']}")
    print(f"predicted_max_score={result['predicted_max_score']} max_score={result['max_score']}")
    print(f"canonical={_format_pattern(list(result['canonical_attainer']))} score={result['canonical_score']}")
    print(f"maximizer_count={result['maximizer_count']} structural_count={result['structural_count']}")
    print(f"holds={result['holds']}")
    return 0 if result["holds"] else 1


def cmd_bt0010_scan(args: argparse.Namespace) -> int:
    from math import gcd

    from bridge.first_subcritical_sacrifice import scan_first_subcritical_q_values

    q_values = [q for q in range(5, args.q_max + 1) if gcd(q, 6) == 1]
    result = scan_first_subcritical_q_values(q_values)
    print(f"BT-0010 scan q<= {args.q_max}")
    print(f"tested_q_values={q_values}")
    print(f"checked={result['checked']} holds={result['holds']}")
    for row in result["results"]:
        print(
            f"- q={row['q']}: max={row['max_score']} "
            f"predicted={row['predicted_max_score']} "
            f"maximizers={row['maximizer_count']} holds={row['holds']}"
        )
    return 0 if result["holds"] else 1


def cmd_bt0010_counterexample_search(args: argparse.Namespace) -> int:
    from bridge.first_subcritical_sacrifice import find_counterexample_bt0010

    try:
        result = find_counterexample_bt0010(args.q_max)
    except ValueError as exc:
        print(f"Rejected: {exc}", file=sys.stderr)
        return 2
    print(f"BT-0010 counterexample search q<= {args.q_max}")
    print(f"tested_q_values={result['tested_q_values']}")
    print(f"counterexample={result['counterexample']}")
    print(f"holds={result['holds']}")
    return 0 if result["holds"] else 1


def cmd_branch_truth_report(args: argparse.Namespace) -> int:
    paths = _paths(args)
    path = paths.root / "numerology-branches.md"
    print(path.read_text(encoding="utf-8").rstrip())
    return 0


def cmd_breakthrough_report(args: argparse.Namespace) -> int:
    paths = _paths(args)
    path = paths.reports / "wheel_shadow_distribution_breakthrough_2026-05-29.md"
    print(path.read_text(encoding="utf-8").rstrip())
    return 0


def cmd_add_lead(args: argparse.Namespace) -> int:
    paths = _paths(args)
    paths.leads.mkdir(parents=True, exist_ok=True)
    lead_id = next_id(paths, "L", paths.leads)
    slug = slugify(args.claim)
    meta = {
        "id": lead_id,
        "type": "lead",
        "title": args.claim[:80],
        "status": "raw",
        "domain": ["unknown"],
        "symbolic_terms": [],
        "related_experiments": [],
        "related_conjectures": [],
        "related_bridges": [],
    }
    interpretations = interpret_claim(args.claim)
    bullets = "\n".join(
        f"{i}. **{it.description}** — `{it.formalization}`. Fields: {', '.join(it.fields)}"
        for i, it in enumerate(interpretations, 1)
    )
    body = f"""# {lead_id}: {args.claim}

## Symbolic intuition

{args.claim}

## Candidate formalizations

{bullets}

## Current result

Raw lead. Needs experiments and null models.

## Next actions

- [ ] Choose one formalization.
- [ ] Create experiment card.
- [ ] Define null models.
"""
    path = paths.leads / f"{lead_id}-{slug}.md"
    write_doc(path, meta, body)
    print(f"Created {path.relative_to(paths.root)}")
    return 0


def cmd_expand(args: argparse.Namespace) -> int:
    paths = _paths(args)
    doc = find_card(paths, args.identifier)
    if not doc:
        print(f"No card found for {args.identifier}", file=sys.stderr)
        return 1
    claim = str(doc.meta.get("title", "")) + "\n" + doc.body[:500]
    interpretations = interpret_claim(claim)
    content = "\n".join(
        f"{i}. **{it.symbolic_term} / {it.description}** — `{it.formalization}`. Fields: {', '.join(it.fields)}"
        for i, it in enumerate(interpretations, 1)
    )
    append_section(doc.path, "Generated Interpretations", content)
    print(f"Expanded {doc.meta.get('id')} with {len(interpretations)} interpretations.")
    return 0


def _run_experiment(paths: RepoPaths, doc) -> Path:
    runner_name = str(doc.meta.get("runner"))
    runner = RUNNERS[runner_name]
    result = runner()
    out = write_result(result, paths.data_results)
    content = f"""Result file: `data/experiment-results/{out.name}`

Verdict: **{result.verdict}**

Summary: {result.summary}

Bridge implication: {result.bridge_implication}
"""
    append_section(doc.path, "Latest Result", content)
    return out


def cmd_run(args: argparse.Namespace) -> int:
    paths = _paths(args)
    doc = find_card(paths, args.identifier)
    if not doc:
        print(f"No card found for {args.identifier}", file=sys.stderr)
        return 1
    if doc.meta.get("type") != "experiment":
        print(f"{args.identifier} is not an experiment", file=sys.stderr)
        return 1
    out = _run_experiment(paths, doc)
    print(f"Wrote {out.relative_to(paths.root)}")
    return 0


def cmd_run_all(args: argparse.Namespace) -> int:
    paths = _paths(args)
    count = 0
    for doc in load_cards(paths):
        if doc.meta.get("type") == "experiment" and doc.meta.get("runner") in RUNNERS:
            out = _run_experiment(paths, doc)
            print(f"{doc.meta.get('id')}: wrote {out.relative_to(paths.root)}")
            count += 1
    print(f"Ran {count} experiments.")
    return 0


def cmd_seek_lean_bridge(args: argparse.Namespace) -> int:
    paths = _paths(args)
    path = write_lean_bridge_report(paths)
    print(f"Wrote {path.relative_to(paths.root)}")
    print("Top recommendation: close BT-0011, the reusable two-offset residue-shadow count lemma.")
    return 0


def cmd_export_lean(args: argparse.Namespace) -> int:
    paths = _paths(args)
    doc = find_card(paths, args.identifier)
    if not doc:
        print(f"No card found for {args.identifier}", file=sys.stderr)
        return 1
    if doc.meta.get("type") != "conjecture":
        print(f"{args.identifier} is not a conjecture", file=sys.stderr)
        return 1
    out = export_lean(doc, paths.lean)
    print(f"Wrote {out.relative_to(paths.root)}")
    return 0


def cmd_report(args: argparse.Namespace) -> int:
    paths = _paths(args)
    doc = find_card(paths, args.identifier)
    if not doc:
        print(f"No card found for {args.identifier}", file=sys.stderr)
        return 1
    print(f"# {doc.meta.get('id')} — {doc.meta.get('title')}")
    print(f"Type: {doc.meta.get('type')} | Status: {doc.meta.get('status')}")
    print(f"Path: {doc.path.relative_to(paths.root)}")
    print("\n" + doc.body[:2000].rstrip())
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="bridge.py", description="NumBridge Ascent CLI")
    parser.add_argument("--repo", help="Repository root. Defaults to auto-detect/current directory.")
    sub = parser.add_subparsers(dest="command", required=True)

    p = sub.add_parser("index", help="Show repository index")
    p.set_defaults(func=cmd_index)

    p = sub.add_parser("validate", help="Validate Markdown cards")
    p.set_defaults(func=cmd_validate)

    p = sub.add_parser("add-lead", help="Create a new lead from a symbolic claim")
    p.add_argument("claim")
    p.set_defaults(func=cmd_add_lead)

    p = sub.add_parser("expand", help="Generate ontology-based interpretations for a card")
    p.add_argument("identifier")
    p.set_defaults(func=cmd_expand)

    p = sub.add_parser("run", help="Run an experiment by ID")
    p.add_argument("identifier")
    p.set_defaults(func=cmd_run)

    p = sub.add_parser("run-all", help="Run all registered experiments")
    p.set_defaults(func=cmd_run_all)

    p = sub.add_parser("seek-lean-bridge", help="Rank candidates for Lean-solvable bridges")
    p.set_defaults(func=cmd_seek_lean_bridge)

    p = sub.add_parser("export-lean", help="Export a Lean theorem scaffold for a conjecture")
    p.add_argument("identifier")
    p.set_defaults(func=cmd_export_lean)

    p = sub.add_parser("report", help="Print a card report")
    p.add_argument("identifier")
    p.set_defaults(func=cmd_report)

    p = sub.add_parser("prime-pattern", help="Analyze a prime offset pattern, e.g. H=0,2,6")
    p.add_argument("H", type=_parse_offsets)
    p.add_argument("--prime-bound", type=int, default=31)
    p.add_argument("--N", type=int, default=None)
    p.set_defaults(func=cmd_prime_pattern)

    p = sub.add_parser("search-admissible", help="Search admissible offset patterns")
    p.add_argument("--k", type=int, required=True)
    p.add_argument("--diameter", type=int, required=True)
    p.add_argument("--limit", type=int, default=25)
    p.set_defaults(func=cmd_search_admissible)

    p = sub.add_parser("rank-resonance", help="Rank offset patterns by truncated local resonance")
    p.add_argument("--k", type=int, required=True)
    p.add_argument("--diameter", type=int, required=True)
    p.add_argument("--prime-bound", type=int, required=True)
    p.add_argument("--limit", type=int, default=20)
    p.set_defaults(func=cmd_rank_resonance)

    p = sub.add_parser("primebridge-report", help="Generate a PrimeBridge resonance search report")
    p.add_argument("--k", type=int, required=True)
    p.add_argument("--diameter", type=int, required=True)
    p.add_argument("--N", type=int, required=True)
    p.add_argument("--prime-bound", type=int, default=31)
    p.add_argument("--limit", type=int, default=10)
    p.set_defaults(func=cmd_primebridge_report)

    p = sub.add_parser("wheel-shadow", help="Analyze finite-wheel survivors for an offset pattern")
    p.add_argument("H", type=_parse_offsets)
    p.add_argument("W", type=lambda raw: int(raw.split("=", 1)[1]) if raw.startswith("W=") else int(raw))
    p.set_defaults(func=cmd_wheel_shadow)

    p = sub.add_parser("wheel-theorem-check", help="Check finite wheel product formula by brute force")
    p.add_argument("H", type=_parse_offsets)
    p.add_argument("primes", type=_parse_primes)
    p.set_defaults(func=cmd_wheel_theorem_check)

    p = sub.add_parser("wheel-product-general", help="Check the general pairwise-coprime wheel product formula")
    p.add_argument("H", type=_parse_offsets)
    p.add_argument("gates", type=_parse_gates)
    p.set_defaults(func=cmd_wheel_product_general)

    p = sub.add_parser("wheel-product-counterexample-search", help="Search for finite wheel product counterexamples")
    p.add_argument("--max-gate", type=int, required=True)
    p.add_argument("--max-offset", type=int, required=True)
    p.add_argument("--max-len", type=int, default=3)
    p.set_defaults(func=cmd_wheel_product_counterexample_search)

    p = sub.add_parser("resonance-lattice-max", help="Check the BT-0008 resonance lattice maximizer structure")
    p.add_argument("k", type=_parse_named_int("k"))
    p.add_argument("D", type=_parse_named_int("D"))
    p.add_argument("gates", type=_parse_gates)
    p.set_defaults(func=cmd_resonance_lattice_max)

    p = sub.add_parser("verify-bt0008", help="Brute-force verify BT-0008 over a bounded window")
    p.add_argument("--max-k", type=int, required=True)
    p.add_argument("--max-D", type=int, required=True)
    p.add_argument("--gates", type=_parse_gates, required=True)
    p.set_defaults(func=cmd_verify_bt0008)

    p = sub.add_parser("subcritical-resonance-search", help="Search subcritical BT-0008 maximizers")
    p.add_argument("k", type=_parse_named_int("k"))
    p.add_argument("D", type=_parse_named_int("D"))
    p.add_argument("gates", type=_parse_gates)
    p.set_defaults(func=cmd_subcritical_resonance_search)

    p = sub.add_parser("subcritical-bt009", help="Run the BT-0009 subcritical 235 verifier")
    p.add_argument("--explain", action="store_true", help="Print the structural explanation and maximizer list")
    p.add_argument("--verify", action="store_true", help="Run the bounded BT-0009 verifier")
    p.set_defaults(func=cmd_subcritical_bt009)

    p = sub.add_parser("bt0010-first-subcritical", help="Verify BT-0010 for one q value")
    p.add_argument("q", type=_parse_named_int("q"))
    p.set_defaults(func=cmd_bt0010_first_subcritical)

    p = sub.add_parser("bt0010-scan", help="Scan BT-0010 over q values up to q-max")
    p.add_argument("--q-max", type=int, required=True)
    p.set_defaults(func=cmd_bt0010_scan)

    p = sub.add_parser("bt0010-counterexample-search", help="Search for BT-0010 counterexamples")
    p.add_argument("--q-max", type=int, required=True)
    p.set_defaults(func=cmd_bt0010_counterexample_search)

    p = sub.add_parser("branch-truth-report", help="Print numerology branch truth taxonomy")
    p.set_defaults(func=cmd_branch_truth_report)

    p = sub.add_parser("breakthrough-report", help="Print the wheel-shadow breakthrough report")
    p.set_defaults(func=cmd_breakthrough_report)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return int(args.func(args))
