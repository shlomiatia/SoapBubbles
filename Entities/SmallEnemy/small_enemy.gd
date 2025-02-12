class_name SmallEnemy extends CharacterBody2D

@onready var player: Player = $/root/Game/Player

func _physics_process(delta: float) -> void:
    var direction = (player.global_position - global_position).normalized()
    velocity = direction * Constants.enemy_speed
    var collision = move_and_collide(velocity * delta)
    if collision:
        var normal = collision.get_normal()
        velocity = velocity.slide(normal)
        move_and_collide(velocity * delta)
    
func setup(_size: int):
    pass

func hit(_bubble_size: float) -> void:
    queue_free()
    
