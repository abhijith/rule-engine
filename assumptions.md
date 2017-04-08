#### The assumptions I have made for this project ...


* A request from a channel contains only 3 fields
	- country (String)
	- channel (String)
	- preferences (Array of Strings)

* The channel categories:
	- the categories are unique unique
	- a category can be a parent of a heirarchy of categories

* Channels
	- unique
	- may have categories associated with it

* Adverts
	- unique
	- have constraints associated with them.
	- have a global view limit
	- have a start and end date
	- may have country or channel specific limits

* Rules / Constraints
	- can be either simple expressions which evaluate to true | false
	- combined using either conjuctions or disjunctions.

* API
	- returns an advertisement or null given a match request
	- returns an advertisement or given an advertisement id

* On an average of 40 to 50 advertisements can be live at any point
