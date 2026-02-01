extends Node2D

class_name Waypoint

@onready var right_collison: RayCast2D = $RightCollison
@onready var left_collison: RayCast2D = $LeftCollison
@onready var label: Label = $Label

var number: int = 0:
	get: return number 
var next_waypoint: Waypoint:
	get: 
		if !next_waypoint: printerr("WP %d No Next Waypoint!!", number)
		return next_waypoint

var prev_waypoint: Waypoint:
	get: 
		if !prev_waypoint: printerr("WP %d No Next Waypoint!!", number)
		return prev_waypoint
		
func setup(next_wp: Waypoint, prev_wp: Waypoint, num: int) -> void:
	next_waypoint = next_wp
	prev_waypoint = prev_wp
	number = num
	label.text = "%d" % num
	


func _to_string() -> String:
	return "%d, next: %d, perv: %d" % [number, next_waypoint.number, prev_waypoint.number] 
