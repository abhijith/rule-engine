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

* Making requests via curl

* Tests

	$ cd rpm
	$ bundle exec ruby tests/all.rb          # run all tests
	$ bundle exec ruby tests/test_<file>.rb  # run specific-test

#### Assumptions
--
** Request from a channel contains 3 fields
  * country (String representation of country)
  * channel (String representation of channel)
  * preferences (Array of String representation of Category)

** Categories are unique

** Channels are unique

** Preferences are unique

** Adverts are unique and have constraints associated with them

** The application returns an advertisement or null for an advert matching request

** The application returns an advertisement for an advert id

** Rules / Constraints can be either simple expressions or compound experssions combined using either conjuctions or disjunctions.


#### Components
--
** Request handler / webserver

** Advert selector
	* returns an advertisement (ties are broken arbitrarily) if constraints are satisfied for one or more Advertisements.

** Rule engine

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

** URLs
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
	- Gets the advert matching the id

	* /match
	- POST
	- Content-type: JSON
	- Params:{ channel: "example.com",  preferences: ["pref1", "pref2"], country: "country1" }

** Extending the application
	* Protocols


#### Flow:
--
* Webserver accepts request

* Gets converted into Request Type

* Advert selector iterates through _live_ advertisements and select an advertisement

* Rule engine returns true|false for each advert evaluated
