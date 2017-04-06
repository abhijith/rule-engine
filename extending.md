#### Extending the rule engine to support new types and operators

* New types added must implement the following interfaces

	- save
	- id
	- all
	- destroy_all
	- find(id)
	- find_by_label(str)

* Have to be entered in the FieldToType mapping whitelist in the rule engine

* New operators

	- Should return true | false
	- Should be instance methods on each type
	- Should take the request entities as argument
