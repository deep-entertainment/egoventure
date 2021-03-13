# Hotspots

*EgoVenture* includes various clickable areas called *hotspots* to ease, speedup and streamline game development. 

## Hotspot

`Hotspot` is a swiss-army knife hotspot for various things. It allows to specify a *type*, which defines the mouse cursor when hovering over it and sets the image for the hotspot indicator.

If a `target_scene` is specified, clicking on the hotspot will change the current scene to that and thus makes the hotspot useful for navigating around. Four scenes that utilize the four-side-room scene, a `target_view` in that scene can also be specified.

The `pressed` signal can be used to manually execute code instead of changing a scene (e.g. triggering game actions).

For details, refer to the [Hotspot API doc](api/Hotspot.md).

## LookHotspot

A `LookHotspot` triggers a *Parrot* dialog when clicked. The dialog resource need to be configured on the hotspot.

The mouse cursor and hotspot indicator is an image for a "look" action.

For details, refer to the [LookHotspot API doc](api/LookHotspot.md).

## MapHotspot

The `MapHotspot` is specifically used in map scenes. Additionally to the `target_scene` and `target_view` from the Hotspot, it also needs a `target_location`.

When clicked, it switches the location, starts a location-specific music, caches the scenes around the target scene and shows a loading image.

After the caching is done, the scene is changed.

For details, refer to the [MapHotspot API doc](api/MapHotspot.md).

## WalkHotspot

The `WalkHotspot` is small utility hotspot that eases the process of additional creating navigation hotspots in the four-view-room scenes (e.g. forward/backward). They share a default size, which can be configured in the project settings under EgoVenture/Hotspots:

![Walk hotspots configuration](/Users/dennis.ploeger/Library/Mobile%20Documents/com~apple~CloudDocs/Dennis/Hobbies/games/MDNA/images/e8d99d8abd06758fae934dd4023fa33fa6688cff.png)

For details, refer to the [WalkHotspot API doc](api/WalkHotspot.md).

## TriggerHotspot

The `TriggerHotspot` is used for areas on-screen that can be used with an inventory item. It holds a list of valid inventory items that will react to it by changing the mouse cursor to its active image.

When no inventory item is selected, the cursor for the "Use"-Type is used.

For details, refer to the [TriggerHotspot API doc](api/TriggerHotspot.md).

## Hotspot indicators

*EgoVenture* games include a feature to show all the hotspots in a scene using a touch button or a key. When the player executes that action, all images defined as hotspot indicators (look above) are displayed.
