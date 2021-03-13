# Scenes and navigation

## Scenes

While the player moves around in the game, each view is made up of a Godot scene that contains [Hotspots](docs/hotspots.md) which trigger code that changes the current scene.

This makes designing a game straight forward.

## Caching and scene naming

Because changing scenes - especially with large images - takes time, *EgoVenture* includes a scene caching algorithm that preloads upcoming scenes in the background.

To achieve that, the algorith, expects that scene files names contain a numeric index.

Scene filenames need to start start with a letter, an underscore or a dash. At some point it needs to include a number. After that number any other character **other than a number** can follow.

Here are some examples:

* `woods1b2.tscn` **invalid**, because two numbers are included

* `Woods12.tscn` **invalid**, because it contains an upper case character

* `woods1secondtree.tscn` **valid**

When the player enters a scene (i.e. woods12.tscn) it will do the following:

* Cache scenes woods13 to woods15.tscn and woods11 to woods9.tscn (if they exist)

* Remove scenes woods8.tscn and woods16.tscn (if they exist)

*Note:* the amount of scenes the caching algorithm caches, defaults to *3*, but can be changed in the [Game configuration](docs/configuration.md). Remember, that more scenes require more memory.

## Locations

Because not all views can follow one another, *EgoVenture* includes a concept of *locations*. Locations allow scene files to be placed in a subdirectory. Together with `MapHotspots` and foreground caching, they allow seamless transition between ready-cached scenes.

## Four-Side-Room scenes

Because most of the scenes, the player walks through, consist of a front, right, left and back view, *EgoVenture* includes a helper scene `four_side_room.tscn`, that can be instantiated in a scene to speed up creating walk-throughs.

After instantiating it in the specific scene, it can be configured what images to show in on the four sides.

The four sides will be shown around the center like a cut-open box.

The scene will take care of showing the images and navigating left and right.

Additional hotspots (e.g. for moving forward) can be placed over the four sides.
