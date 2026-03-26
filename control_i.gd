extends Control

@onready var line2d = $CanvasLayer/Line2D  # Referência ao Line2D
var brush_color : Color = Color(1, 0, 0)  # Cor do pincel (vermelho por padrão)
var drawing : bool = false

func _ready() -> void:
	line2d.default_color = brush_color  # Configura a cor padrão do Line2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if drawing:
			add_point(event.position)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drawing = event.pressed
			if drawing:
				line2d.clear_points()  # Limpa os pontos anteriores ao iniciar um novo desenho
				add_point(event.position)

func add_point(position: Vector2) -> void:
	line2d.add_point(position)  # Adiciona o ponto ao Line2D

func change_color(new_color: Color) -> void:
	brush_color = new_color  # Altera a cor do pincel
	line2d.default_color = brush_color  # Atualiza a cor no Line2D
