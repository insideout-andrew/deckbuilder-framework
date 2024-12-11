extends Control

@onready var simple: Button = $CenterContainer/VBoxContainer/Simple
@onready var solitaire: Button = $CenterContainer/VBoxContainer/Solitaire
@onready var typical_hand: Button = $CenterContainer/VBoxContainer/TypicalHand

func _ready() -> void:
	solitaire.connect('pressed', func(): get_tree().change_scene_to_file("res://solitaire/solitaire.tscn"))
	simple.connect('pressed', func(): get_tree().change_scene_to_file("res://simple/simple.tscn"))
	typical_hand.connect('pressed', func(): get_tree().change_scene_to_file("res://fancy/fancy.tscn"))
