extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -100.0

var is_attacking = false
var is_climbing = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_Space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if !is_attacking:
		player_animation()

func _input(event):
	if event.is_action_pressed("ui_F"):
		is_attacking = true
		$AnimatedSprite2D.play("attack")
	
	if is_climbing == true and Input.is_action_pressed("ui_up"):
		$AnimatedSprite2D.play("climb")
		velocity.y = -300
	else:
		is_climbing = false
	

#animation
func player_animation():
	if Input.is_action_pressed("ui_left"): #|| Input.is_action_just_released("ui_Space"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = 7
		
	if Input.is_action_pressed("ui_right"): #|| Input.is_action_just_released("ui_Space"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = -7
	
	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle")


func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
