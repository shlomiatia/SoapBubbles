class_name BigBubble extends CharacterBody2D

var direction: Vector2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite2d: Sprite2D = $Sprite2D

func _ready() -> void:
    animation_player.connect("animation_finished", move)

func _physics_process(delta: float) -> void:
    if velocity != Vector2.ZERO:
        velocity = velocity.move_toward(Vector2.ZERO, Constants.bubble_deceleration * delta)
        var collision = move_and_collide(velocity * delta)
        if collision != null:
            die()
            collision.get_collider().hit(get_size())

func stop() -> void:
    if animation_player.is_playing():
        animation_player.pause()
        move("")

func move(_anim_name: String) -> void:
    get_parent().stop()
    if get_size() < 16:
        die()
        return
    var game = get_parent().get_parent()
    reparent(game, true)
    velocity = Constants.bubble_speed * direction
    await get_tree().create_timer(Constants.bubble_lifetime).timeout
    die()

func die() -> void:
    queue_free()

func get_size() -> float:
    return sprite2d.scale.x * 128
