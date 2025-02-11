class_name BigEnemy extends CharacterBody2D

static var texture32 = preload("res://Textures/blob32.png")
static var texture64 = preload("res://Textures/blob64.png")
static var texture128 = preload("res://Textures/blob128.png")

static var radius32 = 13
static var radius64 = 29
static var radius128 = 55

static var props = {
    32: {
        "texture": texture32,
        "radius": radius32
    },
    64: {
        "texture": texture64,
        "radius": radius64
    },
    128: {
        "texture": texture128,
        "radius": radius128
    },
}

const SPEED: float = 200.0
@onready var player: Player = $/root/Game/Player
var size: int = 32

func _physics_process(_delta: float) -> void:
    var direction = (player.global_position - global_position).normalized()
    velocity = direction * SPEED
    move_and_slide()
    
func setup(given_size: int) -> void:
    size = given_size
    var prop = props[size]
    $Sprite2D.texture = prop.texture
    $CollisionShape2D.shape.radius = prop.radius

func hit(bubble_size: float) -> void:
    if bubble_size >= size:
        queue_free()
    
