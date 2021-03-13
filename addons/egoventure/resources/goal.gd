# A goal in the notepad hint system
class_name Goal
extends Resource


# The numeric id of this goal
export (int) var id


# The title of the goal
export (String) var title


# A list of hints
export (Array, String) var hints


# The last hint currently visible
export (Array, bool) var hints_fulfilled
