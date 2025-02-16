class_name Bottle extends Control

@onready var water_top = $WaterTop
@onready var water = $Water

func _ready() -> void:
    pass


func _process(_delta: float) -> void:
    pass

func set_water_level(level: float) -> void:
    water_top.position.y = 1 + 54 - 54 * level
    water.position.y = 54 - 54 * level
    water.size.y = 7 + 54 * level
