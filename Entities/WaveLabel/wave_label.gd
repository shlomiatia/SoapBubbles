class_name WaveLabel extends Label

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    pass


func _process(_delta: float) -> void:
    pass

func display_text(text_to_show: String) -> void:
    text = text_to_show
    animation_player.play("Show")
