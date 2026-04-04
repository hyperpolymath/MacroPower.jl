# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# E2E pipeline tests for MacroPower.jl.
# Tests the full workflow lifecycle: trigger definition → action definition →
# workflow assembly → execution → conditional gating.

using Test

include(joinpath(@__DIR__, "..", "src", "MacroPower.jl"))
using .MacroPower

@testset "E2E Pipeline Tests" begin

    @testset "Full pipeline: trigger → action → workflow → run" begin
        # Step 1: define a trigger that fires.
        fired = Ref(false)
        t = Trigger("always_fire", () -> true)
        @test t.check() == true

        # Step 2: define an action that records execution.
        a = Action("set_fired", () -> (fired[] = true))

        # Step 3: assemble workflow.
        wf = Workflow("e2e_wf_pass", [t], [a])
        @test wf.name == "e2e_wf_pass"
        @test length(wf.triggers) == 1
        @test length(wf.actions) == 1

        # Step 4: run workflow.
        run_workflow(wf)
        @test fired[] == true
    end

    @testset "Full pipeline: trigger does not fire → action is skipped" begin
        executed = Ref(false)
        t = Trigger("never_fire", () -> false)
        a = Action("should_not_run", () -> (executed[] = true))
        wf = Workflow("e2e_wf_skip", [t], [a])
        run_workflow(wf)
        @test executed[] == false
    end

    @testset "Full pipeline: multiple triggers, all must fire" begin
        count = Ref(0)
        t1 = Trigger("trig_1", () -> true)
        t2 = Trigger("trig_2", () -> true)
        a = Action("increment", () -> (count[] += 1))
        wf = Workflow("e2e_multi_trigger", [t1, t2], [a])
        run_workflow(wf)
        # Both triggers fire → action should run (at least once per all-fire).
        @test count[] >= 1
    end

    @testset "Full pipeline: multiple actions executed" begin
        log = String[]
        t = Trigger("fire_all", () -> true)
        a1 = Action("log_first",  () -> push!(log, "first"))
        a2 = Action("log_second", () -> push!(log, "second"))
        wf = Workflow("e2e_multi_action", [t], [a1, a2])
        run_workflow(wf)
        @test "first" in log
        @test "second" in log
    end

    @testset "Full pipeline: @workflow macro produces runnable workflow" begin
        wf = @workflow "e2e_macro_wf" begin end
        @test wf isa Workflow
        @test wf.name == "e2e_macro_wf"
        # Running an empty workflow must not throw.
        @test run_workflow(wf) === nothing
    end

    @testset "Error handling: empty workflow executes without error" begin
        wf = Workflow("e2e_empty", Trigger[], Action[])
        @test run_workflow(wf) === nothing
    end

    @testset "Round-trip consistency: workflow name and components preserved" begin
        triggers = [Trigger("t_$(i)", () -> true) for i in 1:3]
        actions  = [Action("a_$(i)",  () -> nothing) for i in 1:4]
        wf = Workflow("e2e_roundtrip", triggers, actions)
        @test wf.name == "e2e_roundtrip"
        @test length(wf.triggers) == 3
        @test length(wf.actions) == 4
        @test wf.triggers[2].name == "t_2"
        @test wf.actions[4].name == "a_4"
    end

end
