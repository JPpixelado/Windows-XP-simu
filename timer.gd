extends Timer

func _on_ready() -> void:
	print("Timer está pronto e vai começar a contar!")
	one_shot = true
	wait_time = 5.0
	start()
	
func _on_timeout():
	print("4 segundos acabaram! Vamos fechar o jogo.")
	get_tree().quit()  # Fecha o jogo
