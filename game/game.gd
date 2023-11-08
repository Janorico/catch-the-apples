extends Node2D


enum {
	MODE_TIME = 0,
	MODE_COUNT = 1,
	MODE_ENDLESS = 2
}

const APPLE: PackedScene = preload("res://game/apple.tscn")

onready var progress: ProgressBar = $Progress
onready var progress_label: Label = $Progress/Label
onready var apples: Node2D = $Apples
onready var basket: Sprite = $Basket
onready var catched_sfx: AudioStreamPlayer = $CatchedSFX
onready var failed_sfx: AudioStreamPlayer = $FailedSFX
onready var inital_apple_speed: SpinBox = get_node("../MainMenu/CenterContainer/VBoxContainer/InitialAppleSpeed/SpinBox")

var mode: int = MODE_TIME
var active: bool = false
var catched_apples: int = 0
var time_away: float = 0.0
var mouse_pressed: bool = false


func _physics_process(delta: float) -> void:
	if not active:
		return
	time_away += delta
	if mode == MODE_COUNT:
		update_progress_gui()
	basket.position.x += Input.get_axis("move_left", "move_right") * 320 * delta
	basket.position.x = clamp(basket.position.x, 0, 1031)


func start(game_mode: int) -> void:
	mode = game_mode
	active = true
	catched_apples = 0
	time_away = 0.0
	match mode:
		MODE_TIME:
			progress.max_value = 10
			progress.step = 1
		MODE_COUNT:
			progress.max_value = 60
			progress.step = 0.01
		MODE_ENDLESS:
			progress.hide()
	update_progress_gui()
	spawn_apple()


func end() -> void:
	active = false
	get_parent().end_game(catched_apples, time_away, mode)
	progress.show()
	progress.value = 0
	progress_label.text = "0"
	basket.position.x = 515.5


func update_progress_gui():
	match mode:
		MODE_TIME:
			progress_label.text = "%d/10" % catched_apples
			progress.value = catched_apples
		MODE_COUNT:
			if time_away >= 60:
				end()
				return
			progress_label.text = "%.0f/60" % time_away
			progress.value = time_away


func spawn_apple()  -> void:
	if not active:
		return
	var apple = APPLE.instance()
	apple.connect("failed", self, "_on_apple_failed")
	apple.y_velocity = inital_apple_speed.value
	apple.position.x = randi() % 1032
	apples.add_child(apple)


func _on_apple_catched(apple: Area2D) -> void:
	apple.get_parent().queue_free()
	catched_apples += 1
	catched_sfx.play()
	if mode == MODE_TIME:
		update_progress_gui()
		if catched_apples >= 10:
			end()
			return
	spawn_apple()


func _on_apple_failed(apple) -> void:
	apple.queue_free()
	failed_sfx.play()
	if mode == MODE_ENDLESS:
		end()
	spawn_apple()
