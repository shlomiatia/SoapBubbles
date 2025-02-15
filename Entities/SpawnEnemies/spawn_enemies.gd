class_name SpawnEnemies extends Node2D

@onready var camera: Camera2D = $/root/Game/Player/Camera2D
@onready var wave_label: WaveLabel = $/root/Game/CanvasLayer/WaveLabel
var cost := 0;
var tutorial_step = 0;

func _ready() -> void:
    wave_label.display("WASD to move")
    
func tutorial(step: int) -> void:
    if tutorial_step == 0 && step == 0:
        wave_label.display("Left mouse button to blow small bubbles")
        tutorial_step = tutorial_step + 1
    elif tutorial_step == 1 && step == 1:
        wave_label.display("Right mouse button to blow a large bubble")
        tutorial_step = tutorial_step + 1
    elif tutorial_step == 2 && step == 2:
        tutorial_step = tutorial_step + 1
        spawn()
        
    
func spawn() -> void:
    cost += 8
    @warning_ignore("integer_division")
    wave_label.display_and_hide("Wave %s" % (cost / 8))
    await get_tree().create_timer(5.0).timeout
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
            
