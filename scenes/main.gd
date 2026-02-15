extends Node

# In Godot, a game is a tree of nodes that you group together into scenes. You can then 
# wire these nodes so they can communicate with signals.
# In Godot, you break down your game into reusable scenes. A scene can be a character, a 
# weapon, a menu, a single house, an entire level, or anything else.
# You can also nest scenes. You can put your character in a level, and drag and drop a scene 
# as a child of it.
# Scenes are composed of one or more nodes. Nodes are your game's smallest building blocks
# that you arrange into trees.
# Player
# ├─ Camera2D
# ├─ Sprite2D
# └─ CollisionShape2D
# Nodes and scenes look the same in the editor. When you save a tree of nodes as a scene,
# it then shows up as a single node, with it's internal structure hidden.
# Godot provides a library of base node types, 2D, 3D, UI, etc.
# All your game's scenes come together in the scene tree, literally a tree of scenes.
# Nodes emit signals when some event occurs. This feature allows you to make nodes communicate
# without hard-wiring them in code.
# Nodes are the fundamental building blocks of your game. They can display an image, play a 
# sound, represent a camera, etc.
# All nodes have the following characteristics:
# - A name 
# - Editable properties 
# - They receive callbacks to update every frame 
# - You can extend them with new properties and functions 
# - You can add them to another node as a child

@onready var wall: PackedScene = preload("res://environment/wall/wall.tscn")

var texture_library: Dictionary = {
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

func spawn_wall(x: float, y: float, z: float, type_name: String) -> void:
	# Instance the base wall
	var wall_scene: Node = wall.instantiate()
	add_child(wall_scene)
	wall_scene.global_position = Vector3(x, y, z)

	# Get the path from our library 
	if texture_library.has(type_name):
		var path: String = texture_library[type_name]

		# Load the file from disk
		var tex: Resource  = load(path)

		# Push the texture into the SHADER instance 
		var mesh_node: Node = wall_scene.get_node("MeshInstance3D")
		var new_mat: Material = mesh_node.get_active_material(0).duplicate()
		new_mat.albedo_texture = tex
		mesh_node.set_surface_override_material(0, new_mat)
	else:
		print("Error: Texture ", type_name, " not found in library!")

func spawn_floor() -> void:
	for x: int in range(100):
		for z: int in range(100):
			if ((5 * z) < 80 || (5 * z) > 90):
				# spawn_wall((5*x) - 50, -2.5, (5*z) - 50, "FloorSilver0")
				pass


func run_lua_script_test() -> void:
	# 1. Create a Lua state
	var lua: LuaState = LuaState.new()
	# 2. Import Lua and Godot APIs into the state
	#    Optionally pass which libraries should be opened to the method
	lua.open_libraries()

	# 3. Run Lua code using `LuaState.do_string` or `LuaState.do_file`
	var result: Variant = lua.do_string("""
	  local vector = Vector2(1, 2)
	  return {
		this_is_a_table = true,
		vector = vector,
	  }
	""")
	# 4. Access results from Lua code directly in Godot
	#    When errors occur, instances of `LuaError` will be returned
	if result is LuaError:
		printerr("Error in Lua code: ", result)
	else:
		print(result)  # [LuaTable:0x556069ee50ab]
		print(result["this_is_a_table"])  # true
		print(result["vector"])  # (1, 2)
		print(result["invalid key"])  # <null>

	# 5. Access the global _G table via `LuaState.globals` property
	assert(lua.globals is LuaTable)
	
	# Define the function with a specific signature
	var my_function: Callable = func() -> void:
		print("Hello from GDScript!")

	# Assign it to your global table
	lua.globals["a_godot_callable"] = my_function
	
	lua.do_string("""
		a_godot_callable()  -- 'Hello from GDScript!'
	""")

func print_hello(my_str: String) -> void: 
	print("Hello from " + my_str + "!")

func run_lua_script_test_two() -> void:
	var lua: LuaState = LuaState.new()
	lua.open_libraries()
	assert(lua.globals is LuaTable)
	lua.globals["print_hello"] = print_hello
	lua.globals["spawn_wall"] = spawn_wall
	var result: Variant = lua.do_string("""
		print_hello("a")
		print_hello("b")
		print_hello("c")
		for i = -5, 20 do
			spawn_wall(i * 5, i * 5, i * 5, "Beehive0")
		end
	""")
	if result is LuaError:
		printerr("Error in Lua code: ", result)
	else:
		print(result)  # [LuaTable:0x556069ee50ab]

func run_lua_script(codestring: String) -> void:
	var lua: LuaState = LuaState.new()
	lua.open_libraries()
	assert(lua.globals is LuaTable)
	lua.globals["print_hello"] = print_hello
	lua.globals["spawn_wall"] = spawn_wall
	
	var result: Variant = lua.do_string(codestring)
	
	if result is LuaError:
		printerr("Error in Lua code: ", result)
	else:
		print(result)  # [LuaTable:0x556069ee50ab]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Ready!")
	# run_lua_script_test()
	run_lua_script_test_two()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spawn_wall(20, 2.5, 20, "Bars")
	spawn_wall(20, 2.5, 25, "Beehive0")
	var i: int = 0
	for j: int in [30, 35, 40, 45, 50, 55, 60, 65]:
		spawn_wall(j, 2.5, 35, "Brick" + str(i))
		i += 1
	i = 0
	for j: int in [30, 35, 40, 45, 50, 55, 60, 65, 70, 75]:
		spawn_wall(j, 2.5, 50, "Beehive" + str(i))
		i += 1
	spawn_floor()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
