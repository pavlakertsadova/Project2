extends Node2D


enum MusicMode { MENU, MAIN, PUZZLE }

@export var menu_music: AudioStream
@export var main_music: AudioStream
@export var puzzle_music: AudioStream

@export var music_bus := "Music"
@export var base_volume_db := -8.0        # нормална сила
@export var fade_time := 0.8              # секунди (0.5–1.2 е приятно)
@export var silence_db := -60.0           # "тихо" (практически mute)

var _player: AudioStreamPlayer
var _tween: Tween
var _current_mode: int = -1
var _is_switching := false
var _queued_mode: int = -1

func _ready():
	_player = AudioStreamPlayer.new()
	add_child(_player)
	_player.bus = music_bus
	_player.volume_db = base_volume_db

func set_mode(mode: int):
	# ако в момента правим преход и ти извикаш пак set_mode,
	# запомняме последното желание и го изпълняваме след края
	if _is_switching:
		_queued_mode = mode
		return

	if mode == _current_mode:
		return

	var next_stream := _stream_for_mode(mode)
	if next_stream == null:
		return

	# ако вече свири същият stream, само запази mode и не рестартирай
	if _player.playing and _player.stream == next_stream:
		_current_mode = mode
		return

	_current_mode = mode
	_switch_with_fade(next_stream)

func _stream_for_mode(mode: int) -> AudioStream:
	match mode:
		MusicMode.MENU:   return menu_music
		MusicMode.MAIN:   return main_music
		MusicMode.PUZZLE: return puzzle_music
		_: return null

func _switch_with_fade(next_stream: AudioStream):
	_is_switching = true
	_kill_tween()

	# ако нищо не свири, директно fade-in
	if not _player.playing or _player.stream == null:
		_player.stream = next_stream
		_player.volume_db = silence_db
		_player.play()
		_tween = create_tween()
		_tween.tween_property(_player, "volume_db", base_volume_db, fade_time)
		_tween.finished.connect(_on_fade_finished)
		return

	# fade-out -> смяна -> fade-in
	_tween = create_tween()
	_tween.tween_property(_player, "volume_db", silence_db, fade_time)

	_tween.tween_callback(func ():
		_player.stop()
		_player.stream = next_stream
		_player.volume_db = silence_db
		_player.play()
	)

	_tween.tween_property(_player, "volume_db", base_volume_db, fade_time)
	_tween.finished.connect(_on_fade_finished)

func _on_fade_finished():
	_is_switching = false
	_kill_tween()

	# ако междувременно е поискан друг mode, изпълни го
	if _queued_mode != -1 and _queued_mode != _current_mode:
		var m := _queued_mode
		_queued_mode = -1
		set_mode(m)
	else:
		_queued_mode = -1

func _kill_tween():
	if _tween and is_instance_valid(_tween):
		_tween.kill()
	_tween = null
