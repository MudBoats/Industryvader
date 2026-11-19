extends base_bullet

# 弾の移動速度（ピクセル/秒）

func _physics_process(delta: float) -> void:
	# 毎フレーム上方向に移動（2D座標系では上方向が Y マイナス）
	position.y -= speed * delta
	
	# 画面外（上部）に出たらノードを削除してメモリ解放
	if position.y < -(GameState.max_build_height+GameState.margin_top_tiles)*GameState.TILE_SIZE:
		queue_free()
