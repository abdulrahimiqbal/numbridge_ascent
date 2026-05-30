import Lake
open Lake DSL

package «numbridge_ascent» where
  -- NumBridge Lean package. The current calibration proofs use Lean's
  -- standard library only, keeping local proof checks lightweight.

@[default_target]
lean_lib NumBridge where
  srcDir := "lean"
