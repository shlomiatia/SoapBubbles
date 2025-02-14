class_name SpawnEnemyWave

enum SpawnSide { LEFT, RIGHT, TOP, DOWN }
enum Formation { ROW, COLUMN }
enum EnemySize { SMALL, MEDIUM, LARGE, XLARGE }

const MIN_ENEMIES_COST = 8
const SIZE_COSTS = {
    EnemySize.SMALL: 1,
    EnemySize.MEDIUM: 4,
    EnemySize.LARGE: 8,
    EnemySize.XLARGE: 16
}

static func generate_spawn_configuration(total_value: int) -> Array:    
    var configurations = []
    
    var selected_sides = generate_sides(total_value)
    
    for side in selected_sides:
        if side == SpawnSide.TOP or side == SpawnSide.DOWN:
            total_value /= 2
            
    @warning_ignore("integer_division")
    var points_per_side = total_value / selected_sides.size()
    
    for side in selected_sides:
        var points_for_side = points_per_side
        var formation = Formation.COLUMN
        if points_for_side >= MIN_ENEMIES_COST * 2:
            formation = Formation.ROW if randi() % 2 == 0 else Formation.COLUMN
            if formation == Formation.ROW:
                points_for_side /= 2
    
        var enemies = generate_enemies_for_side(points_for_side)
        
        if enemies.size() > 0:
            configurations.append({
                "side": side,
                "formation": formation,
                "enemies": enemies
            })
    
    return configurations

static func generate_sides(value: int) -> Array:
    var sides = [SpawnSide.LEFT, SpawnSide.RIGHT, SpawnSide.TOP, SpawnSide.DOWN]
    var divider = 4
    
    @warning_ignore("integer_division")
    while !sides.is_empty() && value / sides.size() / divider < MIN_ENEMIES_COST:
        var i = randi() % sides.size()
        if sides[i] == SpawnSide.TOP || sides[i] == SpawnSide.DOWN:
            divider /= 2
        sides.remove_at(i)
    if sides.size() == 0:
        sides = [randi() % 2]
    
    var num_sides = randi() % sides.size() + 1
    sides.shuffle()
    return sides.slice(0, num_sides)


static func generate_enemies_for_side(points: int) -> Array:
    var enemies = []
    var remaining_points = points
    
    while remaining_points >= SIZE_COSTS[EnemySize.SMALL]:
        var available_sizes = []
        for size in EnemySize.values():
            if SIZE_COSTS[size] <= remaining_points:
                available_sizes.append(size)
        
        if available_sizes.is_empty():
            break
            
        var chosen_size = available_sizes[randi() % available_sizes.size()]
        var cost = SIZE_COSTS[chosen_size]
        
        var max_count = remaining_points / cost
        var count = randi() % max_count + 1
        
        if !enemies.is_empty() && enemies[enemies.size() - 1].size == chosen_size:
            enemies[enemies.size() - 1].count += count
        else:
            enemies.append({
                "size": chosen_size,
                "count": count
            })
        
        remaining_points -= count * cost
    return enemies
