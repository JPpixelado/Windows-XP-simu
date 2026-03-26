extends Window

func _on_close_requested() -> void:
	if confirm_close():
		queue_free()  # Fecha a janela
	else:
		print("Fechamento cancelado")

func confirm_close() -> bool:
	# Aqui você pode adicionar uma caixa de diálogo real
	return true  # Confirmação direta (substitua conforme necessário)   


func _on_paintbutton_pressed() -> void:
	visible = !visible
