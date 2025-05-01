extends Control


func _on_new_game_pressed() -> void:
	pass 
	#Need a new scene created here where we name the new game and click "okay" button
	#After clicking okay it takes us to a fresh new game with no progress made



func _on_saved_game_pressed() -> void:
	pass
	# Take player to a new scene where there is a list of saved games based on "New game mode"
	# Allow player to click on a saved game and load progress point, last saved point. 



func _on_options_pressed() -> void:
	pass # Replace with function body.
 # Should take the player to a new scene with more buttons where "pressed()" turns settings on and off such as music
 # Maybe implement a music volume gliding scale? Future... future.. would need pixel art for these interactables



func _on_exit_pressed() -> void:
	get_tree().quit()
