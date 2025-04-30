# SwiftAnimGen

A GDScript-generating animation state machine that serves as a replacement to Godot's AnimationTree-powered AnimationNodeStateMachine.

## Usage

The generated code requires the following boilerplate base code:

```gdscript
class_name AnimationStateMachine
extends Object

## Type: AnimationPlayer
const SM_ANIMATIONS = "animations"

var parameters: Dictionary = { }

var current_state: AnimationState = null

func transition(stack: Array, new_state: AnimationState):
    if current_state != null:
        current_state.on_exit(new_state, self)

    var old_state = current_state
    current_state = new_state

    if new_state != null:
        new_state.on_enter(old_state, self)
        new_state.apply_transitions(stack, self)

func apply_transitions():
    if current_state != null:
        current_state.apply_transitions([], self)

class AnimationState:
    var time: float = -1.0
    var reset: bool = false
    var reset_on_exit: bool = true
    func _init(t: float = -1.0, reset: bool = false, reset_on_exit: bool = true):
        self.time = t
        self.reset = reset
        self.reset_on_exit = reset_on_exit

    func get_animation_name() -> String:
        push_error("Must be overridden by subclasses")
        return ""

    func on_enter(last: AnimationState, state_machine: AnimationStateMachine):
        var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer
        if animations.current_animation == get_animation_name():
            if reset:
                animations.seek(maxf(time, 0.0), true)
                animations.advance(0)
        else:
            animations.play(get_animation_name())
            if time > 0.0:
                animations.seek(time, true)
            animations.advance(0)

        animations.animation_finished.connect(
            func(anim_name):
                if state_machine.current_state == self:
                    on_animation_finished(anim_name, state_machine)
        )

    func on_exit(next: AnimationState, state_machine: AnimationStateMachine):
        if reset_on_exit:
            var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer
            animations.play("RESET")
            animations.advance(0)

    func on_animation_finished(animation_name: String, state_machine: AnimationStateMachine):
        pass

    func apply_transitions(stack: Array, state_machine: AnimationStateMachine):
        pass

    func push_and_check(stack: Array, type: Variant, state_machine: AnimationStateMachine) -> bool:
        for state in stack:
            if is_instance_of(state, type):
                var anim_names = ""
                for item in stack:
                    anim_names += " " + item.get_animation_name()

                push_error("Found infinite loop during transitions: %s %s with parameters %s" % [anim_names, stack, state_machine.parameters])
                return false

        stack.append(self)

        return true
```

And an animation JSON file:

```json
{
    "class_name": "ExampleAnimationStateMachine",
    "options": {
        "animation_name_kind": "constant"
    },
    "constants": {
        "state_machine": [
            { "constant": { "SM_CROUCHING": "crouching" }, "type": "bool", "setter_name": "set_crouching" },
            { "constant": { "SM_WALKING": "walking" }, "type": "bool", "setter_name": "set_walking" },
            { "constant": { "SM_ON_AIR": "on_air" }, "type": "bool", "setter_name": "set_on_air" }
        ],
        "animation_names": [
            { "ANIM_IDLE": "idle" },
            { "ANIM_CROUCH": "crouch" },
            { "ANIM_RUN": "run" },
            { "ANIM_JUMP": "jump" }
        ]
    },
    "entry_points": [
        { "name": "IdleState" },
        { "name": "CrouchState" },
        { "name": "RunState" },
        { "name": "JumpState" }
    ],
    "states": [
        {
            "name": "IdleState",
            "description": "Idle, not running",
            "animation_name": "ANIM_IDLE",
            "transitions": [
                { "state": "RunState", "conditions": "SM_WALKING" },
                { "state": "CrouchState", "conditions": "SM_CROUCHING" }
            ]
        },
        {
            "name": "CrouchState",
            "description": "Crouching, not running",
            "animation_name": "ANIM_CROUCH",
            "transitions": [
                { "state": "IdleState", "conditions": "!SM_CROUCHING" }
            ]
        },
        {
            "name": "RunState",
            "description": "Run state",
            "animation_name": "ANIM_RUN",
            "transitions": [
                { "state": "IdleState", "conditions": "!SM_WALKING" }
            ]
        },
        {
            "name": "JumpState",
            "description": "On air",
            "animation_name": "ANIM_JUMP",
            "transitions": [
                { "state": "IdleState", "conditions": "!SM_ON_AIR" }
            ],
            "on_end": [
                { "state": "IdleState" }
            ]
        }
    ]
}

```

Running the program with the command line as such:

```bash
swift run SwiftAnimGen 'path/to/animations.json'
```

Produces the following output in the command line:

```gdscript
class_name ExampleAnimationStateMachine
extends AnimationStateMachine

#region State Machine Constants

# Type: bool
const SM_CROUCHING = "crouching"
# Type: bool
const SM_WALKING = "walking"
# Type: bool
const SM_ON_AIR = "on_air"

#endregion

#region Animation Name Constants

const ANIM_IDLE = "idle"
const ANIM_CROUCH = "crouch"
const ANIM_RUN = "run"
const ANIM_JUMP = "jump"

#endregion

func set_crouching(value: bool):
    parameters[SM_CROUCHING] = value

func set_walking(value: bool):
    parameters[SM_WALKING] = value

func set_on_air(value: bool):
    parameters[SM_ON_AIR] = value

#region Entry Points

func transition_idleState():
    transition([], IdleState.new(0.0, true))

func transition_crouchState():
    transition([], CrouchState.new(0.0, true))

func transition_runState():
    transition([], RunState.new(0.0, true))

func transition_jumpState():
    transition([], JumpState.new(0.0, true))

#endregion

# Idle, not running
# Handles:
# idle
class IdleState extends AnimationState:
    func get_animation_name() -> String:
        return ANIM_IDLE

    func apply_transitions(stack, state_machine):
        if !push_and_check(stack, IdleState, state_machine):
            return

        var animations = state_machine.parameters[SM_ANIMATIONS] as AnimationPlayer

        # -> run
        if state_machine.parameters[SM_WALKING]:
            state_machine.transition(
                stack,
                RunState.new()
            )
            return

        # -> crouch
        if state_machine.parameters[SM_CROUCHING]:
            state_machine.transition(
                stack,
                CrouchState.new()
            )
            return

# [...]
```

Animation state machines can be used as such:

```gdscript
# Setup and initial state
var state_machine = ExampleAnimationStateMachine.new()

state_machine.set_crouching(false)
state_machine.set_on_air(false)
state_machine.set_walking(false)

state_machine.transition_idleState()

# On _process call:

state_machine.set_crouching(my_character.is_crouching)
state_machine.set_on_air(my_character.body.is_on_floor())
state_machine.set_walking(my_character.is_walking)

# Instantly applies the appropriate transitions, stopping
# when no more states need switching, or when it detects
# an infinite loop
state_machine.apply_transitions()
```
