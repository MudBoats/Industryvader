extends TileMapLayer

var grid_data: Dictionary = {}
const SEAM_BUFFER_TILES: int = 25 # 1画面分以上の余裕を持たせる

func _ready() -> void:
	# ゲーム開始時に、エディタで事前に配置した「元々の地形」を左右にミラーリングする
	mirror_initial_terrain()

func mirror_initial_terrain() -> void:
	# 現在TileMapLayerに配置されているすべてのセル座標を取得
	var used_cells := get_used_cells()
	
	for cell in used_cells:
		# 0 ～ (WORLD_WIDTH_TILES - 1) の正規範囲内のセルだけを対象にする
		if cell.x >= 0 and cell.x < GameState.WORLD_WIDTH_TILES:
			var source_id := get_cell_source_id(cell)
			var atlas_coords := get_cell_atlas_coords(cell)
			var alt_tile := get_cell_alternative_tile(cell)
			
			# 左端付近の地形なら、右側の外側にコピー
			if cell.x < SEAM_BUFFER_TILES:
				var mirror_right := Vector2i(cell.x + GameState.WORLD_WIDTH_TILES, cell.y)
				set_cell(mirror_right, source_id, atlas_coords, alt_tile)
				
			# 右端付近の地形なら、左側の外側にコピー
			if cell.x >= GameState.WORLD_WIDTH_TILES - SEAM_BUFFER_TILES:
				var mirror_left := Vector2i(cell.x - GameState.WORLD_WIDTH_TILES, cell.y)
				set_cell(mirror_left, source_id, atlas_coords, alt_tile)

# --- 以下、前回と同じ配置ロジック ---
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var raw_tile_pos := local_to_map(mouse_pos)
		
		var norm_x := wrapi(raw_tile_pos.x, 0, GameState.WORLD_WIDTH_TILES)
		var norm_pos := Vector2i(norm_x, raw_tile_pos.y)
		
		if can_place_structure(norm_pos):
			place_structure(norm_pos, GameState.selected_tile_id)

func can_place_structure(tile_pos: Vector2i) -> bool:
	# すでに建物が置かれている、または元々の地形タイルがある場所（必要に応じて判定調整）
	if grid_data.has(tile_pos):
		return false
	if tile_pos.y > GameState.ground_y_tile:
		return false
	if -tile_pos.y > GameState.max_build_height:
		return false
	return true

func place_structure(norm_pos: Vector2i, tile_type_id: int) -> void:
	grid_data[norm_pos] = tile_type_id
	var atlas_coords := Vector2i(tile_type_id, 0)
	set_cell(norm_pos, 0, atlas_coords)
	
	if norm_pos.x < SEAM_BUFFER_TILES:
		set_cell(Vector2i(norm_pos.x + GameState.WORLD_WIDTH_TILES, norm_pos.y), 0, atlas_coords)
	if norm_pos.x >= GameState.WORLD_WIDTH_TILES - SEAM_BUFFER_TILES:
		set_cell(Vector2i(norm_pos.x - GameState.WORLD_WIDTH_TILES, norm_pos.y), 0, atlas_coords)
