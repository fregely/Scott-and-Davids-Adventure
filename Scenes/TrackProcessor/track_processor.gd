extends PathFollow2D

class_name TrackProcessor

signal build_completed

const WAYPOINT = preload("res://Scenes/Waypoint/waypoint.tscn")

@export var interval: float = 50.0 
@export var grid_space: float = 50.0
var _waypoints: Array[Waypoint]

func build_waypiont_data(holder: Node) -> void:
	_waypoints.clear()
	await generate_waypoints(holder)
	connect_waypoints()
	for wp in _waypoints: print(wp)

	build_completed.emit()
	print("build_done")
	
func create_waypoint() -> Waypoint:
	var wp: Waypoint = WAYPOINT.instantiate()
	wp.global_position = global_position
	wp.rotation_degrees = global_rotation_degrees + 90.0
	return wp 	


func generate_waypoints(holder: Node) -> void:
	var path2d: Path2D = get_parent()
	progress = interval
	var current_progress = progress
	var path_length = path2d.curve.get_baked_length()
	print("Path length: ", path_length)
	if path_length == 0:
		push_error("Path curve has zero length!")
		return
	while current_progress < path_length - grid_space:
		force_update_transform()
		# Make waypoint 
		var wp: Waypoint = create_waypoint()
		holder.add_child(wp)
		_waypoints.append(wp)
		progress += interval
		current_progress += interval

		
	await get_tree().physics_frame
	

func connect_waypoints() -> void:
	var total_wp: int = _waypoints.size()
	for i in range(total_wp):
		var prev_ix: int = (i - 1 + total_wp) % total_wp
		var next_ix: int = (i + 1) % total_wp
		_waypoints[i].setup(_waypoints[next_ix], _waypoints[prev_ix], i)
		
