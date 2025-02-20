class_name Player extends CharacterBody2D

const MAX_METER: float = 1.0
const world_width: float = 1920.0 * 3.0
const world_height: float = 1080.0 * 3.0

var current_state_id: PlayerStateMachine.PlayerStateEnum
var meter: float = MAX_METER
var big_bubble: BigBubble = null
var big_bubble_scene = load("res://Entities/BigBubble/BigBubble.tscn")
var small_bubble_scene = load("res://Entities/SmallBubble/SmallBubble.tscn")
var small_bubble_timer: float = 0.0
var is_dead = false
@onready var bottle: Bottle = $/root/Game/CanvasLayer/Bottle
@onready var spawn_enemies: SpawnEnemies = $/root/Game/SpawnEnemies
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pop_audio_stream_player: AudioStreamPlayer = $PopAudioStreamPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var camera2d: Camera2D = $Camera2D

var pop_sounds = [
    preload("res://Audio/pop1.mp3"),
    preload("res://Audio/pop2.mp3"),
    preload("res://Audio/pop3.mp3")
]

var light_sound = preload("res://Audio/bubbles-003-6397.mp3")
var heavy_sound = preload("res://Audio/wind-2-44150.mp3")

func _ready() -> void:
    pass

func _process(delta):
    PlayerStateMachine.get_current(self)._process(self, delta)
        
func _input(event: InputEvent) -> void:
    if is_dead:
        return
    PlayerStateMachine.get_current(self)._input(self, event)

func _physics_process(delta: float) -> void:
    if is_dead:
        return
    var direction = Input.get_vector("Left", "Right", "Up", "Down").normalized()
    if direction == Vector2.ZERO:
        if animation_player.current_animation == "Moving":
            animation_player.play("Idle")
    else:
        if animation_player.current_animation == "Idle":
            animation_player.play("Moving")
        spawn_enemies.tutorial(0)
    velocity = direction * Constants.player_speed
    move_and_collide(velocity * delta)
    wrap_position()

func get_bubble_direction():
    return (get_global_mouse_position() - global_position).normalized()
    
func get_bubble_position():
    return global_position + Vector2(0.0, 10.0)

func deplete_meter(delta: float):
    set_meter(max(meter - Constants.meter_drop_rate * delta, 0.0))
    
func set_meter(value) -> void:
    meter = value
    bottle.set_water_level(meter)

func stop():
    if big_bubble != null:
        big_bubble.stop()
        big_bubble = null
        PlayerStateMachine.change_state(self, PlayerStateMachine.PlayerStateEnum.STAND)
        
func wrap_position():
    var pos = position
    var wrapped = false
    
    if pos.x > world_width:
        pos.x = 0
        wrapped = true
    elif pos.x < 0:
        pos.x = world_width
        wrapped = true
    
    if pos.y > world_height:
        pos.y = 0
        wrapped = true
    elif pos.y < 0:
        pos.y = world_height
        wrapped = true
    
    if wrapped:
        var moveables = get_tree().get_nodes_in_group("moveables")
        for moveable in moveables:
            var vector = moveable.position - position
            moveable.position = pos + vector
            
        position = pos

func die() -> void:
    if big_bubble != null:
        big_bubble.queue_free()
        big_bubble = null
    PlayerStateMachine.change_state(self, PlayerStateMachine.PlayerStateEnum.STAND)
    is_dead = true
    spawn_enemies.game_over()
    animation_player.play("Dead")
    
    
func live() -> void:
    animation_player.play("Live")
    await get_tree().create_timer(1).timeout
    animation_player.play("Idle")
    is_dead = false

func play_random_pop_sound(pos: Vector2) -> void:
    var visible_rect_size = get_viewport_rect().size
    var visible_rect = Rect2(
        camera2d.global_position - visible_rect_size/2,
        visible_rect_size
    )
    if visible_rect.has_point(pos):    
        pop_audio_stream_player.stop()
        pop_audio_stream_player.stream = pop_sounds[randi_range(0, pop_sounds.size() - 1)]
        pop_audio_stream_player.play()

func enemy_died(size: int) -> void:
    camera2d.start_screen_shake(size / 20.0, 2 * log(size) / log(2) - 4)
    if size == 16:
        pop_audio_stream_player.bus = "Master"
    else:
        pop_audio_stream_player.bus = "Bass%s" % size
        #get_tree().paused = true
        #await get_tree().create_timer(size / 6.0 / 1000.0).timeout
        #get_tree().paused = false


func play_sound(sound: AudioStream) -> void:
    audio_stream_player.stop()
    audio_stream_player.stream = sound
    audio_stream_player.play()
    
func stop_sound() -> void:
    audio_stream_player.stop()
