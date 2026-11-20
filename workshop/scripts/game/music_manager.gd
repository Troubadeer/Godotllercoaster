extends AudioStreamPlayer

var title : AudioStream = preload("res://assets/Music/TitleTheme.mp3")
var athletic : AudioStream = preload("res://assets/Music/Athletic.mp3")

func play_track(index : int) -> void:
	match index:
		1:
			stream = title
			play()
		2:
			stream = athletic
			play()
	
	
