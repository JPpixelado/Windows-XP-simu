extends Sprite2D

var is_dragging : bool = false
var drag_offset : Vector2

# Referência ao RichTextLabel (filho)
@onready var speech_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	var speech_label = $RichTextLabel
	
	if speech_label and speech_label.has_signal("achievement_unlocked"):
		# Evita conectar várias vezes
		if speech_label.achievement_unlocked.is_connected(_on_achievement_unlocked):
			speech_label.achievement_unlocked.disconnect(_on_achievement_unlocked)
		
		speech_label.achievement_unlocked.connect(_on_achievement_unlocked)
	else:
		push_error("RichTextLabel_Bonzi não encontrado ou não tem o sinal!")
		
func _on_achievement_unlocked(title: String, description: String):
	var popup_scene = preload("res://achievement_popup.tscn")
	if popup_scene:
		var popup = popup_scene.instantiate()
		add_child(popup)
		popup.show_achievement(title, description)
	else:
		push_error("achievement_popup.tscn não encontrado!")

# === Arrastar o Bonzi ===
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = event.pressed
		if is_dragging:
			drag_offset = position - get_global_mouse_position()

	if event is InputEventMouseMotion and is_dragging:
		position = get_global_mouse_position() + drag_offset

# === Botão para esconder/mostrar o Bonzi ===
func _on_bonzi_pressed() -> void:
	visible = !visible

func bonzi_pressed() -> void:
	visible = !visible
