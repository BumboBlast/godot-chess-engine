extends MarginContainer


signal choose_new_game
signal choose_cpu_move
signal choose_load_fen
signal choose_get_fen

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


func _on_New_Game_pressed():
	emit_signal("choose_new_game")

func _on_Something_pressed():
	emit_signal("choose_cpu_move")

func _on_Load_FEN_Button_pressed():
	emit_signal("choose_load_fen")

func _on_Get_FEN_Button_pressed():
	emit_signal("choose_get_fen")




func _on_FEN_label_focus_entered():
	print(" now typing... ")

