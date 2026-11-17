class_name enemy_wand
extends base_enemy

@export var dash_speed: float = 350.0
var is_dashing: bool = false

func _ready() -> void:
	super._ready() # 親（BaseEnemy）の初期化を必ず呼ぶ
	drop_type = "wands"

# _entity_process をオーバーライドしてワンド固有の「突進AI」を記述
func _entity_process(delta: float) -> void:
	# 一定の高度（例: Y = -200）まで降りてきたら突進モードに切り替える
	if not is_dashing and position.y > -200.0:
		is_dashing = true
		
	if is_dashing:
		position.y += dash_speed * delta
	else:
		position.y += speed * delta
		
	# 敗北ラインチェックも親と同じ条件を使う
	if position.y >= (GameState.ground_y_tile + GameState.margin_bottom_tiles) * GameState.TILE_SIZE:
		_on_reached_core()
