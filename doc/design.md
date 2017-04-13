#### Components

* Request handler / webserver

* Advertisement selector

* Rule engine

#### URLs exposed via the webserver

|url          | type | params | desc     |
|:------------|:----:|:------:|:--------:|
| /           | GET  | None   | Initializes sample data
| /flush      | GET  | None   | Clears the sample data
| /ads/:id    | GET  | id     | Gets the advertisement matching the id
| /ads/:label | GET  | label  | Gets the advertisement matching the label
| /ads/match  | POST | { channel: "example.com",  preferences: ["pref1", "pref2"], country: "country1" } | returns a matching ad (if any)

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
* ExprGroup

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

* Allow looking up type by other attributes apart from label. Rule should be able to express this by using annotations.

#### Design choices and simplifications

* Request attributes are assumed to have a specific type; collection
  for categories / preferences, and string for both country and
  channel.

* No policies (user preference over channel categories) are pre-decided.
  Instead, conjunctions and disjunctions are used to combine expressions.

* Limit type is polymorphic and stores type information in the table,
  instead of creating new types like CountryLimit, ChannelLimit, etc.

* Most operations are like find, count have a complexity of O(1) but
  find_by has a complexity of O(n). Could be optimized by adding a
  secondary data structure (or index)

* Custom types like collection and lazy resultsets could be modelled
  instead of Array to represent collections.

* Table modelling could have used a custom type instead of a Hash with
  counter and coll

* Rule engine operates on type labels implicitly to keep the core idea
  simple. The engine could support a mapping of attributes instead, if
  need be. This would require each type to support a much more feature-ful
  search interfaces.

* Rule engine supports operators on type instances. In other words,
  dispatches are done at an object level. Could also support operators
  at a class level. Consequently, the dispatch engine would change to
  support operators which are built as class methods.

* Directory structure is relatively flat and not segregated into
  models, lib, app, etc and to keep load paths to a minimum.

* Basic logging exists and could be extended to support environment
  (dev, test, staging) based logging, separate files, triggering log
  levels through signals etc.
