extends Tree
class_name CodeBlockTree

func _ready() -> void:
	var root: TreeItem = create_item()
	var child: TreeItem = create_item(root)
	var child_2: TreeItem = create_item(root)
	
	child.set_text(0, "start")
	child_2.set_text(0, "stop")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
