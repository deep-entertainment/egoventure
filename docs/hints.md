# Hint system

*EgoVenture* includes a hint system called `Notebook`.

It is designed to be a list of goals with a list of associated hints that are progressed as the player advances in the game. When the player has done something or has been somewhere, a hint can be progressed and the next hint is shown in the notepad. Once all hints are progressed, the next goal is reached.

The hint progression are stored in save games.

## The hints file

Goals and hints are stored in a file in CSV format with the extension TXT (due to Godot issue [#38957](https://github.com/godotengine/godot/issues/38957)).

The *EgoVenture Game Template* includes a sample file.

The hints file is referenced in the [game configuration](configuration.md) and loaded when the game is loaded.

## Progressing hints

When the player advanced to a certain point in the game that would progress a hint, the following code needs to be called:

```gdscript
Notepad.progress_goal(goal_id: int, hint_id: int)
```

So to progress from the first goal, first hint to the second hint of the first goal, call:

```gdscript
Notepad.progress_goal(1, 1)
```

If all hints of a goal are progressed, `Notepad` automatically moves to the next goal.

For details, check out the [Api-Docs](api/notepad.gd.md).
