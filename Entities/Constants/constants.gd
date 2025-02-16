extends Node2D


var bubble_deceleration: float = 20.0
var bubble_lifetime: float = 4.0
var bubble_speed: float = 175.0
var small_bubble_spred: float = 3.0
var enemy_speed: float = 250.0
var small_bubbles_per_second: float = 10
var player_speed: float = 175.0
var max_meter: float = 1.0
var meter_drop_rate: float = 0.5
var meter_fill_rate: float = 0.5

var canvas_layer: CanvasLayer
var display_label: Label
var current_property_index: int = 0
var properties: Array = []

var timer = 0

func _ready():
    properties = [
        "bubble_deceleration",
        "bubble_lifetime",
        "bubble_speed",
        "enemy_speed",
        "small_bubbles_per_second",
        "player_speed",
        "max_meter",
        "meter_drop_rate",
        "meter_fill_rate"
    ]
    
    #setup_ui()
    #update_display()
    #print_all_values()
    
func setup_ui():
    canvas_layer = CanvasLayer.new()
    
    $/root/Game.add_child(canvas_layer)
    
    display_label = Label.new()
    display_label.position = Vector2(10, 10)
    canvas_layer.add_child(display_label)


func _input(event: InputEvent):
    if event.is_action_pressed("ui_right"):
        current_property_index = (current_property_index + 1) % properties.size()
        update_display()
    
    elif event.is_action_pressed("ui_left"):
        current_property_index = (current_property_index - 1) % properties.size()
        if current_property_index < 0:
            current_property_index = properties.size() - 1
        update_display()
    elif event.is_action_pressed("ui_up"):
        timer = 0
        adjust_current_value(1)
    
    elif event.is_action_pressed("ui_down"):
        timer = 0
        adjust_current_value(-1)
    
func _process(delta: float) -> void:    
    if Input.is_action_pressed("ui_up"):
        timer += delta
        print(timer)
        if timer > 0.2:
            adjust_current_value(1)
    
    elif Input.is_action_pressed("ui_down"):
        timer += delta
        if timer > 0.2:
            adjust_current_value(-1)

func adjust_current_value(direction: int):
    var var_name = properties[current_property_index]
    
    set(var_name, get(var_name) + direction)
    
    update_display()
    print_all_values()

func update_display():
    var var_name = properties[current_property_index]
    var current_value = get(var_name)
    
    display_label.text = "%s: %.2f" % [var_name, current_value]

func print_all_values():
    print("\nCurrent Values:")
    print("----------------")
    for var_name in properties:
        var current_value = get(var_name)
        print("%s: %.2f" % [var_name, current_value])
    print("----------------")
