class_name BigBubble extends CharacterBody2D

var direction: Vector2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite2d: AnimatedSprite2D = $Sprite2D
@onready var player: Player = $/root/Game/Player

func _ready() -> void:
    animation_player.animation_finished.connect(move)
    
func _physics_process(delta: float) -> void:
    if velocity != Vector2.ZERO:
        velocity = velocity.move_toward(Vector2.ZERO, Constants.bubble_deceleration * delta)
        var collision = move_and_collide(velocity * delta)
        if collision != null:
            collision.get_collider().hit(get_size(), collision.get_normal())
            die()

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
    $CollisionShape2D.disabled = true
    sprite2d.play("pop")
    sprite2d.animation_finished.connect(func (): queue_free())
    player.play_random_pop_sound(global_position)

func get_size() -> float:
    return sprite2d.scale.x * 128
