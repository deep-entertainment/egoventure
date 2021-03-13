# The game state

*EgoVenture* uses the concept of a *game state*. This state is a standard [Godot resource](https://docs.godotengine.org/en/stable/getting_started/step_by_step/resources.html) that extends the included `BaseState` class and contains all variables the game developer needs to store information about the player's progress in the game.

The game state from the *EgoVenture Game Template* looks like this:

`game_state.gd`

```gdscript
# The game state
class_name GameState
extends BaseState

# Add variables about your game here
#export(bool) var met_stina = false
```

The three first lines are basically just setting up the state resource. After that, any standard variable of a [Godot built-in type](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html#built-in-types) can be used to store game information. It's important to **export** each variable.

While each built-in type is supported, it is **recommended** to only use very basic types like `bool`, `int`, `float` and `string`.

For details see the [BaseState API-Docs](api/BaseState.md).
