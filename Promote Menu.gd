extends Control


func _ready():
	visible = false
	$VBoxContainer/ConfirmPromotion.disabled = true


func place_promote_menu():
	var board_rect = get_parent().get_child(0).get_child(0).spriteRect

	margin_top = board_rect.position[0]
	margin_right = board_rect.position[1]
	margin_left = board_rect.size[0]
	margin_bottom = board_rect.size[1]
	
	visible = true

var chosen_promotion: String

func handle_promote_menu():
	place_promote_menu()
	yield(resolve_promote_menu(), "completed")
	print("You chose a ", chosen_promotion)
	
	visible = false
	return chosen_promotion






func resolve_promote_menu():
	yield($VBoxContainer/ConfirmPromotion, "pressed")




func _on_ChooseQueen_pressed():
	chosen_promotion = "Queen"
	$VBoxContainer/ConfirmPromotion.disabled = false

func _on_ChooseBishop_pressed():
	chosen_promotion = "Bishop"
	$VBoxContainer/ConfirmPromotion.disabled = false

func _on_ChooseRook_pressed():
	chosen_promotion = "Rook"
	$VBoxContainer/ConfirmPromotion.disabled = false

func _on_ChooseKnight_pressed():
	chosen_promotion = "Knight"
	$VBoxContainer/ConfirmPromotion.disabled = false
