extends RichTextLabel

# === Falas ===
var words: Array[String] = [
	"Oi!", "Como você está?", "Bem-vindo ao jogo!", "Divirta-se!", "Até logo!",
	"Eu vou destruir seu PC!", "meu deus do céu não sobrou nada!",
	"você é beta! eu que farmo aura!", "Eu sou um vírus cabuloso!",
	"Davi tá rebolando pros crias?", "segue o JP pixelado!",
	"caguei um toletão grosso de bosta", "RECEBA!", "15:59"
]

# === Sons (mesma ordem) ===
var voice_sounds: Array[String] = [
	"res://bonzi_oi.mp3", "res://bonzi_como_esta.mp3", "res://bonzi_bem_vindo.mp3",
	"res://bonzi_divirta_se.mp3", "res://bonzi_ate_logo.mp3", "res://bonzi_destruir_pc.mp3",
	"res://bonzi_nao_sobrou_nada.mp3", "res://bonzi_beta.mp3", "res://bonzi_virus_cabuloso.mp3",
	"res://bonzi_davi_rebolando.mp3", "res://bonzi_jp_pixelado.mp3", "res://bonzi_toletao.mp3",
	"res://bonzi_receba.mp3", "res://bonzi_1559.mp3"
]

@onready var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()

var timer: float = 0.0
var change_interval: float = 3.0

# Contadores para conquistas
var total_falas_ouvidas := 0
var vezes_destruir_pc := 0

# Sinal que a janela de conquista vai ouvir
signal achievement_unlocked(title: String, description: String)

func _ready() -> void:
	add_child(audio_player)
	update_random_word()

func _process(delta: float) -> void:
	timer += delta
	if timer >= change_interval:
		timer = 0.0
		if get_parent().visible:
			update_random_word()

func update_random_word() -> void:
	var index = randi() % words.size()
	text = words[index]
	
	if index < voice_sounds.size():
		audio_player.stream = load(voice_sounds[index])
		audio_player.play()
	
	print("Bonzi falou: ", text)
	
	# Sistema de conquistas
	total_falas_ouvidas += 1
	if words[index] == "Eu vou destruir seu PC!":
		vezes_destruir_pc += 1
	
	_check_achievements()

func _check_achievements():
	if total_falas_ouvidas == 2:
		achievement_unlocked.emit("Primeiro Contato", "Você ouviu o Bonzi pela primeira vez!")
	
	if total_falas_ouvidas == 10:
		achievement_unlocked.emit("Amigo do Bonzi", "Ouviu o Bonzi falar 10 vezes!")
	
	if vezes_destruir_pc == 3:
		achievement_unlocked.emit("Vítima do Bonzi", "O Bonzi ameaçou destruir seu PC 3 vezes!")
	if vezes_destruir_pc == 4:
		achievement_unlocked.emit("Vítima do Bonzi", "O Bonzi ameaçou destruir seu PC 4 vezes!")
