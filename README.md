x#### Running the code
--

* Starting the application

  $ cd rpm
  $ bundle exec ruby rpm.rb # starts the webserver on port localhost:4567

* Tests

  $ cd rpm
  $ ruby tests/all.rb          # run all tests
  $ ruby tests/test_<file>.rb  # run specific-test

#### Assumptions
--
** Request contains 3 fields
  - country
  - channel
  - preferences

#### Design
--

** Types
	* Request
	* Channel
	* Country
	* Advert
	* Limit
	* Expr

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

**

#### Flow:
--
* Webserver accepts request

* Gets converted into Request Type

#### Project Tree:
--
