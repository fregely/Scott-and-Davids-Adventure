extends CharacterBody2D

class_name Car

@export var steering_angle = 35  # Maximum angle for steering the car's wheels
@export var engine_power = 600  # How much force the engine can apply for acceleration
@export var friction = -35  # The friction coefficient that slows down the car
@export var drag = -0.06  # Air drag coefficient that also slows down the car
@export var braking = -450  # Braking power when the brake input is applied
@export var max_speed_reverse = 250  # Maximum speed limit in reverse
@export var slip_speed = 100  # Speed above which the car's traction decreases (for drifting)
@export var traction_fast = 1  # Traction factor when the car is moving fast (affects control)
@export var traction_slow = 10  # Traction factor when the car is moving slow (affects control)


var wheel_base = 65  # Distance between the front and back axle of the car
var acceleration = Vector2.ZERO  # Current acceleration vector
var steer_direction  # Current direction of steering
var in_gravel = false
var verification_count: int = 0;
var verification_passed: Array[int] = []
var car_number = 1 
var car_name: String = "James"
var lap_time: float = 0.0

@export var is_active = true

func setup(vc: int) -> void:
	verification_count = vc
	pass 

func _process(delta: float) -> void:
	lap_time += delta

func _physics_process(delta: float) -> void:
	if is_active:
		acceleration = Vector2.ZERO
		get_input()
		calculate_steering(delta)

	apply_friction(delta)  # 1. Calculate friction first
	velocity += acceleration * delta  # 2. Apply engine + friction to velocity
	move_and_slide()  # 3. Move
	update_sprite_visuals()

func update_sprite_visuals():
	
	$AnimatedSprite2D.global_rotation = 0
	var angle = fposmod(rotation_degrees, 360.0)
	
	var frame_index = int((angle + 22.5) / 45.0)
	
	if frame_index >= 8:
		frame_index = 0
	# 5. Set the frame
	$AnimatedSprite2D.frame = frame_index

#function to handle input from the user and apply effects to the car's movement
func get_input():
	if(in_gravel): friction = -300 
	# maybe want to add some delay or build up so it doenst immeditally slow down and speed up
	else: friction = -35
	
	# Get steering input and translate it to an angle
	var turn = Input.get_axis("move_left", "move_right")
	steer_direction = turn * deg_to_rad(steering_angle)

	# If accelerate is pressed, apply engine power to the car's forward direction
	if Input.is_action_pressed("move_up"):
		acceleration = transform.x * engine_power

	# If brake is pressed, apply braking force
	if Input.is_action_pressed("move_down"):
		acceleration = transform.x * braking

#Function to apply friction forces to the car, making it 'slide' to a halt
func apply_friction(delta):
	# If there is no input and speed is very low, just stop to prevent endless sliding
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	# Calculate friction force and air drag based on current velocity, and apply it
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	# Add the forces to the acceleration
	acceleration += drag_force + friction_force

	
# Function to calculate the steering effect
func calculate_steering(delta):
	# Calculate the positions of the rear and front wheel
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	
	# Advance the wheels' positions based on the current velocity
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	
	# Calculate the new heading based on the wheels' positions
	var new_heading = rear_wheel.direction_to(front_wheel)

	# --- CHANGED SECTION START ---
	# Default to high traction (grip) so we drive straight on straightaways
	var current_traction = traction_slow

	# Only consider drifting if we are fast enough
	if velocity.length() > slip_speed:
		# If the player is actively steering (steer_direction is not 0), LOSE traction
		if steer_direction != 0:
			current_traction = traction_fast
		else:
			# If player is NOT steering (going straight), regain FULL traction
			current_traction = traction_slow
	# --- CHANGED SECTION END ---

	# Dot product represents how aligned the new heading is with current velocity
	var d = new_heading.dot(velocity.normalized())

	# If not braking (d > 0), adjust velocity towards new heading
	if d > 0:
		# We use 'current_traction' here instead of 'traction'
		velocity = lerp(velocity, new_heading * velocity.length(), current_traction * delta)

	# If braking (d < 0), reverse direction and limit speed
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	# Update the car's rotation
	rotation = new_heading.angle()
	
func entered_gravel() -> void:
	in_gravel = true

func exit_gravel() -> void:
	in_gravel = false

func lap_completed() -> void:
	if verification_passed.size() == verification_count:
		var lcd: LapCompleteData = LapCompleteData.new(self, lap_time)
		print("Lap Completed: %s" % lcd)
		EventHub.emit_on_lap_completed(lcd)
	verification_passed.clear()
	lap_time = 0.0

func hit_verification(verification_id: int) -> void:
	if verification_id not in verification_passed:
		verification_passed.append(verification_id)
		
			
