extends StateMachine

enum PlayerStateEnum {
    STAND,
    LIGHT,
    HEAVY
}

func _init() -> void:
    super({
        PlayerStateEnum.STAND: PlayerStandState.new(),
        PlayerStateEnum.LIGHT: PlayerLightState.new(),
        PlayerStateEnum.HEAVY: PlayerHeavyState.new(), 
    })
