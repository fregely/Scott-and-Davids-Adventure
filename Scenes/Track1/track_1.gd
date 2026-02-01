extends Node

class_name Track1

@onready var verification_holder =$"Verification Holder"
@onready var car_holder = $CarsHolder
@onready var track_path = $TrackPath
@onready var track_processor: TrackProcessor= $TrackPath/TrackProcessor
@onready var waypoints_holder = $"Waypoints Holder"

var track_curve: Curve2D

func _ready() -> void:
	await setup()
			
			

func setup() -> void:
	track_curve = track_path.curve
	track_processor.build_waypiont_data(waypoints_holder)
	await track_processor.build_completed
	
	for car in car_holder.get_children():
		if car is Car:
			car.setup(verification_holder.get_children().size())
	
