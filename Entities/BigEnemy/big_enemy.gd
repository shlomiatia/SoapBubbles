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

var size: int
    
func setup(given_size: int) -> void:
    size = given_size
    var prop = props[size]
    var sprite2d: Sprite2D = $Sprite2D
    sprite2d.texture = prop.texture
    sprite2d.position = Vector2(0.0, given_size / 2)
    sprite2d.offset = Vector2(0, -given_size / 2)
    $CollisionShape2D.shape.radius = prop.radius

func hit(bubble_size: float) -> void:
    if bubble_size >= size:
        queue_free()
        
