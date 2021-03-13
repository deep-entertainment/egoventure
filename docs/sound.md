# Effects, music and background

*EgoVenture* includes a streamlined way to play sound effects, music and background sounds with its `Boombox` singleton.

For this, *EgoVenture* comes with a predefined [AudioBus layout](https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html), that is modified in the game's option menu and is used in the resources of the `Boombox`.

See the [Boombox API docs](api/boombox.gd.md) for details.

When using  the`Boombox.play_music` function,  `Boombox` includes an audio fader that will fade from the currently playing track to the new one.

Of course the currently played music and background sound are started when a game is loaded.
