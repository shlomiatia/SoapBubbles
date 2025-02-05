class_name Player extends CharacterBody2D

enum Emission { NONE, LIGHT, HEAVY }

const SPEED = 150.0
const MAX_METER: float = 1.0
const FILL_RATE: float = 0.5
const EMISSION_RATE: float = 0.5
const BPS: float = 10.0

var TEXTURE_RADIUS

var meter: float = MAX_METER
var emission: Emission = Emission.NONE
var big_bubble: BigBubble = null
var big_bubble_scene = load("res://Entities/BigBubble/BigBubble.tscn")
var small_bubble_scene = load("res://Entities/SmallBubble/SmallBubble.tscn")
var small_bubble_timer: float = 0.0

func _ready() -> void:
    TEXTURE_RADIUS = $Sprite2D.texture.get_width() / 2.0

func _process(delta):
    var mouse_direction = (get_global_mouse_position() - global_position).normalized()
    var bubble_position = global_position + mouse_direction * TEXTURE_RADIUS
    var bubble_direction = Vector2(mouse_direction.x, mouse_direction.y)
    if big_bubble != null:
        big_bubble.global_position = bubble_position
        big_bubble.direction = bubble_direction
    
    if emission == Emission.LIGHT and meter > 0:
        deplete_meter(delta)
        small_bubble_timer += delta
        var interval = 1.0 / BPS
        var operations_needed = floor(small_bubble_timer / interval)
        small_bubble_timer = fmod(small_bubble_timer, interval)
        while operations_needed > 0:
            var small_bubble = small_bubble_scene.instantiate()
            small_bubble.direction = bubble_direction
            small_bubble.global_position = bubble_position
            get_parent().add_child(small_bubble)
            operations_needed -= 1
    elif emission == Emission.HEAVY and meter > 0:
        deplete_meter(delta)
        if big_bubble == null:
            big_bubble = big_bubble_scene.instantiate()
            add_child(big_bubble)
    else:
        if meter < MAX_METER:
            meter += FILL_RATE * delta
        stop()
        
func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.pressed:
                emission = Emission.LIGHT
            else:
                emission = Emission.NONE
        if event.button_index == MOUSE_BUTTON_RIGHT:
            if event.pressed:
                emission = Emission.HEAVY
            else:
                emission = Emission.NONE

func _physics_process(delta: float) -> void:
    var direction_x := Input.get_axis("ui_left", "ui_right")
    var direction_y := Input.get_axis("ui_up", "ui_down")
    var direction = Vector2(direction_x, direction_y).normalized()
    velocity = direction * SPEED
    move_and_collide(velocity * delta)

func deplete_meter(delta: float):
    meter = max(meter - EMISSION_RATE * delta, 0.0)

func stop():
    emission = Emission.NONE
    small_bubble_timer = 0.0
    if big_bubble != null:
        big_bubble.stop()
        big_bubble = null
