class_name PlayerStandState extends State

func _input(host: Player, event: InputEvent) -> void:
    if event is InputEventMouseButton && event.pressed: 
        if event.button_index == MOUSE_BUTTON_LEFT:
            host.spawn_enemies.tutorial(1)
            PlayerStateMachine.change_state(host, PlayerStateMachine.PlayerStateEnum.LIGHT)
        if event.button_index == MOUSE_BUTTON_RIGHT:
            host.spawn_enemies.tutorial(2)
            PlayerStateMachine.change_state(host, PlayerStateMachine.PlayerStateEnum.HEAVY)

func _process(host: Player, delta: float):
    if host.meter < host.MAX_METER:
        host.set_meter(host.meter + Constants.meter_fill_rate * delta)
