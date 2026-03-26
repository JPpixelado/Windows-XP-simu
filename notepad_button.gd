extends Button

# Referência à janela que deseja mostrar
@onready var window = $Window  # Substitua \"$Window\" pelo caminho correto da sua janela se necessário.

func _on_pressed() -> void:
	if window:
		print("Mostrando a janela")
		window.show()  # Torna a janela visível
