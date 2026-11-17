class_name base_enemy
extends world_entity

@export var max_hp: float = 30.0
@export var speed: float = 100.0
@export var drop_type: String = "wands" # 落とす敵性素材の種類（wands, cups等）

var current_hp: float

func _ready() -> void:
	current_hp = max_hp
	add_to_group("enemies")

func _entity_process(delta: float) -> void:
	# サブクラスで上書きしなければ、基本は下に降下する
	position.y += speed * delta
	
	# 星の中心（敗北ライン）に到達したかの共通チェック
	if position.y >= (GameState.ground_y_tile + GameState.margin_bottom_tiles) * GameState.TILE_SIZE:
		_on_reached_core()

func take_damage(amount: float) -> void:
	current_hp -= amount
	# ここにヒット時の白いフラッシュ演出などを入れると全敵に一括適用される
	if current_hp <= 0:
		die()

func die() -> void:
	# TODO: ここで drop_type（敵性素材）をドロップする処理を呼ぶ
	print("敵撃破！ ドロップ素材: ", drop_type)
	queue_free()

func _on_reached_core() -> void:
	print("【警告】敵が星の中心に到達しました！（ゲームオーバー判定）")
	queue_free()
