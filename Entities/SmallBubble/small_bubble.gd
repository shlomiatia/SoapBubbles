class_name SmallBubble extends CharacterBody2D

var direction: Vector2

func _ready() -> void:
    var random_angle = deg_to_rad(randf_range(-Constants.small_bubble_spred, Constants.small_bubble_spred))
    direction = direction.rotated(random_angle)
    velocity = Constants.bubble_speed * direction
    await get_tree().create_timer(Constants.bubble_lifetime).timeout
    die()

func _physics_process(delta: float) -> void:
    velocity = velocity.move_toward(Vector2.ZERO, Constants.bubble_deceleration * delta)
    var collision = move_and_collide(velocity * delta)
    if collision != null:
        die()
        collision.get_collider().hit(16.0)
        
func die():
    queue_free()
