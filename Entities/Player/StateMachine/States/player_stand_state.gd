class_name PlayerStandState extends State

const FILL_RATE: float = 0.5

func _input(host: Player, event: InputEvent) -> void:
    if event is InputEventMouseButton && event.pressed: 
        if event.button_index == MOUSE_BUTTON_LEFT:
            PlayerStateMachine.change_state(host, PlayerStateMachine.PlayerStateEnum.LIGHT)
        if event.button_index == MOUSE_BUTTON_RIGHT:
            PlayerStateMachine.change_state(host, PlayerStateMachine.PlayerStateEnum.HEAVY)

func _process(host: Player, delta: float):
    if host.meter < host.MAX_METER:
        host.meter += FILL_RATE * delta
