#### Dependencies
--
	* Ruby
	* Bundler

#### Cloning and installing the application
--

	$ git clone ssh://git@bitbucket.org/abhijithg/rpm.git
	$ bundle install --path vendor/bundle

#### Project Tree:
--


#### Running the code
--

* Starting the application

	$ cd rpm
	$ bundle exec ruby rpm.rb # starts the webserver on port localhost:4567

* Tests

	$ cd rpm
	$ bundle exec ruby tests/all.rb          # run all tests
	$ bundle exec ruby tests/<name>_test.rb  # run specific-test

#### Assumptions
--
* Request from a channel contains 3 fields
  - country (String)
  - channel (String)
  - preferences (Array of Strings)

* Categories
  - unique
  - can be heirarchies

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

#### Components
--
* Request handler / webserver

* Advertisement selector

* Rule engine

#### Flow of control:
--
* Advert matching
  - Webserver accepts requests
  - Advertisement selector iterates through _live_ and _available_ advertisements.
  - Rule evaluates request against advertisement constraints and returns true|false.
  - An advertisement is returned if one or more advertisements satisfy the constraints (ties are broken arbitrarily).
  - Views are updated when an advert is selected

* Advert get
  - Lookups the id in the DB and returns an advert with the specified id is found

#### Component descriptions

** Types / Classes
	* Request
	  - attributes:

	* Channel
	  - attributes:

	* Country
	  - attributes:

	* Advert
	  - attributes:

	* Limit
	  - attributes:

	* Expr
	  - attributes:

** URLs exposed via the webserver
	* /
	- GET
	- Params: None
	- Initializes sample data

	* /flush
	- GET
	- Params: None
	- Clears the sample data

	* /ads/<id>
	- GET
	- Params: id
	- Gets the advertisement matching the id

	* /match
	- POST
	- Content-type: JSON
	- Params:{ channel: "example.com",  preferences: ["pref1", "pref2"], country: "country1" }

** Extending the rule engine to support new types and operators

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
