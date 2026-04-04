# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# BenchmarkTools benchmarks for MacroPower.jl.

using BenchmarkTools

include(joinpath(@__DIR__, "..", "src", "MacroPower.jl"))
using .MacroPower

println("=== MacroPower.jl Benchmarks ===")

# --- Type construction ---

println("\n-- Type construction --")

b_trigger = @benchmark Trigger("t", () -> true)
b_action  = @benchmark Action("a", () -> nothing)
println("Trigger construction: ", median(b_trigger))
println("Action construction:  ", median(b_action))

# Workflow: small (1 trigger, 1 action).
t1 = Trigger("t1", () -> true)
a1 = Action("a1", () -> nothing)
b_wf_small = @benchmark Workflow("w", [$t1], [$a1])
println("Workflow(1T, 1A):     ", median(b_wf_small))

# Workflow: medium (5 triggers, 5 actions).
triggers_5 = [Trigger("t_$(i)", () -> true) for i in 1:5]
actions_5  = [Action("a_$(i)",  () -> nothing) for i in 1:5]
b_wf_medium = @benchmark Workflow("w", $triggers_5, $actions_5)
println("Workflow(5T, 5A):     ", median(b_wf_medium))

# Workflow: large (20 triggers, 20 actions).
triggers_20 = [Trigger("t_$(i)", () -> true) for i in 1:20]
actions_20  = [Action("a_$(i)",  () -> nothing) for i in 1:20]
b_wf_large = @benchmark Workflow("w", $triggers_20, $actions_20)
println("Workflow(20T, 20A):   ", median(b_wf_large))

# --- run_workflow ---

println("\n-- run_workflow --")

wf_empty   = Workflow("empty", Trigger[], Action[])
wf_nofire  = Workflow("nofire",  [Trigger("t", () -> false)], [Action("a", () -> nothing)])
wf_fire_1  = Workflow("fire1",   [Trigger("t", () -> true)],  [Action("a", () -> nothing)])
wf_fire_10 = Workflow("fire10",  [Trigger("t", () -> true)],  [Action("a_$(i)", () -> nothing) for i in 1:10])

b_run_empty   = @benchmark run_workflow($wf_empty)
b_run_nofire  = @benchmark run_workflow($wf_nofire)
b_run_fire_1  = @benchmark run_workflow($wf_fire_1)
b_run_fire_10 = @benchmark run_workflow($wf_fire_10)
println("run_workflow (empty):       ", median(b_run_empty))
println("run_workflow (no-fire):     ", median(b_run_nofire))
println("run_workflow (1 action):    ", median(b_run_fire_1))
println("run_workflow (10 actions):  ", median(b_run_fire_10))
