extends Area2D

class_name Track

func _on_body_entered(body):
	if body is Car: 
		body.entered_gravel()
		print("enter gravel area")
		
		# Slow down car, play sound, etc.

func _on_body_exited(body):
	if body is Car: 
		body.exit_gravel()
		print("exit gravel area")
		
