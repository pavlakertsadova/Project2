extends Node

var _force_instant := false
enum MusicMode { MENU, MAIN, PUZZLE, FINAL }

@export var menu_music: AudioStream
@export var main_music: AudioStream
@export var puzzle_music: AudioStream
@export var final_music: AudioStream

@export var music_bus := "Music"
@export var base_volume_db := -10.0      # малко по-тихо = по-приятно
@export var fade_time := 1.4             # пробвай 1.2–2.0
@export var silence_db := -60.0

var _a: AudioStreamPlayer
var _b: AudioStreamPlayer
var _active: AudioStreamPlayer
var _inactive: AudioStreamPlayer
var _tween: Tween
var _current_mode: int = -1

func _ready():
	_a = _make_player()
	_b = _make_player()
	_active = _a
	_inactive = _b

func _make_player() -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	add_child(p)
	p.bus = music_bus
	p.volume_db = silence_db
	return p

func set_mode(mode: int):
	if mode == _current_mode:
		return

	var next_stream := _stream_for_mode(mode)
	if next_stream == null:
		return

	# ако вече свири същия stream (в активния), не прави нищо
	if _active.playing and _active.stream == next_stream:
		_current_mode = mode
		return

	_current_mode = mode
	_crossfade_to(next_stream)
	
func set_final_instant():
	_force_instant = true
	set_mode(MusicMode.FINAL)

func _stream_for_mode(mode: int) -> AudioStream:
	match mode:
		MusicMode.MENU:   return menu_music
		MusicMode.MAIN:   return main_music
		MusicMode.PUZZLE: return puzzle_music
		MusicMode.FINAL: return final_music
		_: return null

func _crossfade_to(next_stream: AudioStream):
	if _force_instant:
		_force_instant = false
		_active.stop()
		_active.stream = next_stream
		_active.volume_db = base_volume_db
		_active.play()
		return
	_kill_tween()

	# Подготви inactive да пусне новата музика тихо
	_inactive.stop()
	_inactive.stream = next_stream
	_inactive.volume_db = silence_db
	_inactive.play()

	# Tween: новата влиза, старата излиза (едновременно)
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_SINE)     # по-мек преход
	_tween.set_ease(Tween.EASE_IN_OUT)

	_tween.parallel().tween_property(_inactive, "volume_db", base_volume_db, fade_time)
	_tween.parallel().tween_property(_active, "volume_db", silence_db, fade_time)

	_tween.finished.connect(func ():
		_active.stop()
		# разменяме ролите
		var tmp = _active
		_active = _inactive
		_inactive = tmp
	)

func _kill_tween():
	if _tween and is_instance_valid(_tween):
		_tween.kill()
	_tween = null
