class_name SpawnEnemies extends Node2D

@onready var camera: Camera2D = $/root/Game/Player/Camera2D
@onready var wave_label: WaveLabel = $/root/Game/CanvasLayer/WaveLabel
@onready var player: Player = $/root/Game/Player
@onready var enemies: Node2D = $/root/Game/Enemies
var cost := 0;
var tutorial_step = 0;
var prevent_spawn = false
var can_restart = false

func _ready() -> void:
    wave_label.display("WASD to move")
    
func tutorial(step: int) -> void:
    if tutorial_step == 0 && step == 0:
        tutorial_step = -1
        wave_label.hide_and_display("Left mouse button to blow small bubbles")
        await get_tree().create_timer(3).timeout
        tutorial_step = 1
    elif tutorial_step == 1 && step == 1:
        tutorial_step = -1
        wave_label.hide_and_display("Right mouse button to blow a large bubble")
        await get_tree().create_timer(3).timeout
        tutorial_step = 2
    elif tutorial_step == 2 && step == 2:
        tutorial_step = -1
        wave_label.undisplay()
        await get_tree().create_timer(1.5).timeout
        spawn()
        
func game_over() -> void:
    @warning_ignore("integer_division")
    wave_label.display("You survived %s waves.\n " % (cost / 8))
    prevent_spawn = true
    for enemy in get_tree().get_nodes_in_group("enemies"):
        enemy.die()
    await get_tree().create_timer(2.5).timeout
    can_restart = true
    @warning_ignore("integer_division")
    wave_label.text = "You survived %s waves.\nClick to restart" % (cost / 8)
    cost = 0
    
    
func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton && event.pressed: 
        if event.button_index == MOUSE_BUTTON_LEFT:
            if can_restart:
                can_restart = false
                prevent_spawn = false
                tutorial_step = -1
                wave_label.animation_player.play("RESET");
                player.live()
                await get_tree().create_timer(1.5).timeout
                spawn()
            
func spawn() -> void:
    if prevent_spawn:
        return
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
        SpawnEnemiesOnSide.spawn(enemies, config.enemies, size_props[config.side], config.formation)
            
