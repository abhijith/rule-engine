* Extending the rule engine to support new types and operators

	* New types added must implement the following interfaces
	  - id
	  - find(id)
	  - find_by_label(label)
	  - save
	  - destroy_all

	* Have to be entered in the FieldToType mapping whitelist in the rule engine

	* New operators
	  - Should return true | false
	  - Should be instance methods on each type
	  - Should take the request entities as argument
