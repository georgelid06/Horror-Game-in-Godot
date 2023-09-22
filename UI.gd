extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	print_tree_pretty()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_timer_timeout():
	$Flashlight.value+=1


func _on_timer_2_timeout():
	pass # Replace with function body.


func _on_flashlight_changed():
	print("Update")
