# Basic Structure

This document outlines the basic design of *EgoVenture*.

*EgoVenture* makes heavy use of [singletons]([Singletons (AutoLoad) &mdash; Godot Engine (stable) documentation in English](https://docs.godotengine.org/en/stable/getting_started/step_by_step/singletons_autoload.html)). The central singletons are `EgoVenture`, which handles the most basic parts of the game, `Backpack` for inventory handling and `Boombox` for handling audio.

The whole game is made up of multiple Godot [scenes](scenes.md), that are switched when walking through the environments. Multiple parts of the environments (called *locations*) are bound together using a map scene. To optimize for performance and memory consumption, *EgoVenture* contains a scene caching algorithm that precaches upcoming scenes based on an index in their filenames and also removes unneeded scenes after a few steps.

Various tools like special *hotspots* are provided to ease and streamline game development.

[Signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) are used to communicate with the different components.

Various parts that build up the game are created using standard [Godot resources](https://docs.godotengine.org/en/stable/getting_started/step_by_step/resources.html). For example inventory items, the game's configuration or the *game state*, a standardized resource for storing variables about the progress in the game. Variables in that state can be used in the scenes to toggle sprites or hotspots.

Most tools use [Godot controls](https://docs.godotengine.org/en/stable/classes/class_control.html) to implement their actions. Also, the main menu is made up using controls and can completely by themed using [Godot themes](https://docs.godotengine.org/en/stable/tutorials/gui/gui_skinning.html) using [special theme overrides](theming.md).

Finally, there should be a core singleton for each game, that handles very basic stuff like initializing the state, and is used for configuring EgoVenture and handling signals.

## Canvas layers

EgoVenture uses CanvasLayers to stack different views over one another. The bigger This list records the IDs for reference:

| Layer | Resource | Description |
| -- | ---------| ----------- |
| 1 | inventory.tscn$Inventory/Canvas | The inventory bar |
| 90 | detail_view.tscn$DetailView | The inventory item detail view |
| 99  | parrot_dialog.tscn$ParrotDialog | Parrot's dialog character and subtitle view |
| 100 | map_notification.tscn$MapNotification | The overlay that shows up when the map notification is played |
| 125 | main_menu.tscn$MainMenu | The main menu |
| 126 | waiting_screen.tscn$WaitingScreen | The screen shown when filling the cache |
| 127 | menu_grab.tscn$MenuGrab | A tool layer to capture right mouse clicks and show the menu |
| 128 | speedy.tscn$MouseLayer | The custom mouse cursors |
