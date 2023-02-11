extends KinematicBody2D

signal currTool

enum tools {
	AXE,
	HAMMER,
	BAT
}

export(tools) var tool = tools.AXE
export var ACCELERATION = 10000
export var MAX_SPEED = 500
export var FRICTION = 10000
export var attackDamage = 1

enum states {
	MOVE,
	ATTACK,
	STUN
}

var state = states.MOVE
var velocity = Vector2.ZERO
var invincible = false
var stunned = false
var attackSoundPlayed = false

func _ready():
	hide()

func _process(delta):
	match state:
		states.MOVE:
			moveState(delta)
		states.ATTACK:
			attackState(delta)
		states.STUN:
			stunState(delta)

func moveState(delta):
	# get player move input
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()
	
	# determine player's move velocity and move the player + animate the player as well
	if inputVector != Vector2.ZERO:
		if (inputVector.x != 0):
			$Sprite.flip_h = inputVector.x < 0
		$AnimationPlayer.play("move")
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta) # accelerate
	else:
		$AnimationPlayer.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # slow to a halt
	move()
	
	# check if the player wants to interact with an object
	if Input.is_action_just_pressed("attack"):
		state = states.ATTACK
	
	# check if the player wants to swap tools
	if Input.is_action_just_pressed("axe"):
		print("equipped axe...")
		tool = tools.AXE
		emit_signal("currTool")
	if Input.is_action_just_pressed("hammer"):
		print("equipped hammer...")
		tool = tools.HAMMER
		emit_signal("currTool")
	if Input.is_action_just_pressed("bat"):
		print("equipped bat...")
		tool = tools.BAT
		emit_signal("currTool")

func move():
	velocity = move_and_slide(velocity)

func attackState(delta):
	velocity = Vector2.ZERO
	
	"""if !attackSoundPlayed:
		$AttackSound.play()
		attackSoundPlayed = true"""
	
	$AnimationPlayer.play("attack")

func attackAnimationFinished():
	state = states.MOVE

func _on_AttackSound_finished():
	$AttackSound.stop()
	attackSoundPlayed = false

func stunState(delta):
	if stunned: # don't play if currently stunned
		return
	
	$AnimationPlayer.play("stun")
	
	stunned = true

func stunAnimationFinished():
	$StunTimer.start()

func _on_StunTimer_timeout():
	stunned = false
	state = states.MOVE
	invincible = true
	$InvincibleTimer.start()

func start(newPosition):
	position = newPosition
	show()
	
func getTool():
	return tool

func getAttackDamage():
	return attackDamage

func _on_Hurtbox_area_entered(area):
	if !invincible:
		state = states.STUN

func _on_InvincibleTimer_timeout():
	invincible = false
