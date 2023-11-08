extends Node


onready var game: Node2D = $Game
onready var congrats_display: Control = $CongratsDisplay
onready var congrats_label: Label = $CongratsDisplay/CenterContainer/VBoxContainer/InfoLabel
onready var main_menu: Control = $MainMenu


func _ready() -> void:
	$AboutDialog/Container/TabContainer/About.bbcode_text = tr("ABOUT_TEXT")


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_FOCUS_OUT:
		get_tree().paused = true
	if what == NOTIFICATION_WM_FOCUS_IN:
		get_tree().paused = false


func start_game(mode: int) -> void:
	main_menu.hide()
	game.start(mode)


func end_game(catched_apples: int, time_away: float, mode: int) -> void:
	congrats_display.show()
	var string: String = ""
	match mode:
		game.MODE_TIME:
			string = "CONGRATULATIONS_INFO_TIME"
		game.MODE_COUNT:
			string = "CONGRATULATIONS_INFO_COUNT"
		game.MODE_ENDLESS:
			string = "CONGRATULATIONS_INFO_ENDLESS"
	var minutes = floor(time_away / 60)
	congrats_label.text = tr(string).format({"time_minutes": minutes, "time_seconds": round(time_away - (minutes * 60)), "count": catched_apples})


func _on_time_mode_choosed() -> void:
	start_game(game.MODE_TIME)


func _on_count_mode_choosed() -> void:
	start_game(game.MODE_COUNT)


func _on_endless_mode_choosed() -> void:
	start_game(game.MODE_ENDLESS)


func _on_rich_text_meta_clicked(meta) -> void:
	# warning-ignore:return_value_discarded
	OS.shell_open(meta)
