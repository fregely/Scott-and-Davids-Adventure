extends Area2D

class_name Track

#For entering gravel
func _on_body_entered(body):
	if body is Car: 
		body.entered_gravel()
		
func _on_body_exited(body):
	if body is Car: 
		body.exit_gravel() 
# maybe enstead of having it just do a bool, can have it send a value
# that way we can multiple differnt types of track collision without multiple
# bools in car
		
