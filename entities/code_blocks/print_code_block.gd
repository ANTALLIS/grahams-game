extends Node3D

const NAME: String = "print"

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.call_deferred("insert_code_block", NAME)
		queue_free()
