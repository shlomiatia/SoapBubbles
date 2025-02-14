class_name SpawnEnemiesOnSide

static var small_enemy_scene: PackedScene = preload("res://Entities/SmallEnemy/SmallEnemy.tscn")
static var big_enemy_scene: PackedScene = preload("res://Entities/BigEnemy/BigEnemy.tscn")

static var enemy_props: Dictionary = {
    SpawnEnemyWave.EnemySize.SMALL: {
        "scene": small_enemy_scene,
        "size": 20
    },
    SpawnEnemyWave.EnemySize.MEDIUM: {
        "scene": big_enemy_scene,
        "size": 32
    },
    SpawnEnemyWave.EnemySize.LARGE: {
        "scene": big_enemy_scene,
        "size": 64
    },
    SpawnEnemyWave.EnemySize.XLARGE: {
        "scene": big_enemy_scene,
        "size": 128
    },
}
    
static func spawn(node: Node, count: int, enemy_key: SpawnEnemyWave.EnemySize, size_props: Dictionary, formation: SpawnEnemyWave.Formation):
    var back_multiplier = 1.0
    var side_multiplier = 0.0
    if formation == SpawnEnemyWave.Formation.ROW:
        back_multiplier = 0.0
        side_multiplier = 1.0
    var enemy_prop: Dictionary = enemy_props[enemy_key]
    var enemy_scene: PackedScene = enemy_prop["scene"]
    var back_size: float = enemy_prop["size"]
    var center: Vector2 = size_props["center"]
    var back_vector: Vector2 = size_props["back_vector"]
    var back_space: float = back_size * back_multiplier
    var side_vector: Vector2 = back_vector.orthogonal().abs()
    var side_space: float = side_multiplier * size_props["side_size"] / count
    var last_position
    for i in count:
        var instance = enemy_scene.instantiate()
        instance.setup(back_size)
        node.get_parent().add_child(instance)
        var side_sign = 1
        if i % 2 == 0:
            side_sign = -1
        var random_direction = Vector2.RIGHT.rotated(randf() * TAU)
        instance.global_position = center + \
            (i + 1) * back_vector * back_space  + \
            (i * side_sign) * side_vector * side_space + \
            random_direction * 5.0
        last_position = instance.global_position
    size_props["center"] = last_position + back_vector * back_size / 2.0
        
