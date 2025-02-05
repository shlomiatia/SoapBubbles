class_name Player extends CharacterBody2D

enum Emission { NONE, LIGHT, HEAVY }

const SPEED = 150.0
const PARTICLE_EMITTER_DISTANCE = 32
const MAX_METER: float = 2.0
const FILL_RATE: float = 2.0
const EMISSION_RATE: float = 1.0

var meter: float = MAX_METER
var emission: Emission = Emission.NONE
var big_bubble: BigBubble = null
var big_bubble_scene = load("res://Entities/BigBubble/BigBubble.tscn")

@onready var particle_emitter : GPUParticles2D = $GPUParticles2D

func _process(delta):
    var mouse_direction = (get_global_mouse_position() - global_position).normalized()
    particle_emitter.global_position = global_position + mouse_direction * PARTICLE_EMITTER_DISTANCE
    particle_emitter.process_material.direction = Vector3(mouse_direction.x, mouse_direction.y, 0)
    if big_bubble != null:
        big_bubble.global_position = global_position + mouse_direction * PARTICLE_EMITTER_DISTANCE
        big_bubble.direction = Vector2(mouse_direction.x, mouse_direction.y)
    
    if emission == Emission.LIGHT and meter > 0:
        particle_emitter.emitting = true   
        meter -= EMISSION_RATE * delta
    elif emission == Emission.HEAVY and meter > 0:
        meter -= EMISSION_RATE * delta
        if big_bubble == null:
            big_bubble = big_bubble_scene.instantiate()
            add_child(big_bubble)
    else:
        if meter < MAX_METER:
            meter += FILL_RATE * delta
        stop()

func stop():
    emission = Emission.NONE
    particle_emitter.emitting = false
    if big_bubble != null:
        big_bubble.stop()
        big_bubble = null
        
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
