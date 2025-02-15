class_name SpawnEnemies extends Node2D

var camera: Camera2D
var cost := 0;

func _ready() -> void:
    camera = $/root/Game/Player/Camera2D
    spawn()
    
func spawn() -> void:
    await get_tree().create_timer(5.0).timeout
    cost += 8
    var viewport_size = get_viewport_rect().size
    var camera_pos = camera.global_position
    
    var size_props = {
        SpawnEnemyWave.SpawnSide.LEFT: {
            "center": Vector2(camera_pos.x - viewport_size.x / 2.0, camera_pos.y),
            "back_vector": Vector2(-1.0, 0.0),
            "side_size": viewport_size.y
        },
        SpawnEnemyWave.SpawnSide.RIGHT: {
            "center": Vector2(camera_pos.x + viewport_size.x / 2.0, camera_pos.y),
            "back_vector": Vector2(1.0, 0.0),
            "side_size": viewport_size.y
        },
        SpawnEnemyWave.SpawnSide.TOP: {
            "center": Vector2(camera_pos.x, camera_pos.y - viewport_size.y / 2.0),
            "back_vector": Vector2(0.0, -1.0),
            "side_size": viewport_size.x
        },
        SpawnEnemyWave.SpawnSide.DOWN: {
            "center": Vector2(camera_pos.x, camera_pos.y + viewport_size.y / 2.0),
            "back_vector": Vector2(0.0, 1.0),
            "side_size": viewport_size.x
        }
    }

    var configurations = SpawnEnemyWave.generate_spawn_configuration(cost)
    
    for config in configurations:
        SpawnEnemiesOnSide.spawn(self, config.enemies, size_props[config.side], config.formation)
            
