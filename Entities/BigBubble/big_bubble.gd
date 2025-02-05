class_name BigBubble extends CharacterBody2D

const SPEED = 150
const DECELERATION = 20

var direction: Vector2 = Vector2(1.0, 0.0)
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite2d: Sprite2D = $Sprite2D

func _ready() -> void:
    animation_player.connect("animation_finished", move)

func stop() -> void:
    if animation_player.is_playing():
        animation_player.pause()
        move("")

func move(_anim_name: String) -> void:
    get_parent().stop()
    if sprite2d.scale.x * 128 < 16:
        die()
        return
    var game = get_parent().get_parent()
    reparent(game, true)
    velocity = SPEED * direction
    await get_tree().create_timer(4).timeout
    die()

func die() -> void:
    queue_free()

func _physics_process(delta: float) -> void:
    if velocity != Vector2.ZERO:
        velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
        move_and_slide()
