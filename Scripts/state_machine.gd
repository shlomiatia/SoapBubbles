class_name StateMachine extends Node

var states: Dictionary = {}

func _init(states: Dictionary) -> void:
    self.states = states

func get_current(host: Node) -> State:
    return states[host.current_state_id]

func change_state(host: Node, state_id: int) -> void:
    if host.current_state_id != null:
        get_current(host).exit(host)
    
    host.current_state_id = state_id
    get_current(host).enter(host)
