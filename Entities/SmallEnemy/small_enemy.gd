class_name SmallEnemy extends CharacterBody2D

const SPEED: float = 200.0
@onready var player: Player = $/root/Game/Player

func _physics_process(_delta: float) -> void:
    var direction = (player.global_position - global_position).normalized()
    velocity = direction * SPEED
    move_and_slide()
    
func setup(_size: int):
    pass

func hit(_bubble_size: float) -> void:
    queue_free()
    
