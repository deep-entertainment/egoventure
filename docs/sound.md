# Effects, music and background

*EgoVenture* includes a streamlined way to play sound effects, music and background sounds with its `Boombox` singleton.

For this, *EgoVenture* comes with a predefined [AudioBus layout](https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html), that is modified in the game's option menu and is used in the resources of the `Boombox`.

*Hint*: If you're not using the Egoventure Game Template, make sure to use *addons/egoventure/default_bus_layout.tres* as your default bus layout in the project settings.

See the [Boombox API docs](api/boombox.gd.md) for details.

When using  the`Boombox.play_music` function,  `Boombox` includes an audio fader that will fade from the currently playing track to the new one.

Of course, when a game is loaded, the music and background sound that was playing in the saved game, is loaded as well.
