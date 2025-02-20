class_name PlayerHeavyState extends State

func enter(host: Player):
    host.play_sound(host.heavy_sound)
    host.big_bubble = host.big_bubble_scene.instantiate()
    host.add_child(host.big_bubble)
    host.animation_player.play("Big")

func exit(host: Player):
    host.stop_sound()
    host.stop()
    
func _process(host: Player, delta: float):
    host.spawn_enemies.tutorial(2)
    host.big_bubble.global_position = host.get_bubble_position()
    host.big_bubble.direction = host.get_bubble_direction()
    
    if host.meter > 0:
        host.deplete_meter(delta)
    else:
        PlayerStateMachine.change_state(host, PlayerStateMachine.PlayerStateEnum.STAND)

func _input(host: Player, event: InputEvent) -> void:
    if event is InputEventMouseButton && !event.pressed && event.button_index == MOUSE_BUTTON_RIGHT: 
        PlayerStateMachine.change_state(host, PlayerStateMachine.PlayerStateEnum.STAND)
