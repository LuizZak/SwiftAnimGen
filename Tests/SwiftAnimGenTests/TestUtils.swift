import Foundation

func makeDummyJsonData() -> Data {
    return makeDummyJson().data(using: .utf8)!
}

func makeDummyJson() -> String {
    return #"""
    {
        "options": {
            "animation_name_kind": "constant"
        },
        "constants": {
            "state_machine": [
                { "SM_AIR": "air" },
                { "SM_CROUCHING": "crouching" },
                { "SM_H_AIMING": "h_aiming" },
                { "SM_D_AIMING": "d_aiming" },
                { "SM_V_AIMING": "v_aiming" },
                { "SM_WALKING": "walking" },
                { "SM_RIFLE": "rifle" }
            ],
            "animation_names": [
                { "ANIM_FIRE_C_RIFLE_MACHINEGUN": "fire_c_rifle_machinegun" },
                { "ANIM_FIRE_D_RIFLE_MACHINEGUN": "fire_d_rifle_machinegun" },
                { "ANIM_FIRE_H_RIFLE_MACHINEGUN": "fire_h_rifle_machinegun" },
                { "ANIM_FIRE_V_RIFLE_MACHINEGUN": "fire_v_rifle_machinegun" },

                { "ANIM_IDLE_C_RIFLE": "idle_c_rifle" },
                { "ANIM_IDLE_D_RIFLE": "idle_d_rifle" },
                { "ANIM_IDLE_H_RIFLE": "idle_h_rifle" },
                { "ANIM_IDLE_V_RIFLE": "idle_v_rifle" },

                { "ANIM_JUMP_RIFLE": "jump_rifle" },
                { "ANIM_LAND_RIFLE": "land_rifle" },

                { "ANIM_MELEE_RIFLE_H": "melee_rifle_h" },
                { "ANIM_MELEE_RIFLE_C": "melee_rifle_c" },

                { "ANIM_RUN_C_RIFLE": "run_c_rifle" },
                { "ANIM_RUN_H_RIFLE": "run_h_rifle" },
                { "ANIM_RUN_V_RIFLE": "run_v_rifle" },

                { "ANIM_TRANS_H_V_RIFLE": "trans_h_v_rifle" },
                { "ANIM_TRANS_H_D_RIFLE": "trans_h_d_rifle" },
                { "ANIM_TRANS_HC_RIFLE": "trans_hc_rifle" }
            ]
        },
        "states": [
            {
                "name": "IdleCPistolState",
                "animation_name": "ANIM_IDLE_C_PISTOL",
                "transitions": [
                    { "state": "RunCPistolState", "conditions": ["SM_WALKING"] },
                    { "state": "IdleHPistolState", "conditions": ["!SM_CROUCHING"], "options": { "initializer": ".new(animations.current_animation_position)" } }
                ]
            },
            {
                "name": "IdleDPistolState",
                "animation_name": "ANIM_IDLE_D_PISTOL",
                "transitions": [
                    { "state": "IdleHPistolState", "conditions": ["SM_H_AIMING"] }
                ]
            },
            {
                "name": "IdleHPistolState",
                "animation_name": "ANIM_IDLE_H_PISTOL",
                "transitions": [
                    { "state": "IdleDPistolState", "conditions": ["SM_D_AIMING"] },
                    { "state": "RunHPistolState", "conditions": ["SM_WALKING"] },
                    { "state": "TransitionHVPistolState", "conditions": ["SM_V_AIMING"] },
                    { "state": "TransitionHCPistolState", "conditions": ["SM_CROUCHING"] },
                    { "state": "JumpPistolState", "conditions": ["SM_AIR"] }
                ]
            },
            {
                "name": "IdleVPistolState",
                "animation_name": "ANIM_IDLE_V_PISTOL",
                "transitions": [
                    { "state": "IdleDPistolState", "conditions": ["SM_H_AIMING"], "options": { "initializer": ".new(animations.current_animation_position)" } },
                    { "state": "RunHPistolState", "conditions": ["SM_WALKING", "!SM_V_AIMING"], "options": { "initializer": ".new(state_machine.current_walk_frame())" } },
                    { "state": "RunVPistolState", "conditions": ["SM_V_AIMING", "SM_WALKING"] }
                ]
            },


            {
                "name": "IdlingCPistolState",
                "animation_name": "ANIM_IDLING_C_PISTOL",
                "transitions": [
                    { "state": "IdlingHPistolState", "conditions": ["!SM_CROUCHING"], "options": { "initializer": ".new(animations.current_animation_position)" } }
                ],
                "on_end": [
                    { "state": "IdleCPistolState" }
                ]
            },
            {
                "name": "IdlingHPistolState",
                "animation_name": "ANIM_IDLING_H_PISTOL",
                "transitions": [
                    { "state": "IdlingCPistolState", "conditions": ["SM_CROUCHING"], "options": { "initializer": ".new(animations.current_animation_position)" } },
                    { "state": "IdlingVPistolState", "conditions": ["SM_V_AIMING"], "options": { "initializer": ".new(animations.current_animation_position)" } }
                ],
                "on_end": [
                    { "state": "RunHPistolState", "conditions": ["SM_WALKING"], "options": { "initializer": ".new(state_machine.current_walk_frame())" } },
                    { "state": "IdleHPistolState" }
                ]
            },
            {
                "name": "IdlingVPistolState",
                "animation_name": "ANIM_IDLING_V_PISTOL",
                "transitions": [
                    { "state": "IdlingHPistolState", "conditions": ["!SM_V_AIMING"], "options": { "initializer": ".new(animations.current_animation_position)" } }
                ],
                "on_end": [
                    { "state": "RunVPistolState", "conditions": ["SM_WALKING"], "options": { "initializer": ".new(state_machine.current_walk_frame())" } },
                    { "state": "IdleVPistolState" }
                ]
            },


            {
                "name": "FiringCPistolState",
                "animation_name": "ANIM_FIRE_C_PISTOL",
                "transitions": [
                    { "state": "FiringHPistolState", "conditions": ["!SM_CROUCHING"], "options": { "initializer": ".new(animations.current_animation_position)" } }
                ],
                "on_end": [
                    { "state": "IdlingCPistolState" }
                ]
            },
            {
                "name": "FiringDPistolState",
                "animation_name": "ANIM_FIRE_D_PISTOL",
                "transitions": [
                    { "state": "FiringHPistolState", "conditions": ["SM_H_AIMING"], "options": { "initializer": ".new(animations.current_animation_position)" } }
                ],
                "on_end": [
                    { "state": "IdleDPistolState" }
                ]
            },
            {
                "name": "FiringHPistolState",
                "animation_name": "ANIM_FIRE_H_PISTOL",
                "transitions": [
                    { "state": "FiringCPistolState", "conditions": ["SM_CROUCHING"], "options": { "initializer": ".new(animations.current_animation_position)" } },
                    { "state": "FiringVPistolState", "conditions": ["SM_V_AIMING"], "options": { "initializer": ".new(animations.current_animation_position)" } },
                    { "state": "IdleDPistolState", "conditions": ["SM_D_AIMING"] }
                ],
                "on_end": [
                    { "state": "IdlingHPistolState" }
                ]
            },
            {
                "name": "FiringVPistolState",
                "animation_name": "ANIM_FIRE_V_PISTOL",
                "transitions": [
                    { "state": "FiringHPistolState", "conditions": ["SM_V_AIMING"], "options": { "initializer": ".new(animations.current_animation_position)" } }
                ],
                "on_end": [
                    { "state": "IdlingVPistolState" }
                ]
            },


            {
                "name": "JumpPistolState",
                "animation_name": "ANIM_JUMP_PISTOL",
                "transitions": [
                    { "state": "IdleDPistolState", "conditions": ["SM_AIR", "SM_D_AIMING"] },
                    { "state": "LandPistolState", "conditions": ["!SM_AIR"] }
                ]
            },
            {
                "name": "LandPistolState",
                "animation_name": "ANIM_LAND_PISTOL",
                "transitions": [
                    { "state": "IdleDPistolState", "conditions": ["SM_AIR", "SM_D_AIMING"] },
                    { "state": "JumpPistolState", "conditions": ["SM_AIR"] }
                ],
                "on_end": [
                    { "state": "RunCPistolState", "conditions": ["SM_CROUCHING", "SM_WALKING"] },
                    { "state": "RunHPistolState", "conditions": ["!SM_CROUCHING", "SM_WALKING"], "options": { "initializer": ".new(state_machine.current_walk_frame())" } },
                    { "state": "IdleHPistolState" }
                ]
            },


            {
                "name": "MeleeC1PistolState",
                "animation_name": "ANIM_MELEE_PISTOL_C_1",
                "transitions": [
                    { "state": "IdleDPistolState", "conditions": ["SM_CROUCHING"], "options": { "initializer": ".new(animations.current_animation_position)" } }
                ],
                "on_end": [
                    { "state": "IdleCPistolState", "conditions": ["SM_CROUCHING"] },
                    { "state": "IdleHPistolState", "conditions": ["SM_H_AIMING"] },
                    { "state": "IdleVPistolState", "conditions": ["SM_V_AIMING"] }
                ]
            },
            {
                "name": "MeleeH1PistolState",
                "animation_name": "ANIM_MELEE_PISTOL_H_1"
            },
            {
                "name": "MeleeH2PistolState",
                "animation_name": "ANIM_MELEE_PISTOL_H_2"
            },
            {
                "name": "MeleeH3PistolState",
                "animation_name": "ANIM_MELEE_PISTOL_H_3",
                "transitions": [
                    { "state": "MeleeC1PistolState", "conditions": ["SM_CROUCHING"], "options": { "initializer": ".new(animations.current_animation_position)" } }
                ],
                "on_end": [
                    { "state": "IdleCPistolState", "conditions": ["SM_CROUCHING"] },
                    { "state": "IdleHPistolState", "conditions": ["SM_H_AIMING"] },
                    { "state": "IdleVPistolState", "conditions": ["SM_V_AIMING"] }
                ]
            },
            {
                "name": "MeleeH4PistolState",
                "animation_name": "ANIM_MELEE_PISTOL_H_4"
            },


            {
                "name": "RunCPistolState",
                "animation_name": "ANIM_RUN_C_PISTOL",
                "transitions": [
                    { "state": "RunHPistolState", "conditions": ["SM_WALKING", "!SM_CROUCHING"] },
                    { "state": "IdleHPistolState", "conditions": ["!SM_WALKING", "!SM_CROUCHING"] },
                    { "state": "IdleDPistolState", "conditions": ["SM_D_AIMING"] },
                    { "state": "IdleCPistolState", "conditions": ["SM_WALKING"] }
                ]
            },
            {
                "name": "RunHPistolState",
                "animation_name": "ANIM_RUN_H_PISTOL",
                "transitions": [
                    { "state": "RunCPistolState", "conditions": ["SM_WALKING", "SM_CROUCHING"] },
                    { "state": "IdleHPistolState", "conditions": ["!SM_WALKING"] },
                    { "state": "JumpPistolState", "conditions": ["SM_AIR"] },
                    { "state": "IdleVPistolState", "conditions": ["SM_V_AIMING"] }
                ]
            },
            {
                "name": "RunVPistolState",
                "animation_name": "ANIM_RUN_V_PISTOL",
                "transitions": [
                    { "state": "IdleVPistolState", "conditions": ["SM_V_AIMING", "SM_WALKING"] },
                    { "state": "RunHPistolState", "conditions": ["!SM_V_AIMING", "SM_WALKING"] }
                ]
            },

            
            {
                "name": "TransitionHCPistolState",
                "animation_name": "ANIM_TRANS_HC_PISTOL",
                "transitions": [
                    { "state": "IdleHPistolState", "conditions": ["!SM_CROUCHING"] }
                ],
                "on_end": [
                    { "state": "IdleCPistolState" }
                ]
            },
            {
                "name": "TransitionHVPistolState",
                "animation_name": "ANIM_TRANS_H_V",
                "transitions": [
                    { "state": "RunHPistolState", "conditions": ["SM_WALKING", "SM_H_AIMING"], "options": { "initializer": ".new(state_machine.current_walk_frame())" } },
                    { "state": "IdleHPistolState", "conditions": ["SM_H_AIMING"] }
                ],
                "on_end": [
                    { "state": "IdleVPistolState", "conditions": ["SM_V_AIMING", "!SM_WALKING"] },
                    { "state": "RunVPistolState", "conditions": ["SM_V_AIMING", "SM_WALKING"] }
                ]
            }
        ]
    }
    """#
}
