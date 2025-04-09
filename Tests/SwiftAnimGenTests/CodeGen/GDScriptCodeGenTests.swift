import XCTest

@testable import SwiftAnimGen

class GDScriptCodeGenTests: XCTestCase {
    func testGenerate() {
        let dummy = makeDummyAnimationsFile()
        let sut = makeSut()

        let result = sut.generate(dummy)

        print(result)

        /*
        diffTest(expected: #"""
        # Handles:
        # idle_c_pistol
        class IdleCPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_IDLE_C_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, IdleCPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> run_c_pistol
                if state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        stack,
                        RunCPistolState.new()
                    )
                    return

                # -> idle_h_pistol
                if !state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        IdleHPistolState.new(animations.current_animation_position)
                    )
                    return

        # Handles:
        # idle_d_pistol
        class IdleDPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_IDLE_D_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, IdleDPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_h_pistol
                if state_machine.parameters[SM_H_AIMING]:
                    state_machine.transition(
                        stack,
                        IdleHPistolState.new()
                    )
                    return

        # Handles:
        # idle_h_pistol
        class IdleHPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_IDLE_H_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, IdleHPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_d_pistol
                if state_machine.parameters[SM_D_AIMING]:
                    state_machine.transition(
                        stack,
                        IdleDPistolState.new()
                    )
                    return

                # -> run_h_pistol
                if state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        stack,
                        RunHPistolState.new()
                    )
                    return

                # -> trans_h_v
                if state_machine.parameters[SM_V_AIMING]:
                    state_machine.transition(
                        stack,
                        TransitionHVPistolState.new()
                    )
                    return

                # -> trans_hc_pistol
                if state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        TransitionHCPistolState.new()
                    )
                    return

                # -> jump_pistol
                if state_machine.parameters[SM_AIR]:
                    state_machine.transition(
                        stack,
                        JumpPistolState.new()
                    )
                    return

        # Handles:
        # idle_v_pistol
        class IdleVPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_IDLE_V_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, IdleVPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_d_pistol
                if state_machine.parameters[SM_H_AIMING]:
                    state_machine.transition(
                        stack,
                        IdleDPistolState.new(animations.current_animation_position)
                    )
                    return

                # -> run_h_pistol
                if state_machine.parameters[SM_WALKING] and !state_machine.parameters[SM_V_AIMING]:
                    state_machine.transition(
                        stack,
                        RunHPistolState.new(state_machine.current_walk_frame())
                    )
                    return

                # -> run_v_pistol
                if state_machine.parameters[SM_V_AIMING] and state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        stack,
                        RunVPistolState.new()
                    )
                    return

        # Handles:
        # idling_c_pistol
        class IdlingCPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_IDLING_C_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, IdlingCPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idling_h_pistol
                if !state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        IdlingHPistolState.new(animations.current_animation_position)
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_c_pistol
                state_machine.transition(
                    [],
                    IdleCPistolState.new()
                )
                return

        # Handles:
        # idling_h_pistol
        class IdlingHPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_IDLING_H_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, IdlingHPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idling_c_pistol
                if state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        IdlingCPistolState.new(animations.current_animation_position)
                    )
                    return

                # -> idling_v_pistol
                if state_machine.parameters[SM_V_AIMING]:
                    state_machine.transition(
                        stack,
                        IdlingVPistolState.new(animations.current_animation_position)
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> run_h_pistol
                if state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        [],
                        RunHPistolState.new(state_machine.current_walk_frame())
                    )
                    return

                # -> idle_h_pistol
                state_machine.transition(
                    [],
                    IdleHPistolState.new()
                )
                return

        # Handles:
        # idling_v_pistol
        class IdlingVPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_IDLING_V_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, IdlingVPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idling_h_pistol
                if !state_machine.parameters[SM_V_AIMING]:
                    state_machine.transition(
                        stack,
                        IdlingHPistolState.new(animations.current_animation_position)
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> run_v_pistol
                if state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        [],
                        RunVPistolState.new(state_machine.current_walk_frame())
                    )
                    return

                # -> idle_v_pistol
                state_machine.transition(
                    [],
                    IdleVPistolState.new()
                )
                return

        # Handles:
        # fire_c_pistol
        class FiringCPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_FIRE_C_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, FiringCPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> fire_h_pistol
                if !state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        FiringHPistolState.new(animations.current_animation_position)
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idling_c_pistol
                state_machine.transition(
                    [],
                    IdlingCPistolState.new()
                )
                return

        # Handles:
        # fire_d_pistol
        class FiringDPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_FIRE_D_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, FiringDPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> fire_h_pistol
                if state_machine.parameters[SM_H_AIMING]:
                    state_machine.transition(
                        stack,
                        FiringHPistolState.new(animations.current_animation_position)
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_d_pistol
                state_machine.transition(
                    [],
                    IdleDPistolState.new()
                )
                return

        # Handles:
        # fire_h_pistol
        class FiringHPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_FIRE_H_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, FiringHPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> fire_c_pistol
                if state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        FiringCPistolState.new(animations.current_animation_position)
                    )
                    return

                # -> fire_v_pistol
                if state_machine.parameters[SM_V_AIMING]:
                    state_machine.transition(
                        stack,
                        FiringVPistolState.new(animations.current_animation_position)
                    )
                    return

                # -> idle_d_pistol
                if state_machine.parameters[SM_D_AIMING]:
                    state_machine.transition(
                        stack,
                        IdleDPistolState.new()
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idling_h_pistol
                state_machine.transition(
                    [],
                    IdlingHPistolState.new()
                )
                return

        # Handles:
        # fire_v_pistol
        class FiringVPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_FIRE_V_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, FiringVPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> fire_h_pistol
                if state_machine.parameters[SM_V_AIMING]:
                    state_machine.transition(
                        stack,
                        FiringHPistolState.new(animations.current_animation_position)
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idling_v_pistol
                state_machine.transition(
                    [],
                    IdlingVPistolState.new()
                )
                return

        # Handles:
        # jump_pistol
        class JumpPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_JUMP_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, JumpPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_d_pistol
                if state_machine.parameters[SM_AIR] and state_machine.parameters[SM_D_AIMING]:
                    state_machine.transition(
                        stack,
                        IdleDPistolState.new()
                    )
                    return

                # -> land_pistol
                if !state_machine.parameters[SM_AIR]:
                    state_machine.transition(
                        stack,
                        LandPistolState.new()
                    )
                    return

        # Handles:
        # land_pistol
        class LandPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_LAND_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, LandPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_d_pistol
                if state_machine.parameters[SM_AIR] and state_machine.parameters[SM_D_AIMING]:
                    state_machine.transition(
                        stack,
                        IdleDPistolState.new()
                    )
                    return

                # -> jump_pistol
                if state_machine.parameters[SM_AIR]:
                    state_machine.transition(
                        stack,
                        JumpPistolState.new()
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> run_c_pistol
                if state_machine.parameters[SM_CROUCHING] and state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        [],
                        RunCPistolState.new()
                    )
                    return

                # -> run_h_pistol
                if !state_machine.parameters[SM_CROUCHING] and state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        [],
                        RunHPistolState.new(state_machine.current_walk_frame())
                    )
                    return

                # -> idle_h_pistol
                state_machine.transition(
                    [],
                    IdleHPistolState.new()
                )
                return

        # Handles:
        # melee_pistol_c_1
        class MeleeC1PistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_MELEE_PISTOL_C_1

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, MeleeC1PistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_d_pistol
                if state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        IdleDPistolState.new(animations.current_animation_position)
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_c_pistol
                if state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        [],
                        IdleCPistolState.new()
                    )
                    return

                # -> idle_h_pistol
                if state_machine.parameters[SM_H_AIMING]:
                    state_machine.transition(
                        [],
                        IdleHPistolState.new()
                    )
                    return

                # -> idle_v_pistol
                if state_machine.parameters[SM_V_AIMING]:
                    state_machine.transition(
                        [],
                        IdleVPistolState.new()
                    )
                    return

        # Handles:
        # melee_pistol_h_1
        class MeleeH1PistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_MELEE_PISTOL_H_1

        # Handles:
        # melee_pistol_h_2
        class MeleeH2PistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_MELEE_PISTOL_H_2

        # Handles:
        # melee_pistol_h_3
        class MeleeH3PistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_MELEE_PISTOL_H_3

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, MeleeH3PistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> melee_pistol_c_1
                if state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        MeleeC1PistolState.new(animations.current_animation_position)
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_c_pistol
                if state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        [],
                        IdleCPistolState.new()
                    )
                    return

                # -> idle_h_pistol
                if state_machine.parameters[SM_H_AIMING]:
                    state_machine.transition(
                        [],
                        IdleHPistolState.new()
                    )
                    return

                # -> idle_v_pistol
                if state_machine.parameters[SM_V_AIMING]:
                    state_machine.transition(
                        [],
                        IdleVPistolState.new()
                    )
                    return

        # Handles:
        # melee_pistol_h_4
        class MeleeH4PistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_MELEE_PISTOL_H_4

        # Handles:
        # run_c_pistol
        class RunCPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_RUN_C_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, RunCPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> run_h_pistol
                if state_machine.parameters[SM_WALKING] and !state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        RunHPistolState.new()
                    )
                    return

                # -> idle_h_pistol
                if !state_machine.parameters[SM_WALKING] and !state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        IdleHPistolState.new()
                    )
                    return

                # -> idle_d_pistol
                if state_machine.parameters[SM_D_AIMING]:
                    state_machine.transition(
                        stack,
                        IdleDPistolState.new()
                    )
                    return

                # -> idle_c_pistol
                if state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        stack,
                        IdleCPistolState.new()
                    )
                    return

        # Handles:
        # run_h_pistol
        class RunHPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_RUN_H_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, RunHPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> run_c_pistol
                if state_machine.parameters[SM_WALKING] and state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        RunCPistolState.new()
                    )
                    return

                # -> idle_h_pistol
                if !state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        stack,
                        IdleHPistolState.new()
                    )
                    return

                # -> jump_pistol
                if state_machine.parameters[SM_AIR]:
                    state_machine.transition(
                        stack,
                        JumpPistolState.new()
                    )
                    return

                # -> idle_v_pistol
                if state_machine.parameters[SM_V_AIMING]:
                    state_machine.transition(
                        stack,
                        IdleVPistolState.new()
                    )
                    return

        # Handles:
        # run_v_pistol
        class RunVPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_RUN_V_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, RunVPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_v_pistol
                if state_machine.parameters[SM_V_AIMING] and state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        stack,
                        IdleVPistolState.new()
                    )
                    return

                # -> run_h_pistol
                if !state_machine.parameters[SM_V_AIMING] and state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        stack,
                        RunHPistolState.new()
                    )
                    return

        # Handles:
        # trans_hc_pistol
        class TransitionHCPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_TRANS_HC_PISTOL

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, TransitionHCPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_h_pistol
                if !state_machine.parameters[SM_CROUCHING]:
                    state_machine.transition(
                        stack,
                        IdleHPistolState.new()
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_c_pistol
                state_machine.transition(
                    [],
                    IdleCPistolState.new()
                )
                return

        # Handles:
        # trans_h_v
        class TransitionHVPistolState extends AnimationState:
            func get_animation_name() -> String:
                return ANIM_TRANS_H_V

            func apply_transitions(stack, state_machine):
                if !push_and_check(stack, TransitionHVPistolState, state_machine):
                    return

                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> run_h_pistol
                if state_machine.parameters[SM_WALKING] and state_machine.parameters[SM_H_AIMING]:
                    state_machine.transition(
                        stack,
                        RunHPistolState.new(state_machine.current_walk_frame())
                    )
                    return

                # -> idle_h_pistol
                if state_machine.parameters[SM_H_AIMING]:
                    state_machine.transition(
                        stack,
                        IdleHPistolState.new()
                    )
                    return

            func on_animation_finished(animation_name, state_machine):
                var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

                # -> idle_v_pistol
                if state_machine.parameters[SM_V_AIMING] and !state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        [],
                        IdleVPistolState.new()
                    )
                    return

                # -> run_v_pistol
                if state_machine.parameters[SM_V_AIMING] and state_machine.parameters[SM_WALKING]:
                    state_machine.transition(
                        [],
                        RunVPistolState.new()
                    )
                    return
        """#).diff(result)
        */
    }
}

// MARK: Test internals

private func makeSut() -> GDScriptCodeGen {
    return GDScriptCodeGen()
}
