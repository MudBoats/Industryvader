class_name base_bullet
extends world_entity

@export var speed: float = 600.0
@export var damage: float = 10.0
@export var pierce_count: int = 1 # 貫通回数（1なら1体当たったら消える）

var direction: Vector2 = Vector2.UP

func _ready() -> void:
	add_to_group("bullets")
	area_entered.connect(_on_area_entered)

func _entity_process(delta: float) -> void:
	# 指定された方向へ直進（斜め撃ちや敵の弾にも対応可能）
	position += direction.normalized() * speed * delta
	
	# 高度上限のさらに上、または地下深くに行ったら自動消滅
	if position.y < -3000.0 or position.y > 1000.0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	# 敵（BaseEnemy）に当たった場合の共通処理
	if area is BaseEnemy:
		area.take_damage(damage)
		pierce_count -= 1
		if pierce_count <= 0:
			queue_free()
