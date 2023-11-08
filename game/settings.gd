extends HBoxContainer


const MUSIC = preload("res://assets/images/music.svg")
const MUSIC_MUTED = preload("res://assets/images/music_muted.png")
const SFX = preload("res://assets/images/sfx.png")
const SFX_MUTED = preload("res://assets/images/sfx_muted.png")
const CONFIG_PATH = "user://config.cfg"

onready var speed_spin_box = get_node("../MainMenu/CenterContainer/VBoxContainer/InitialAppleSpeed/SpinBox")
onready var music_player: AudioStreamPlayer = get_node("../Music")
onready var music_button: Button = $MusicButton
onready var sfx_button: Button = $SFXButton
onready var save_timer: Timer = $SaveTimer


var config = ConfigFile.new()
var music_muted: bool = false
var sfx_muted: bool = false


func _ready() -> void:
	config.load(CONFIG_PATH)
	music_muted = config.get_value("Sound", "music_muted", music_muted)
	sfx_muted = config.get_value("Sound", "sfx_muted", sfx_muted)
	speed_spin_box.value = config.get_value("User", "speed", speed_spin_box.value)
	update_music_mute()
	update_sfx_mute()


func update_music_mute():
	if music_muted:
		music_player.stop()
	else:
		music_player.play()
	music_button.icon = MUSIC_MUTED if music_muted else MUSIC


func update_sfx_mute():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), sfx_muted)
	sfx_button.icon = SFX_MUTED if sfx_muted else SFX


func save_config():
	config.set_value("Sound", "music_muted", music_muted)
	config.set_value("Sound", "sfx_muted", sfx_muted)
	config.set_value("User", "speed", speed_spin_box.value)
	config.save(CONFIG_PATH)


func _start_timer(_value) -> void:
	save_timer.start()


func _on_music_button_pressed() -> void:
	music_muted = not music_muted
	update_music_mute()
	save_timer.start()


func _on_sfx_button_pressed() -> void:
	sfx_muted = not sfx_muted
	update_sfx_mute()
	save_timer.start()
