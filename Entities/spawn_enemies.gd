extends Node2D

var small_enemy_scene: PackedScene = preload("res://Entities/SmallEnemy/SmallEnemy.tscn")
var big_enemy_scene: PackedScene = preload("res://Entities/BigEnemy/BigEnemy.tscn")
var camera: Camera2D

var enemy_props: Dictionary = {
    "small": {
        "scene": small_enemy_scene,
        "size": 20
    },
    "medium": {
        "scene": big_enemy_scene,
        "size": 32
    },
    "large": {
        "scene": big_enemy_scene,
        "size": 64
    },
    "x-large": {
        "scene": big_enemy_scene,
        "size": 128
    },
}

func _ready() -> void:
    camera = $/root/Game/Player/Camera2D
    var timer: Timer = $Timer
    timer.timeout.connect(_on_spawn_timer_timeout)
    
func _on_spawn_timer_timeout() -> void:
    spawn_objects_outside_viewport()

func spawn_objects_outside_viewport():
    var viewport_size = get_viewport_rect().size
    var camera_pos = camera.global_position
    
    var size_props = {
        "left": {
            "center": Vector2(camera_pos.x - viewport_size.x / 2.0, camera_pos.y),
            "back_vector": Vector2(-1.0, 0.0),
            "side_size": viewport_size.y
        },
        "right": {
            "center": Vector2(camera_pos.x + viewport_size.x / 2.0, camera_pos.y),
            "back_vector": Vector2(1.0, 0.0),
            "side_size": viewport_size.y
        },
        "top": {
            "center": Vector2(camera_pos.x, camera_pos.y - viewport_size.y / 2.0),
            "back_vector": Vector2(0.0, -1.0),
            "side_size": viewport_size.x
        },
        "bottom": {
            "center": Vector2(camera_pos.x, camera_pos.y + viewport_size.y / 2.0),
            "back_vector": Vector2(0.0, 1.0),
            "side_size": viewport_size.x
        }
    }
    
    var init_props: Dictionary = {
        "back_multiplier": 1.0, 
        "side_multiplier": 0.0
    }

    spawn(10, enemy_props["small"], size_props["left"], init_props)

    spawn(1, enemy_props["x-large"], size_props["left"], init_props)
    
    
func spawn(count: int, enemy_prop: Dictionary, size_props: Dictionary, init_props: Dictionary):
    var enemy_scene: PackedScene = enemy_prop["scene"]
    var back_size: float = enemy_prop["size"]
    var center: Vector2 = size_props["center"]
    prints("center", center)
    var back_vector: Vector2 = size_props["back_vector"]
    var back_space: float = back_size * init_props["back_multiplier"]
    var side_vector: Vector2 = back_vector.orthogonal().abs()
    var side_space: float = init_props["side_multiplier"] * size_props["side_size"] / count
    var last_position
    for i in count:
        var instance = enemy_scene.instantiate()
        instance.setup(back_size)
        get_parent().add_child(instance)
        var side_sign = 1
        if i % 2 == 0:
            side_sign = -1
        var random_direction = Vector2.RIGHT.rotated(randf() * TAU)
        instance.global_position = center + \
            (i + 1) * back_vector * back_space  + \
            (i * side_sign) * side_vector * side_space + \
            random_direction * 5.0
        last_position = instance.global_position
    size_props["center"] = last_position + back_vector * back_size / 2.0
        
