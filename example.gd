extends Control

@onready var simple: Button = $CenterContainer/VBoxContainer/Simple
@onready var solitaire: Button = $CenterContainer/VBoxContainer/Solitaire

func _ready() -> void:
	simple.connect('pressed', _load_simple)
	solitaire.connect('pressed', _load_solitaire)
	
func _load_simple():
	get_tree().change_scene_to_file("res://simple-example/simple-example.tscn")
	
func _load_solitaire():
	get_tree().change_scene_to_file("res://solitaire/solitaire.tscn")
