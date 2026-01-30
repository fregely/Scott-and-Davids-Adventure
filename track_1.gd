extends Node

class_name Track1

@onready var verification_holder =$"Verification Holder"
@onready var car_holder = $CarsHolder

func _ready() -> void:
	for car in car_holder.get_children():
		if car is Car:
			car.setup(verification_holder.get_children().size())
