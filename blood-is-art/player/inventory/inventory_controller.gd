extends Control
class_name InventoryController

var item_slot_count : int = 10
var inventory_slot_prefab : PackedScene = load("res://player/inventory/inventory_slot.tscn")

@onready var inventory_grid: GridContainer = %GridContainer

var inventory_slots : Array[InventorySlot] = []
var inventory_full : bool = false

func _ready() -> void:
	var slot = inventory_slot_prefab.instantiate() as InventorySlot
#	inventory_grid.add_child(slot)
	inventory_slots.append(slot)
