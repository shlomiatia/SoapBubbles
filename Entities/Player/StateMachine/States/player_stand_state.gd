class_name PlayerStandState extends State

func _input(host: Player, event: InputEvent) -> void:
    if event is InputEventMouseButton && event.pressed: 
        if event.button_index == MOUSE_BUTTON_LEFT:
            PlayerStateMachine.change_state(host, PlayerStateMachine.PlayerStateEnum.LIGHT)
        if event.button_index == MOUSE_BUTTON_RIGHT:
            PlayerStateMachine.change_state(host, PlayerStateMachine.PlayerStateEnum.HEAVY)

func _process(host: Player, delta: float):
    if host.meter < host.MAX_METER:
        host.set_meter(host.meter + Constants.meter_fill_rate * delta)
