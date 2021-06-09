# The MDNA main menu
extends CanvasLayer


# Emitted when the user wants to start a new game
signal new_game


# Emitted when the user wants to quit the game
signal quit_game


# Lowest Audio level
const AUDIO_MIN: float = -50.0

# Minimum number of seconds a speech or background sample should
# be played
const MINIMUM_SAMPLE_TIME: float = 2.0


# Wether the main menu can be hidden
var resumeable: bool = true

# Wether the a game can be saved
var saveable: bool = true

# Wether the menu can be displayed at all
var disabled: bool = false


# Currently selected save slot (used for overwrite confirmation dialog)
var _selected_slot: int

# Wether we are saving or loading
var _is_save_mode: bool

# The currently visible save slot page
var _save_slot_page: int = 1

# The configuration of this game
var _configuration: GameConfiguration


# Default to hiding the menu
func _ready():
	EgoVenture.connect("game_loaded", self, "toggle")


# Hide everything upon startup
func _enter_tree():
	$Menu.hide()
	$Menu/MainMenu.show()
	$Menu/SaveSlots.hide()
	$Menu/Options.hide()


# Handle wether the game is currently saveable
#
# ** parameters **
#
# - delta: Time in milliseconds since last call to _process
func _process(_delta):
	$Menu/MainMenu/Margin/VBox/MenuItems/Save.disabled = not saveable


# Configure the menu
# 
# ** Parameters **
#
# - configuration: The game configuration resource
func configure(configuration: GameConfiguration):
	_configuration = configuration
	
	# Set the different textures
	$Menu/MainMenu/Background.texture = configuration.menu_background
	$Menu/MainMenu/Margin/VBox/Logo.texture = configuration.design_logo
	$Menu/SaveSlots/Background.texture = configuration.menu_saveslots_background
	$Menu/SaveSlots/VBox/HBox/Previous.texture_normal = \
			configuration.menu_saveslots_previous_image
	$Menu/SaveSlots/VBox/HBox/Next.texture_normal = \
			configuration.menu_saveslots_next_image
	$Menu/Options/Background.texture = configuration.menu_options_background
	
	$Menu/QuitConfirm.dialog_text = configuration.menu_quit_confirmation
	$Menu/OverwriteConfirm.dialog_text = \
			configuration.menu_overwrite_confirmation
	$Menu/RestartConfirm.dialog_text = configuration.menu_restart_confirmation
	
	$Menu.theme = configuration.design_theme
	
	# Set option labels to the menu button style
	for label in [
		"SpeechLabel", 
		"MusicLabel", 
		"EffectsLabel", 
		"SubtitlesLabel",
		"Subtitles",
		"FullscreenLabel",
		"Fullscreen"
	]:
		var node = get_node("Menu/Options/CenterContainer/VBox/Grid/%s" % label)
		node.add_font_override(
			"font",
			$Menu.get_font(
				"menu_button",
				"Button"
			)
		)
		
	$Menu/SaveSlots/VBox/Title.add_font_override(
		"font",
		$Menu/SaveSlots/VBox/Title.get_font(
			"menu_button",
			"Button"
		)
	)
	
	# Set the options values
	$Menu/Options/CenterContainer/VBox/Grid/SpeechSlider.value = \
			_get_bus_percent("Speech")
	$Menu/Options/CenterContainer/VBox/Grid/MusicSlider.value = \
			_get_bus_percent("Music")
	$Menu/Options/CenterContainer/VBox/Grid/EffectsSlider.value = \
			_get_bus_percent("Effects")
	$Menu/Options/CenterContainer/VBox/Grid/Subtitles.pressed = \
			EgoVenture.options_get_subtitles()


