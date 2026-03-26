extends Node2D

@export var max_icons := 8
@export var icon_lifetime := 5.0
@export var duplication_interval := 0.25          # tempo entre duplicatas
@export var max_duplications := 5                # limite forte para PCs fracos

var icon_paths := [
	"res://MEMZicon1.svg",
	"res://MEMZicon2.svg",
	"res://MEMZicon3.svg",
	"res://MEMZicon4.svg",
	"res://MEMZicon5.webp"
]

var sound_paths := [
	"res://start.mp3",
	"res://erro.mp3",
	"res://chord.mp3"
]

var current_icons := []
var current_duplications := 0
var is_active := false

@onready var spawn_timer := Timer.new()
@onready var duplication_timer := Timer.new()

var audio_players := []

func _ready():
	# Timer dos ícones
	add_child(spawn_timer)
	spawn_timer.wait_time = 0.15
	spawn_timer.timeout.connect(_spawn_memz_icon)
	
	# Timer das duplicatas de tela
	add_child(duplication_timer)
	duplication_timer.wait_time = duplication_interval
	duplication_timer.timeout.connect(_duplicate_screen)
	
	# 3 players de áudio (evita delay)
	for i in 3:
		var player = AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)

# Chamado pelo botão
func _on_memz_pressed() -> void:
	start_memz()

func start_memz():
	if is_active:
		return
	
	is_active = true
	spawn_timer.start()
	duplication_timer.start()
	print("MEMZ ATIVADO - Ícones + Duplicação de tela (máx 5)")

func stop_memz():
	is_active = false
	spawn_timer.stop()
	duplication_timer.stop()
	
	# limpa tudo
	for icon in current_icons:
		if is_instance_valid(icon): icon.queue_free()
	current_icons.clear()
	
	current_duplications = 0
	print("MEMZ desativado.")

func _spawn_memz_icon():
	if not is_active: return
	if current_icons.size() >= max_icons:
		_remove_oldest_icon()
	
	var icon = Sprite2D.new()
	icon.texture = load(icon_paths[randi() % icon_paths.size()])
	icon.position = get_global_mouse_position()
	
	# Efeito de entrada leve
	icon.scale = Vector2(0.2, 0.2)
	var t = create_tween()
	t.tween_property(icon, "scale", Vector2(1, 1), 0.25)
	
	add_child(icon)
	current_icons.append(icon)
	
	_play_random_sound()
	
	await get_tree().create_timer(icon_lifetime).timeout
	if is_instance_valid(icon):
		_remove_icon(icon)

func _duplicate_screen():
	if not is_active or current_duplications >= max_duplications:
		return
	
	current_duplications += 1
	
	# Pequeno delay para garantir que a captura pegue a tela atualizada
	await get_tree().process_frame
	
	var dup = TextureRect.new()
	dup.texture = get_viewport().get_texture()
	dup.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	
	# Escala progressivamente menor (efeito clássico do MEMZ)
	var scale_factor = 0.75 - (current_duplications * 0.09)
	dup.scale = Vector2(scale_factor, scale_factor)
	
	# Posição aleatória para dar sensação de caos
	dup.position = Vector2(
		randf_range(30, get_viewport_rect().size.x * 0.65),
		randf_range(30, get_viewport_rect().size.y * 0.65)
	)
	
	# Transparência leve + leve rotação para ficar mais troll
	dup.modulate.a = 0.9
	dup.rotation_degrees = randf_range(-8, 8)
	
	# IMPORTANTE: adiciona em um CanvasLayer ou no topo para ficar visível
	add_child(dup)
	
	print("Duplicata criada #", current_duplications)
	
	# Remove automaticamente depois de um tempo
	await get_tree().create_timer(10.0).timeout
	if is_instance_valid(dup):
		dup.queue_free()
		current_duplications = max(0, current_duplications - 1)
		
func _play_random_sound():
	if audio_players.is_empty(): return
	var player = audio_players[randi() % audio_players.size()]
	player.stream = load(sound_paths[randi() % sound_paths.size()])
	player.play()

# Funções de limpeza (mantidas iguais)
func _remove_oldest_icon():
	if current_icons.size() > 0:
		var oldest = current_icons.pop_front()
		if is_instance_valid(oldest):
			oldest.queue_free()

func _remove_icon(icon: Sprite2D):
	if is_instance_valid(icon) and current_icons.has(icon):
		current_icons.erase(icon)
		icon.queue_free()
