extends CharacterBody2D

const SPEED = 200.0
@onready var player: Player = $/root/Game/Player

func _physics_process(delta: float) -> void:
    var direction = (player.global_position - global_position).normalized()
    velocity = direction * SPEED
    var collision = move_and_collide(velocity * delta)
