extends Control

# Usando os nomes reais que aparecem na sua árvore
@onready var title_label: Label = $Panel/HBoxContainer/VBoxContainer/Label
@onready var desc_label: Label = $Panel/HBoxContainer/VBoxContainer/Label2   # o segundo Label

func _ready():
	modulate.a = 0.0   # começa invisível

func show_achievement(title: String, description: String):
	if title_label:
		title_label.text = title
	if desc_label:
		desc_label.text = description
	
	# Animação de entrada suave
	var tween_in = create_tween()
	tween_in.tween_property(self, "modulate:a", 1.0, 0.4)
	
	# Some automaticamente após 4 segundos
	await get_tree().create_timer(4.0).timeout
	
	var tween_out = create_tween()
	tween_out.tween_property(self, "modulate:a", 0.0, 0.6)
	await tween_out.finished
	
	queue_free()

# Posiciona no canto superior direito
func _enter_tree():
	position = Vector2(get_viewport_rect().size.x - size.x - 40, 40)
