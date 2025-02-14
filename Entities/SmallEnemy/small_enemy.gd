class_name SmallEnemy extends Enemy
    
func setup(_size: int):
    pass

func hit(_bubble_size: float) -> void:
    queue_free()
