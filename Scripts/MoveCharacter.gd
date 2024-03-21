extends CharacterBody2D
var gravity : Vector2
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = Vector2(0, 100) # initialize the gravity to 100 in the y direction (no gravity in the x direction)
	pass # Replace with function body.

# function for manually listening to user input based on defined input map actions
func _get_input():
	if is_on_floor(): # check if character body is on the floor (built-in function)
		if Input.is_action_pressed("move_left"): # check if player submits input (e.g. key press) designated for moving left
			velocity += Vector2(-movement_speed,0)

		if Input.is_action_pressed("move_right"): # check if player presses key for moving right
			velocity += Vector2(movement_speed,0)

		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			velocity += Vector2(1,-jump_height) # move character body up (negative y in Godot)

	if not is_on_floor(): # check if character body is not on the floor (jumping or falling) 
		if Input.is_action_pressed("move_left"): #move character left while they are airborn
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0) # move in the negative x direction, don't move in the y direction

		if Input.is_action_pressed("move_right"):#move character right while they are airborn
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)# move in the positive x direction, don't move in the y direction

# function for maintaining the character body's maximum speed (in either x dir) allowed by the program
func _limit_speed():

	if velocity.x > speed_limit: 	# check if the velocity while moving right in the x direction is faster than the speed limit
		velocity = Vector2(speed_limit, velocity.y)# set x velocity back to the speed limit & maintain the y velocity

	if velocity.x < -speed_limit: 	# check if the velocity while moving left in the x direction is faster than the speed limit
		velocity = Vector2(-speed_limit, velocity.y) # set x velocity back to the speed limit & maintain the y velocity

func _apply_friction():
	#friction is applied when the character body is on the floor and the player is not attempting to move it left or right
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		velocity -= Vector2(velocity.x * friction, 0) #slow the character down based on the friction constant
		if abs(velocity.x) < 5: # if the velocity in x gets close enough to zero
			velocity = Vector2(0, velocity.y) # set the x velocity to zero

func _apply_gravity():
	if not is_on_floor(): # only apply gravity when the player is jumping / falling
		velocity += gravity # character accelerates downward the longer that they are airborn

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta): 
	_get_input()
	_limit_speed()
	_apply_friction()
	_apply_gravity()

	move_and_slide() # built-in function
	pass
