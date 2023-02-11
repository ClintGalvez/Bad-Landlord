extends KinematicBody2D

var speed = 100
var velocity = Vector2.ZERO
var player = null
var direction = Vector2.ZERO
var detected = false
var stunned = false
var hurtSoundPlayed = false

func _physics_process(delta):
	if stunned: # don't move while stunned
		return
	
	if detected:
		$AnimationPlayer.play("CHASE")
	
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * speed
	velocity = move_and_slide(velocity)
	
	if velocity.x < 0:
		$Sprite.flip_h = false
	elif velocity.x > 0:
		$Sprite.flip_h = true

func _on_DetectArea_body_entered(body):
	player = body
	detected = true
	$AnimationPlayer.play("CHASE")

func _on_DetectArea_body_exited(body):
	player = null
	detected = false
	$AnimationPlayer.play("IDLE")

func _on_Hurtbox_area_entered(area):
	var player = area.get_parent()
	if player.getTool() != 2: # only stunend if the player is using a  bat
		return
	
	# play hurt sound effect
	#$HurtSound.play()
	
	stunned = true
	$AnimationPlayer.play("IDLE")
	$StunTimer.start()

func _on_HurtSound_finished():
	$HurtSound.stop()

func _on_StunTimer_timeout():
	stunned = false
