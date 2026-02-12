extends LuaCodeEdit

@onready var wall = preload("res://wall.tscn")

var texture_library = {
	"Bars": "res://rltiles/dngn/wall/bars_red01.png",
	"Beehive0": "res://rltiles/dngn/wall/beehives0.png",
	"Beehive1": "res://rltiles/dngn/wall/beehives1.png",
	"Beehive2": "res://rltiles/dngn/wall/beehives2.png",
	"Beehive3": "res://rltiles/dngn/wall/beehives3.png",
	"Beehive4": "res://rltiles/dngn/wall/beehives4.png",
	"Beehive5": "res://rltiles/dngn/wall/beehives5.png",
	"Beehive6": "res://rltiles/dngn/wall/beehives6.png",
	"Beehive7": "res://rltiles/dngn/wall/beehives7.png",
	"Beehive8": "res://rltiles/dngn/wall/beehives8.png",
	"Beehive9": "res://rltiles/dngn/wall/beehives9.png",
	"Brick0": "res://rltiles/dngn/wall/brick_brown0.png",
	"Brick1": "res://rltiles/dngn/wall/brick_brown1.png",
	"Brick2": "res://rltiles/dngn/wall/brick_brown2.png",
	"Brick3": "res://rltiles/dngn/wall/brick_brown3.png",
	"Brick4": "res://rltiles/dngn/wall/brick_brown4.png",
	"Brick5": "res://rltiles/dngn/wall/brick_brown5.png",
	"Brick6": "res://rltiles/dngn/wall/brick_brown6.png",
	"Brick7": "res://rltiles/dngn/wall/brick_brown7.png",
	"FloorSilver0": "res://rltiles/dngn/floor/metal_silver0.png"
}

func spawn_wall(x: float, y: float, z: float, type_name: String):
	# Instance the base wall
	var wall_scene = wall.instantiate()
	add_child(wall_scene)
	wall_scene.global_position = Vector3(x * 5, y * 5, z * 5)

	# Get the path from our library 
	if texture_library.has(type_name):
		var path = texture_library[type_name]

		# Load the file from disk
		var tex = load(path)

		# Push the texture into the SHADER instance 
		var mesh_node = wall_scene.get_node("MeshInstance3D")
		var new_mat = mesh_node.get_active_material(0).duplicate()
		new_mat.albedo_texture = tex
		mesh_node.set_surface_override_material(0, new_mat)
	else:
		print("Error: Texture ", type_name, " not found in library!")

func run_lua_script(my_str: String) -> void:
	var lua = LuaState.new()
	lua.open_libraries()
	assert(lua.globals is LuaTable)
	lua.globals["spawn_wall"] = spawn_wall
	var result = lua.do_string(my_str)

	if result is LuaError:
		printerr("Error in Lua code: ", result)
	else:
		print(result)  # [LuaTable:0x556069ee50ab]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_console_e") and !visible:
		visible = !visible
	if Input.is_action_just_pressed("toggle_console_esc") and visible:
		visible = !visible
	if visible:
		grab_focus()

func _on_focus_exited() -> void:
	print(text)
	run_lua_script(text)
	

