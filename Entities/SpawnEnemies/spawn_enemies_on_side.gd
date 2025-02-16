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
    
static func spawn(node: Node, enemies: Array, size_props: Dictionary, formation: SpawnEnemyWave.Formation):
    var back_vector: Vector2 = size_props["back_vector"]
    var side_vector: Vector2 = back_vector.orthogonal().abs()
    var total_enemies = 0
    for enemy_group in enemies:
        total_enemies += enemy_group.count
    var side_size = size_props["side_size"]
    var side_space: float = side_size  / total_enemies
    var center: Vector2 = size_props["center"]
    if formation == SpawnEnemyWave.Formation.COLUMN:
        center = center + side_vector * (randf() * side_size - side_size / 2.0)
    var i = 0
    var previous_back_space = 0.0
    var total_back_space = 0.0
    for enemy_group in enemies:
        var enemy_prop: Dictionary = enemy_props[enemy_group.size]
        var enemy_scene: PackedScene = enemy_prop["scene"]
        var back_size: float = enemy_prop["size"]
        for j in enemy_group.count:
            total_back_space += back_size / 2 + previous_back_space / 2
            previous_back_space = back_size
            var instance = enemy_scene.instantiate()
            instance.setup(back_size)
            node.get_parent().add_child(instance)
            if formation == SpawnEnemyWave.Formation.COLUMN:
                instance.global_position = center + back_vector * total_back_space
            else:
                var side_sign = 1
                if i % 2 == 0:
                    side_sign = -1
                @warning_ignore("integer_division")
                instance.global_position = center + ((i + 1) / 2) * side_sign * side_vector * side_space
            var random_direction = Vector2.RIGHT.rotated(randf() * TAU)	
            instance.global_position += random_direction * 5.0
            i = i + 1
            
