class_name SmallEnemy extends Enemy
    
func setup(_size: int):
    pass

func hit(_bubble_size: float, _vector: Vector2) -> void:
    player.enemy_died(16)
    queue_free()
    
func die() -> void:
    queue_free()
