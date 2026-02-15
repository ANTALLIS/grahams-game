extends MeshInstance3D

@onready var text_edit: TextEdit = $TextEditorArea/TextEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_edit.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_text_editor_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		text_edit.visible = true

func _on_text_editor_area_body_exited(body: Node3D) -> void:
	text_edit.visible = false
