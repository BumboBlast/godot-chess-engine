extends MarginContainer


signal choose_new_game
signal choose_cpu_move

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


func _on_New_Game_pressed():
	emit_signal("choose_new_game")


func _on_Something_pressed():
	emit_signal("choose_cpu_move")
