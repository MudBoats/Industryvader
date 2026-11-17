class_name world_entity
extends Area2D

# 子シーンに「Sprite2D」と「GhostSprite」という名前のノードがある前提
@onready var main_sprite: Sprite2D = get_node_or_null("Sprite2D")
@onready var ghost_sprite: Sprite2D = get_node_or_null("GhostSprite")

func _physics_process(delta: float) -> void:
	# 1. サブクラスごとの固有の移動・行動処理を呼び出す（テンプレートメソッドパターン）
	_entity_process(delta)
	
	# 2. すべてのエンティティに共通の「星一周（横ループ）＆分身表示」を自動適用
	GameState.apply_world_wrap(self, main_sprite, ghost_sprite)

# 子クラスでオーバーライド（上書き）して使う仮想メソッド
func _entity_process(delta: float) -> void:
	pass
