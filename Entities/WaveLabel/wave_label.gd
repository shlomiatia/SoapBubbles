class_name WaveLabel extends Label

@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
    
func undisplay(text_to_show: String) -> void:
    text = text_to_show
    animation_player.play("Hide")
