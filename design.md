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


#### Extending

* Adding a new type / class

	* New type added should inherit from `Base` type

	* Should support label attribute


* Ad Ranking design

	* Each comparator / operator is assigned a weightage.

	* Each compound expression returns a score which is an aggregate of scores from simple expressions

	* The above result can be mapped to a `Match` type / class which contains percentage matches.

	* Ads which have higher percentage matches are picked in case more than one ad matches a request.

	* For example, ad1 has 8/10 and ad2 has 9/10. ad2 is selected
