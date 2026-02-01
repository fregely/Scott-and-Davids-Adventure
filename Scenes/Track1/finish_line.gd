extends Area2D

class_name finishLine

func _on_body_entered(body: Node2D) -> void:
	if body is Car:
		body.lap_completed()
