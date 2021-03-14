# Tools

*EgoVenture* includes some smaller tools that standardize specific things or just makes them easier.

## Map notification

In the Carol Reed series of games, there are certain points where the player learns about a new location on the map. On these occasions an image is blinking and a sound is played.

The image and sound can be set in the [game configuration](configuration.md) and the notification can be triggered by calling:

```gdscript
MapNotification.notify()
```


