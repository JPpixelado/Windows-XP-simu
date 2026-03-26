extends TextureRect


func _on_start_pressed() -> void:
	print("O botão start chamou uma função no TextureRect!")
	visible = !visible
