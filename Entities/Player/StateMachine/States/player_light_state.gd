class_name PlayerLightState extends State

func _process(host: Player, delta: float):
    host.spawn_enemies.tutorial(1)
    if host.meter > 0:
        host.deplete_meter(delta)
    else:
        PlayerStateMachine.change_state(host, PlayerStateMachine.PlayerStateEnum.STAND)
        return
    host.small_bubble_timer += delta
    var interval = 1.0 / Constants.small_bubbles_per_second
    var operations_needed = floor(host.small_bubble_timer / interval)
    host.small_bubble_timer = fmod(host.small_bubble_timer, interval)
    var bubble_direction = host.get_bubble_direction()
    var bubble_position = host.get_bubble_position()
    while operations_needed > 0:
        var small_bubble = host.small_bubble_scene.instantiate()
        small_bubble.direction = bubble_direction
        small_bubble.global_position = bubble_position
        host.get_parent().add_child(small_bubble)
        operations_needed -= 1

func _input(host: Player, event: InputEvent) -> void:
    if event is InputEventMouseButton && !event.pressed && event.button_index == MOUSE_BUTTON_LEFT: 
        PlayerStateMachine.change_state(host, PlayerStateMachine.PlayerStateEnum.STAND)
