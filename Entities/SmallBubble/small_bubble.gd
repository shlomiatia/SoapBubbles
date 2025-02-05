class_name SmallBubble extends CharacterBody2D

const SPEED: float = 200.0
const DECELERATION: float = 20.0
const LIFETIME: float = 4.0
const SPREAD: float = 5.0

var direction: Vector2

func _ready() -> void:
    var random_angle = deg_to_rad(randf_range(-SPREAD, SPREAD))
    direction = direction.rotated(random_angle)
    velocity = SPEED * direction
    await get_tree().create_timer(LIFETIME).timeout
    die()

func _physics_process(delta: float) -> void:
    velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
    var collision = move_and_collide(velocity * delta)
    if collision != null:
        die()
        collision.get_collider().die()
        
func die():
    queue_free()
