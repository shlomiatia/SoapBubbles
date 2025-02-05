class_name PlayerHeavyState extends State

func enter(host: Player):
    host.big_bubble = host.big_bubble_scene.instantiate()
    host.add_child(host.big_bubble)

func exit(host: Player):
    host.stop()
    
func _process(host: Player, delta: float):        
    host.big_bubble.global_position = host.get_bubble_position()
    host.big_bubble.direction = host.get_bubble_direction()
    
    if host.meter > 0:
        host.deplete_meter(delta)
    else:
        PlayerStateMachine.change_state(host, PlayerStateMachine.PlayerStateEnum.STAND)
