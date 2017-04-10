#### Components

* Request handler / webserver

* Advertisement selector

* Rule engine

#### Flow of control:

* Advertisement matching

	- Webserver accepts requests
	- Advertisement selector iterates through _live_ and _available_ advertisements.
	- Rule evaluates request against advertisement constraints and returns true|false.
	- An advertisement is returned if one or more advertisements satisfy the constraints (ties are broken arbitrarily).
	- Views are updated when an Advertisement is selected


* Advertisement get

	- Looks up the id in the DB and returns an Advertisement if found

#### Types / Classes

* Request
* Channel
* Country
* Advert
* Limit
* Expr

#### URLs exposed via the webserver

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
