class_name BigEnemy extends Enemy

static var texture32 = preload("res://Textures/blob32.png")
static var texture64 = preload("res://Textures/blob64.png")
static var texture128 = preload("res://Textures/blob128.png")

static var radius32 = 13
static var radius64 = 29
static var radius128 = 55
 
static var props = {
    32: {
        "texture": texture32,
        "radius": radius32,
    },
    64: {
        "texture": texture64,
        "radius": radius64,
    },
    128: {
        "texture": texture128,
        "radius": radius128,
    },
}

var size: int
    
func setup(given_size: int) -> void:
    size = given_size
    var prop = props[size]
    var sprite2d: Sprite2D = $Sprite2D
    sprite2d.texture = prop.texture
    @warning_ignore("integer_division")
    sprite2d.position = Vector2(0.0, given_size / 2)
    @warning_ignore("integer_division")
    sprite2d.offset = Vector2(0, -given_size / 2)
    $CollisionShape2D.shape.radius = prop.radius

func hit(bubble_size: float, vector: Vector2) -> void:
    if bubble_size >= size:
        velocity = vector * bubble_size
        die()
        
func die():
    var animation_player: AnimationPlayer = $AnimationPlayer
    collision_shape.disabled = true
    animation_player.play("Dead")
    player.enemy_died(size)
    animation_player.animation_finished.connect(func (_anim): queue_free())
        
