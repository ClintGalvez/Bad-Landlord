extends Node

var score = 0

onready var player = $YSort/Player
onready var guardDog = $"YSort/Guard Dog"

func _ready():
	randomize()
	
	# connect every object's 'destroyed' signal
	for object in $YSort.get_children():
		if object.get_filename() == "res://objects/Object.tscn": # check if the child is an instance of the object scene
			object.connect("destroyed", self, "updateScore")

func _process(delta):
	$HUD.updateTimer(round($Timer.time_left))
	
func newGame():
	# reset objects
	for object in $YSort.get_children():
		if object.get_filename() == "res://objects/Object.tscn": # check if the child is an instance of the object scene
			object.reset()
	
	score = 0
	$HUD.updateScore(score)
	
	player.start($StartPosition.position)
	guardDog.position = Vector2(256, 160)
	
	$StartTimer.start()
	$Music.play()
	
	$HUD.showMessage("Get ready...")
	
	yield($StartTimer, "timeout")
	
	$Timer.start()

func gameOver():
	player.hide()
	player.position.x = -56
	player.position.y = 56
	$HUD.showGameOver()
	$Music.stop()

func playerTool():
	$HUD.updateWepUI(player.getTool())

func updateScore(value):
	score += value
	$HUD.updateScore(score)
