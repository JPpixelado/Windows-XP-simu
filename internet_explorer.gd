extends Window


func _on_close_requested() -> void:
	if confirm_close():  # Funcionalidade de confirmação
		print("A janela foi fechada")
		hide()  # Oculta a janela ao invés de fechar a aplicação
	else:
		print("Fechamento da janela cancelado")

func confirm_close() -> bool:
	# Aqui você pode implementar uma caixa de diálogo para confirmação.
	# Retorne true se o usuário confirmar que deseja fechar.
	return true  # Simulando confirmação; substitua com a lógica apropriada



func _on_internet_pressed() -> void:
	visible = !visible
