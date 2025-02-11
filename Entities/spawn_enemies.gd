extends Node2D

var enemy_scene: PackedScene = preload("res://Entities/SmallEnemy/SmallEnemy.tscn")
var camera: Camera2D

func _ready() -> void:
    camera = $/root/Game/Player/Camera2D
    var timer: Timer = $Timer
    timer.timeout.connect(_on_spawn_timer_timeout)
    
func _on_spawn_timer_timeout() -> void:
    spawn_objects_outside_viewport()

func spawn_objects_outside_viewport():
    var viewport_size = get_viewport_rect().size
    var camera_pos = camera.global_position
    
    var props = {
        "left": {
            "center": Vector2(camera_pos.x - viewport_size.x / 2.0, camera_pos.y),
            "back": Vector2(-1.0, 0.0),
            "side_size": viewport_size.y
        },
        "right": {
            "center": Vector2(camera_pos.x + viewport_size.x / 2.0, camera_pos.y),
            "back": Vector2(1.0, 0.0),
            "side_size": viewport_size.y
        },
        "top": {
            "center": Vector2(camera_pos.x, camera_pos.y - viewport_size.y / 2.0),
            "back": Vector2(0.0, -1.0),
            "side_size": viewport_size.x
        },
        "bottom": {
            "center": Vector2(camera_pos.x, camera_pos.y + viewport_size.y / 2.0),
            "back": Vector2(0.0, 1.0),
            "side_size": viewport_size.x
        }
    }

    spawn(props["left"], 15, 20.0, 0.0)
    
func spawn(prop: Dictionary, count: int, back_space: float, side_multiplier: float):
    var center: Vector2 = prop["center"]
    var back: Vector2 = prop["back"]
    var side = back.orthogonal().abs()
    var side_space = side_multiplier * prop["side_size"] / count
    
    for i in count:
        var instance = enemy_scene.instantiate()
        get_parent().add_child(instance)
        var random_direction = Vector2.RIGHT.rotated(randf() * TAU)
        var ass = 1
        if i % 2 == 0:
            ass = -1
        instance.global_position = center + \
            i * back * back_space + \
            (i * ass) * side * side_space + \
            random_direction * 5.0