# Toggle the display of the menu and play the menu music
func toggle():
	if resumeable and not disabled:
		if EgoVenture.game_started:
			$Menu/MainMenu/Margin/VBox/MenuItems/Resume.show()
			$Menu/MainMenu/Margin/VBox/MenuItems/Continue.hide()
		else:
			$Menu/MainMenu/Margin/VBox/MenuItems/Continue.show()
			$Menu/MainMenu/Margin/VBox/MenuItems/Resume.hide()
			
			if EgoVenture.has_continue_state():
				$Menu/MainMenu/Margin/VBox/MenuItems/Continue.disabled = false
			else:
				$Menu/MainMenu/Margin/VBox/MenuItems/Continue.disabled = true
		
		$Menu/MainMenu/Margin/VBox/MenuItems/Load.disabled = \
				not EgoVenture.saves_exist
		
		$Menu.visible = !$Menu.visible
		get_tree().paused = !get_tree().paused
		if _configuration.menu_music != null and $Menu.visible:
			if $Menu/Music.stream == null:
				$Menu/Music.stream = _configuration.menu_music
			$Menu/Music.play()
		elif _configuration.menu_music != null:
			$Menu/Music.stop()
		
		if not $Menu.visible:
			$Menu/SaveSlots.visible = false
		else:
			$Menu/Options/CenterContainer/VBox/Grid/Fullscreen.pressed = \
				EgoVenture.in_game_configuration.fullscreen
			Speedy.set_shape(Input.CURSOR_ARROW)
			if EgoVenture.is_touch:
				$Menu/MainMenu/Margin/VBox/MenuItems/Quit.hide()
				$Menu/Options/CenterContainer/VBox/Grid/Fullscreen.hide()
				$Menu/Options/CenterContainer/VBox/Grid/FullscreenLabel.hide()


# Resume was pressed. Toggle the menu
func _on_Resume_pressed():
	if disabled:
		disabled = false
	toggle()


# Quit was pressed. Show confirmation
func _on_Quit_pressed():
	$Menu/QuitConfirm.popup_centered()


# Quit was confirmed. Just quit the game
func _on_QuitConfirm_confirmed():
	emit_signal("quit_game")


# Save was pressed. Show saveslots in save mode
func _on_Save_pressed():
	$Menu/SaveSlots/VBox/Title.text = "Save game"
	_is_save_mode = true
	_refresh_saveslots()
	$Menu/SaveSlots.show()


# Load was pressed. Show saveslots in load mode
func _on_Load_pressed():
	$Menu/SaveSlots/VBox/Title.text = "Load game"
	_is_save_mode = false
	_refresh_saveslots()
	$Menu/SaveSlots.show()
	

# Cancel was pressed. Hide saveslots
func _on_SaveLoad_Cancel_pressed():
	$Menu/SaveSlots.hide()


# A save slot was selected
#
# ** Parameters **
#
# - slot: The save slot
# - exists: Wether the slot already contains a savegame
func _on_slot_selected(slot: int, exists: bool):
	if _is_save_mode:
		if exists:
			# This save slot exists, show the confirmation dialog
			_selected_slot = slot
			$Menu/OverwriteConfirm.popup_centered()
		else:
			if disabled:
				disabled = false
			# Briefly hide the menu to snapshot a picture of the current
			# scene
			toggle()
			Speedy.hidden = true
			yield(VisualServer, "frame_post_draw")
			var screenshot = get_viewport().get_texture().get_data()
			screenshot.resize(464, 268, Image.INTERPOLATE_NEAREST)
			screenshot.flip_y()
			screenshot.save_png("user://save_%d.png" % slot)
			yield(VisualServer, "frame_post_draw")
			Speedy.hidden = false
			EgoVenture.save(slot)
	else:
		if disabled:
			disabled = false
		EgoVenture.load(slot)


# Overwrite was confirmed, just call the event handler again ignoring
# the existing save slot
func _on_OverwriteConfirm_confirmed():
	_on_slot_selected(_selected_slot, false)


# Next page was pressed
func _on_Next_pressed():
	_save_slot_page = _save_slot_page + 1
	_refresh_saveslots()


# Previous page was pressed
func _on_Previous_pressed():
	if _save_slot_page > 1:
		_save_slot_page = _save_slot_page - 1
		_refresh_saveslots()


# Options was pressed
func _on_Options_pressed():
	$Menu/Options.show()


# Return was pressed on the options screen
func _on_Return_pressed():
	$Menu/Options.hide()


