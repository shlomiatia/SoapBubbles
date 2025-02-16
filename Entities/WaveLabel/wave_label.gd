class_name WaveLabel extends Label

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var next_text

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func display_and_hide(text_to_show: String) -> void:
    text = text_to_show
    animation_player.play("ShowAndHide")

func display(text_to_show: String) -> void:
    text = text_to_show
    animation_player.play("Show")

func hide_and_display(text_to_show: String) -> void:
    next_text = text_to_show
    animation_player.play("HideAndShow")
    
func undisplay() -> void:
    animation_player.play("Hide")
    
func set_next_text() -> void:
    text = next_text
