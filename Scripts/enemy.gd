class_name Enemy extends CharacterBody2D

@onready var player: Player = $/root/Game/Player

func _ready() -> void:
    tree_exiting.connect(_on_tree_existing)

func _physics_process(delta: float) -> void:
    var direction = (player.global_position - global_position).normalized()
    velocity = direction * Constants.enemy_speed
    var collision = move_and_collide(velocity * delta)
    if collision:
        if collision.get_collider().is_in_group("player"):
            print("die")
        else:
            var normal = collision.get_normal()
            velocity = velocity.slide(normal)
            move_and_collide(velocity * delta)
        
func _on_tree_existing() -> void:
    if get_tree().get_nodes_in_group("enemies").size() <= 1:
        $/root/Game/SpawnEnemies.spawn()
