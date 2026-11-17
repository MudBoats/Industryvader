extends Node2D

@export var enemy_scene: PackedScene

@onready var enemy_spawner: Timer = $EnemySpawner

func _ready() -> void:
	# タイマーのタイムアウトシグナルをコードから接続
	enemy_spawner.timeout.connect(_on_enemy_spawner_timeout)

func _on_enemy_spawner_timeout() -> void:
	if enemy_scene == null:
		return
		
	# 敵をインスタンス化
	var enemy = enemy_scene.instantiate()
	
	# 画面の上端のランダムなX座標に配置
	var spawn_x = randf_range(50.0, get_viewport_rect().size.x - 50.0)
	enemy.position = Vector2(spawn_x,-(GameState.max_build_height+GameState.margin_top_tiles)*GameState.TILE_SIZE)
	
	add_child(enemy)
