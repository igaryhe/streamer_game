extends Node
class_name SLocator

class ServiceManager:
	var _services : Dictionary = {}
	func fetch(type: Variant):
		if !_services.has(type): return null
		return _services[type]
	
	func register(type: Variant, service: Object) -> bool:
		if _services.has(type): return false
		_services[type] = service
		return true
	
	func deregister(type: Variant) -> void:
		_services.erase(type)

static var global : SLocator : 
	get:
		if (_global == null): 
			_global = SLocator.new(); _global.name = "SLocator[Global]"
			Engine.get_main_loop().root.call_deferred("add_child",_global)
		return _global
static var _global :SLocator = null
static var _serviceLocators : Dictionary = {}

var _services : ServiceManager = ServiceManager.new()
var with_node : Node = null
	
func _enter_tree() -> void:
	_services = ServiceManager.new()
	
static func with(node: Node) -> SLocator:
	if (_serviceLocators.has(node)): return _serviceLocators[node]
	return with_parent(node)

static func with_parent(node: Node) -> SLocator:
	var parent = node.get_parent()
	if (parent != null):
		if (_serviceLocators.has(parent)):
			return _serviceLocators[parent]
		else:
			return with_parent(parent)
	return global

static func add_to(node: Node) -> SLocator:
	if _serviceLocators.has(node) : 
		printerr("node already have service locator")
		return null
	var locator = SLocator.new()
	locator.with_node = node
	locator.name = "SLocator[%s]" % [node.name] 
	_serviceLocators[node] = locator
	node.add_child(locator)
	return locator

static func remove_from(node: Node) -> void:
	_serviceLocators.erase(node)
	
### fetch(service) in _ready()
### example: @onready var player : PlayerController = SLocator.with(self).fetch(PlayerController)
func fetch(type: Variant) -> Object:
	var service = _fetch(type)
	if (service == null):
		printerr("SLocator[%s] NOT register with type:[%s]" % [self.name , str(type)])
		printerr(get_stack())
	return service

func _fetch(type: Variant) -> Object:
	var service = _services.fetch(type);
	if (service != null): return service;
	var next = _try_fetch_in_hierarchy()
	if (next != null):
		service = next.fetch(type)
	if (service != null): return service;
	return null

### use await to wait service ready.
func wait_fetch(type: Variant) -> Object:
	while(true):
		var service = _fetch(type)
		if service != null : return service
		await Engine.get_main_loop().process_frame
	return null

func _try_fetch_in_hierarchy() -> SLocator:
	if self == global:
		return null
	var locator = with_parent(with_node)
	return locator	
	
func register_type(type: Variant, service: Object) -> SLocator:
	if (!_services.register(type, service)): 
		printerr(str(self) + " alreay register with type:" + str(type))
	return self

### register service when _enter_tree()
func register(service: Object) -> SLocator:
	register_type(service.get_script(), service)
	return self

func deregister(type: Variant) -> SLocator:
	_services.deregister(type)
	return self

func _exit_tree() -> void:
	remove_from(with_node)
