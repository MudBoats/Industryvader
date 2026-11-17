extends Node

# マップの基本定数
const TILE_SIZE: int = 32
const GROUND_STANDARD: int = 0
const GROUND_DEPTH: int = 10
const WORLD_WIDTH_TILES: int = 2*3*(GROUND_DEPTH-GROUND_STANDARD) # 星一周の横マス数（2*pi*R）
const WORLD_WIDTH_PX: float = WORLD_WIDTH_TILES * TILE_SIZE

# 縦方向の制限パラメータ
var ground_y_tile: int = 0      # 地表のY座標（0基準）
var max_build_height: int = 10-GROUND_STANDARD    # 技術ツリーで解放された作業上限（上方向なので実際は -15）
var margin_bottom_tiles: int = GROUND_DEPTH  # m: 地表より下に見せるマス数（海水・地下表現用）
var margin_top_tiles: int = 8     # n: 作業上限より上に見せるマス数（空・敵の出現視認用）

enum Mode { COMBAT, BUILD }
var current_mode: Mode = Mode.COMBAT
var selected_tile_id: int = 0 # 建築モードで選択中のタイル種別ID

# オブジェクトのX座標を星一周の範囲にループさせ、境界付近なら分身（ghost_sprite）の位置を更新する
func apply_world_wrap(target_node: Node2D, main_sprite: Sprite2D, ghost_sprite: Sprite2D) -> void:
	# 1. 本体のX座標を 0 ～ WORLD_WIDTH_PX にループ
	target_node.global_position.x = wrapf(target_node.global_position.x, 0.0, WORLD_WIDTH_PX)
	
	if ghost_sprite == null or main_sprite == null:
		return
		
	# 2. 境界付近（画面幅の半分〜1画面分＝800px以内）にいるかチェック
	var buffer_px: float = 800.0
	var x := target_node.global_position.x
	
	if x < buffer_px:
		# 左端付近にいるので、右端の外側に分身を表示
		ghost_sprite.visible = true
		ghost_sprite.global_position = Vector2(x + WORLD_WIDTH_PX, target_node.global_position.y)
		ghost_sprite.texture = main_sprite.texture
		ghost_sprite.rotation = main_sprite.rotation
	elif x > WORLD_WIDTH_PX - buffer_px:
		# 右端付近にいるので、左端の外側に分身を表示
		ghost_sprite.visible = true
		ghost_sprite.global_position = Vector2(x - WORLD_WIDTH_PX, target_node.global_position.y)
		ghost_sprite.texture = main_sprite.texture
		ghost_sprite.rotation = main_sprite.rotation
	else:
		# 境界から離れているときは分身を隠す
		ghost_sprite.visible = false
