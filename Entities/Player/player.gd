class_name Player extends CharacterBody2D

const SPEED = 150.0
const MAX_METER: float = 1.0
const EMISSION_RATE: float = 0.5

var TEXTURE_RADIUS

var current_state_id: PlayerStateMachine.PlayerStateEnum
var meter: float = MAX_METER
var big_bubble: BigBubble = null
var big_bubble_scene = load("res://Entities/BigBubble/BigBubble.tscn")
var small_bubble_scene = load("res://Entities/SmallBubble/SmallBubble.tscn")
var small_bubble_timer: float = 0.0

func _ready() -> void:
    TEXTURE_RADIUS = $Sprite2D.texture.get_width() / 2.0

func _process(delta):
    PlayerStateMachine.get_current(self)._process(self, delta)
        
func _input(event: InputEvent) -> void:
    PlayerStateMachine.get_current(self)._input(self, event)

func _physics_process(delta: float) -> void:
    var direction_x := Input.get_axis("ui_left", "ui_right")
    var direction_y := Input.get_axis("ui_up", "ui_down")
    var direction = Vector2(direction_x, direction_y).normalized()
    velocity = direction * SPEED
    move_and_collide(velocity * delta)

func get_bubble_direction():
    return (get_global_mouse_position() - global_position).normalized()
    
func get_bubble_position():
    return global_position + get_bubble_direction() * TEXTURE_RADIUS

func deplete_meter(delta: float):
    meter = max(meter - EMISSION_RATE * delta, 0.0)

func stop():
    if big_bubble != null:
        big_bubble.stop()
        big_bubble = null
        PlayerStateMachine.change_state(self, PlayerStateMachine.PlayerStateEnum.STAND)   
