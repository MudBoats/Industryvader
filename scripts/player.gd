extends CharacterBody2D

@export var speed: float = 400.0
@export var bullet_scene: PackedScene

@onready var muzzle: Node2D = $Muzzle
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	update_camera_limits()

func _physics_process(delta: float) -> void:
	# 1. 上下左右の移動入力
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	move_and_slide()
	
	# 2. 横方向の星一周ループ（ラップアラウンド）
	# wrapf(値, 最小値, 最大値) で 0 ～ WORLD_WIDTH_PX の間をループさせる
	global_position.x = wrapf(global_position.x, 0.0, GameState.WORLD_WIDTH_PX)
	
	# 3. 縦方向の可動範囲制限（下端：地表-mマス、上端：作業上限+nマス）
	# ※Godotの2D座標では「上＝マイナス」「下＝プラス」になる点に注意
	var min_y := -(GameState.max_build_height + GameState.margin_top_tiles) * GameState.TILE_SIZE
	var max_y := (GameState.ground_y_tile) * GameState.TILE_SIZE
	global_position.y = clamp(global_position.y, min_y, max_y)

	# 4. 戦闘モード時のみ射撃可能にする（次回への布石）
	if GameState.current_mode == GameState.Mode.COMBAT:
		if Input.is_action_just_pressed("ui_accept"):
			shoot()

# カメラのスクロール限界（Limit）を現在の高度上限に合わせて更新する関数
func update_camera_limits() -> void:
	# 横方向はループさせるため制限なし（デフォルトの大きい値のまま）
	camera.limit_left = -10000000
	camera.limit_right = 10000000
	
	# 縦方向の上限・下限をピクセル単位で設定
	camera.limit_top = -(GameState.max_build_height + GameState.margin_top_tiles) * GameState.TILE_SIZE
	camera.limit_bottom = (GameState.ground_y_tile + GameState.margin_bottom_tiles) * GameState.TILE_SIZE
	

func shoot() -> void:
	if bullet_scene == null:
		return
	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	get_parent().add_child(bullet)