# The speech slider was changed
# 
# ** Parameters **
# 
# - value: new value
func _on_speech_Slider_value_changed(value):
	EgoVenture.options_set_speech_level(_percent_to_db(value))
	EgoVenture.set_audio_levels()
	if $Menu/Options.visible \
			and _configuration.menu_options_speech_sample != null \
			and not $Menu/Speech.playing:
		$Menu/Speech.stream = _configuration.menu_options_speech_sample
		$Menu/Speech.play()


# The music slider was changed
# 
# ** Parameters **
# 
# - value: new value
func _on_music_Slider_value_changed(value):
	EgoVenture.options_set_music_level(_percent_to_db(value))
	EgoVenture.set_audio_levels()


# The effects slider was changed
# 
# ** Parameters **
# 
# - value: new value
func _on_effects_Slider_value_changed(value):
	EgoVenture.options_set_effects_level(_percent_to_db(value))
	EgoVenture.set_audio_levels()
	if $Menu/Options.visible \
			and _configuration.menu_options_effects_sample != null \
			and not $Menu/Effects.playing:
		$Menu/Effects.stream = _configuration.menu_options_effects_sample
		$Menu/Effects.play()


# The subtitles checkbox was changed
#
# ** Parameters **
#
# - value: Wether the checkbox is checked or not
func _on_Subtitles_toggled(value: bool):
	EgoVenture.options_set_subtitles(value)
	if $Menu/Options.visible and _configuration.menu_switch_effect != null:
		$Menu/Effects.stream = _configuration.menu_switch_effect
		$Menu/Effects.play()


# Get the current volume level in db and convert it to a slider percent
# value from the specified bus
#
# ** Arguments **
# - bus_name: The name of the bus
#
# ** Returns **
# - The slider percent from 0 (- AUDIO_MIN db) to 100 (0 db)
func _get_bus_percent(bus_name: String) -> float:
	var db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name))
	return ((db + (AUDIO_MIN * -1)) * 100 / AUDIO_MIN) * -1


# Convert a slider percent level to db for an audiobus.
# 0 percent = -72db, 100 percent = 0 db
#
# ** Arguments **
# - percent: The percent value
#
# ** Returns **
# - The volume value in db
func _percent_to_db(percent: float) -> float:
	return ((AUDIO_MIN * -1) * percent / 100) + AUDIO_MIN


# Get the last modified timestamp in a readable date format for the
# save slots based on the format constant
#
# ** Arguments **
# - The slot file name
#
# ** Returns **
# - The last modification timestamp of the file in the date format as configured
#   in the constant
func _get_date_from_file(file: String) -> String:
	var timezone = OS.get_time_zone_info()
	var datetime = OS.get_datetime_from_unix_time(
		File.new().get_modified_time(file) + (timezone.bias * 60)
	)
	datetime['month'] = "%02d" % datetime['month']
	datetime['day'] = "%02d" % datetime['day']
	datetime['year'] = "%04d" % datetime['year']
	datetime['hour'] = "%02d" % datetime['hour']
	datetime['minute'] = "%02d" % datetime['minute']
	return tr(_configuration.menu_saveslots_date_format).format(datetime)


