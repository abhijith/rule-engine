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
	$ bundle exec ruby tests/test_<file>.rb  # run specific-test

#### Assumptions
--
* Request from a channel contains 3 fields
  - country (String representation of country)
  - channel (String representation of channel)
  - preferences (Array of String representation of Category)

* Categories are unique

* Channels are unique

* Preferences are unique

* Adverts are unique

* Adverts have constraints associated with them.

* Adverts have a global view limit

* Adverts may have country or channel specific limits

* Rules / Constraints can be either simple expressions or compound expressions combined using either conjuctions or disjunctions.

* The application returns an advertisement or null for an advertisement matching request

* The application returns an advertisement for an advertisement id

#### Components
--
* Request handler / webserver

* Advertisement selector

* Rule engine

#### Flow:
--
* Webserver accepts requests

* Advertisement selector iterates through _live_ and _available_ advertisements.

* Rule evaluates request against advertisement constraints and returns true|false.

* An advertisement is returned if one or more advertisements satisfy the constraints (ties are broken arbitrarily).

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

** Extending the application
	* Adding new limits
	* Adding new operators
	* Adding new types
