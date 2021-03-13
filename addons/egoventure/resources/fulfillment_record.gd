# A record wether the player how far the player has fulfilled
# a certain goal
class_name FulfillmentRecord
extends Resource

# The id of the corresponding goal
export(int) var goal_id: int

# An array of hints that were fulfilled
export(Array, int) var fulfilled: Array = []
