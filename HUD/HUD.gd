extends CanvasLayer

signal startGame

func updateTimer(timeLeft):
	$TimerLabel.text = "TIMELEFT: " + str(timeLeft)

func updateScore(score):
	$ScoreLabel.text = "Insurance Money Earned: $" + str(score)

func showMessage(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func showGameOver():
	showMessage("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "BAD LANDLORD"
	$MessageLabel.show()
	yield(get_tree().create_timer(1.0), "timeout")
	$Button.show()
	
	# hide tools ui
	showTools(false)

func _on_Button_pressed():
	$Button.hide()
	
	# show tools ui
	showTools(true)
	
	emit_signal("startGame")

func showTools(show):
	if show:
		$AxeUI.show()
		$HammerUI.show()
		$BatUI.show()
	else:
		$AxeUI.hide()
		$HammerUI.hide()
		$BatUI.hide()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func updateWepUI(currTool):
	$AxeUI.set_scale(Vector2(1,1))
	$HammerUI.set_scale(Vector2(1,1))
	$BatUI.set_scale(Vector2(1,1))
	
	match currTool:
		0: # AXE
			$AxeUI.set_scale(Vector2(2,2))
		1: # HAMMER
			$HammerUI.set_scale(Vector2(2,2))
		2: # BAT
			$BatUI.set_scale(Vector2(2,2))
