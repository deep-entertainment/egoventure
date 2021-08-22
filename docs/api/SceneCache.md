<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# SceneCache

**Extends:** [Node](../Node)

## Description

A rolling cache to preload scenes for a better performance
Uses the ResourceQueue as described in the Godot documentation

## Method Descriptions

### \_init

```gdscript
func _init(cache_count: int, scene_path: String, scene_regex: String, permanent_cache: PoolStringArray)
```

### update\_progress

```gdscript
func update_progress()
```

Update the current progress on the waiting screen and emit the queue_complete
signal when we're done

### get\_scene

```gdscript
func get_scene(path: String) -> PackedScene
```

Retrieve a scene from the cache. If the scene wasn't already cached,
this function will wait for it to be cached.

** Parameters **

- path: The path to the scene

### update\_cache

```gdscript
func update_cache(current_scene: String) -> int
```

Update the cache. Start caching new scenes and remove scenes, that
are not used anymore

** Parameters **

- current_scene: The path and filename of the current scene
**Returns** Number of cached scenes

## Signals

- signal queue_complete(): All pending resources were loaded