# Refresh the saveslots vie
func _refresh_saveslots():
	var save_dir = Directory.new()
	save_dir.open("user://")
	
	if _save_slot_page == 1:
		$Menu/SaveSlots/VBox/HBox/Previous.modulate = Color(1, 1, 1, 0)
		$Menu/SaveSlots/VBox/HBox/Previous.mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		$Menu/SaveSlots/VBox/HBox/Previous.modulate = Color(1, 1, 1, 1)
		$Menu/SaveSlots/VBox/HBox/Previous.mouse_default_cursor_shape = Control.CURSOR_FDIAGSIZE
	
	for slot in range(0, 12):
		var save_slot = ((_save_slot_page - 1) * 12) + slot
		
		# Set the slot stylebox
		var slot_node = $Menu/SaveSlots/VBox/HBox/Slots.get_node(
			"Slot%d" % (slot + 1)
		)
		(slot_node.get_node("Slot/Panel") as Panel) \
				.add_stylebox_override(
					"panel", 
					(slot_node.get_node("Slot/Panel") as Panel).get_stylebox(
						"saveslot_panel",
						"Panel"
					)
				)
		(slot_node.get_node("Slot/Date") as Label) \
				.add_font_override(
					"font",
					(slot_node.get_node("Slot/Date") as Label).get_font(
						"saveslots_date",
						"Label"
					)
				)
		
		var slot_panel_image: TextureButton
		var connect_signals: bool = true
		var slot_exists: bool = false
		
		var empty_image: Image = Image.new()
		empty_image.create(
			ProjectSettings.get("display/window/size/width") * 0.2,
			ProjectSettings.get("display/window/size/height") * 0.2,
			true,
			Image.FORMAT_RGBA8
		)
		empty_image.fill(EgoVenture.configuration.menu_saveslots_empty_color)
		var empty_image_texture = ImageTexture.new()
		empty_image_texture.create_from_image(empty_image)
		
		if save_dir.file_exists("save_%d.png" % save_slot) and \
			save_dir.file_exists("save_%d.tres" % save_slot):
			
			# The slot is already taken. Show the saved image and date
			slot_exists = true
			
			var slot_image = Image.new()
			slot_image.load("user://save_%d.png" % save_slot)	
			var slot_image_texture = ImageTexture.new()
			slot_image_texture.create_from_image(slot_image)
			slot_panel_image = slot_node.get_node("Slot/Panel/Image")
			slot_panel_image.texture_normal = slot_image_texture
			
			(slot_node.get_node("Slot/Date") as Label).text = \
					_get_date_from_file("user://save_%d.tres" % save_slot)
		else:
			
			# The slot is free. Show an empty panel and no date
			slot_panel_image = slot_node.get_node("Slot/Panel/Image")
			slot_panel_image.texture_normal = empty_image_texture
			
			(slot_node.get_node("Slot/Date") as Label).text = \
				EgoVenture.configuration.menu_saveslots_free_text
			
			if ! _is_save_mode:
				# Prohibit loading from empty slots
				connect_signals = false
			
		if connect_signals:
			# Connect the pressed signals for the slot in a clean way
			if slot_panel_image.is_connected(
				"pressed", 
				self, 
				"_on_slot_selected"
			):
				slot_panel_image.disconnect(
					"pressed", 
					self, 
					"_on_slot_selected"
				)
				
			slot_panel_image.connect(
				"pressed", 
				self, 
				"_on_slot_selected", 
				[save_slot, slot_exists]
			)


# The continue button was pressed
func _on_Continue_pressed():
	if disabled:
		disabled = false
	EgoVenture.load_continue()


# The New Game button was pressed
func _on_NewGame_pressed():
	if EgoVenture.has_continue_state():
		$Menu/RestartConfirm.popup_centered()
	else:
		_on_RestartConfirm_confirmed()


# Restarting the game was confirmed
func _on_RestartConfirm_confirmed():
	EgoVenture.reset()
	if disabled:
		disabled = false
	toggle()
	emit_signal("new_game")


# Toggle menu when rmb button clicked or esc pushed
func _on_Menu_gui_input(event):
	if event.is_action_released("ui_menu"):
		toggle()


# Stop speech sample on mouse release
func _on_SpeechSlider_gui_input(event):
	if event is InputEventMouseButton and not \
			(event as InputEventMouseButton).pressed:
		if $Menu/Speech.get_playback_position() < MINIMUM_SAMPLE_TIME:
			yield(
				get_tree().create_timer(
					MINIMUM_SAMPLE_TIME - $Menu/Speech.get_playback_position()
				), 
				"timeout"
			)
		$Menu/Speech.stop()


# Stop effects sample on mouse release
func _on_EffectsSlider_gui_input(event):
	if event is InputEventMouseButton and not \
			(event as InputEventMouseButton).pressed:
		if $Menu/Effects.get_playback_position() < MINIMUM_SAMPLE_TIME:
			yield(
				get_tree().create_timer(
					MINIMUM_SAMPLE_TIME - $Menu/Effects.get_playback_position()
				), 
				"timeout"
			)
		$Menu/Effects.stop()


func _on_Fullscreen_toggled(button_pressed):
	EgoVenture.in_game_configuration.fullscreen = button_pressed
	EgoVenture.save_in_game_configuration()
	EgoVenture.set_full_screen()
