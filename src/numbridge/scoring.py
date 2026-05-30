from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class BridgeScore:
    formal_clarity: int
    empirical_support: int
    null_survival: int
    base_behavior: int
    generality: int
    simplicity: int
    proof_tractability: int
    reusability: int
    novelty: int

    @property
    def total(self) -> int:
        return sum(self.__dict__.values())

    @property
    def label(self) -> str:
        total = self.total
        if total < 25:
            return "mirage"
        if total < 40:
            return "shallow-real"
        if total < 55:
            return "useful-bridge"
        if total < 70:
            return "strong-bridge"
        return "deep-bridge"


def default_score_for_bridge(bridge_id: str) -> BridgeScore:
    if bridge_id == "B-0002":
        return BridgeScore(8, 9, 8, 8, 7, 8, 9, 8, 3)
    if bridge_id == "B-0004":
        return BridgeScore(8, 8, 7, 6, 5, 7, 8, 4, 1)
    if bridge_id == "B-0005":
        return BridgeScore(9, 8, 8, 8, 8, 7, 7, 8, 5)
    if bridge_id == "B-0006":
        return BridgeScore(9, 9, 8, 8, 8, 7, 6, 9, 5)
    if bridge_id == "B-0007":
        return BridgeScore(8, 6, 7, 8, 7, 6, 5, 8, 8)
    if bridge_id == "B-0008":
        return BridgeScore(9, 7, 8, 8, 8, 7, 7, 9, 6)
    if bridge_id == "B-0009":
        return BridgeScore(9, 7, 8, 8, 6, 8, 8, 8, 7)
    if bridge_id == "B-0010":
        return BridgeScore(9, 7, 8, 8, 8, 8, 8, 9, 7)
    if bridge_id == "B-0001":
        return BridgeScore(7, 6, 3, 5, 1, 5, 7, 4, 1)
    return BridgeScore(5, 3, 2, 2, 3, 5, 2, 4, 3)
