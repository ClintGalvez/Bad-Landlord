extends StaticBody2D

signal destroyed

enum materials {
	WOOD,
	METAL,
	FLESH
}

export(materials) var objMaterial
export(int, 1, 100) var maxHealth = 10
var health = maxHealth
export(int) var value = 1
export(String) var description = "description..."
export var toolBuff = 5 # additional damage taken if the player uses the correct tool in accordance to the object's material

var destroyed = false

func _ready():
	$HealthBar.hide()
	$HealthBar.min_value = 0
	$HealthBar.max_value = maxHealth

func _on_Hurtbox_area_entered(area):
	if (destroyed):
		return
	
	$HealthBar.show()
	
	var player = area.get_parent()
	
	# determine damage taken based on the tool used
	match player.getTool():
		0: # AXE
			if objMaterial == materials.WOOD:
				health -= player.getAttackDamage() * toolBuff
			else:
				health -= player.getAttackDamage()
		1: # HAMMER
			if objMaterial == materials.METAL:
				health -= player.getAttackDamage() * toolBuff
			else:
				health -= player.getAttackDamage()
		2: # BAT
			if objMaterial == materials.FLESH:
				health -= player.getAttackDamage() * toolBuff
			else:
				health -= player.getAttackDamage()
	
	$HealthBar.value = health
	
	# check if object is destroyed
	if health <= 0:
		destroy()

func destroy():
	health = 0
	emit_signal("destroyed", value)
	destroyed = true
	$AnimatedSprite.modulate = Color(0, 0, 0)
	$HealthBar.hide()
	$DestroyedSound.play()

func _on_DestroyedSound_finished():
	$DestroyedSound.stop()

func reset():
	show()
	$HealthBar.hide()
	health = maxHealth
	destroyed = false
