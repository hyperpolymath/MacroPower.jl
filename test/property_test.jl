# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# Property-based invariant tests for MacroPower.jl.

using Test

include(joinpath(@__DIR__, "..", "src", "MacroPower.jl"))
using .MacroPower

@testset "Property-Based Tests" begin

    @testset "run_workflow: action executes iff all triggers fire" begin
        for _ in 1:50
            should_fire = rand(Bool)
            count = Ref(0)
            t = Trigger("prop_t", () -> should_fire)
            a = Action("prop_a", () -> (count[] += 1))
            wf = Workflow("prop_wf_$(rand(1:9999))", [t], [a])
            run_workflow(wf)
            if should_fire
                @test count[] >= 1
            else
                @test count[] == 0
            end
        end
    end

    @testset "run_workflow: empty workflow always returns nothing" begin
        for _ in 1:50
            wf = Workflow("empty_$(rand(1:9999))", Trigger[], Action[])
            result = run_workflow(wf)
            @test result === nothing
        end
    end

    @testset "Trigger: check function always callable and returns Bool" begin
        for _ in 1:50
            val = rand(Bool)
            t = Trigger("prop_check_$(rand(1:9999))", () -> val)
            @test t.check() isa Bool
            @test t.check() == val
        end
    end

    @testset "Action: execute function always callable" begin
        for _ in 1:50
            val = rand(Int)
            a = Action("prop_action_$(rand(1:9999))", () -> val)
            result = a.execute()
            @test result == val
        end
    end

    @testset "Workflow: all types are immutable" begin
        for _ in 1:50
            t = Trigger("t", () -> true)
            a = Action("a", () -> nothing)
            wf = Workflow("w", [t], [a])
            @test !ismutable(t)
            @test !ismutable(a)
            @test !ismutable(wf)
        end
    end

    @testset "Workflow: trigger and action names are preserved" begin
        for i in 1:50
            tname = "trigger_prop_$(i)"
            aname = "action_prop_$(i)"
            t = Trigger(tname, () -> true)
            a = Action(aname, () -> nothing)
            @test t.name == tname
            @test a.name == aname
        end
    end

    @testset "run_workflow: action count scales with number of firing actions" begin
        for trial in 1:20
            n_actions = rand(1:8)
            count = Ref(0)
            t = Trigger("fire_all_prop", () -> true)
            actions = [Action("a_$(i)", () -> (count[] += 1)) for i in 1:n_actions]
            wf = Workflow("scale_$(trial)", [t], actions)
            run_workflow(wf)
            @test count[] == n_actions
        end
    end

end
