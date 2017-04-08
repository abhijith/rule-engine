Entities:
---------
** Request
   * Description
     - Packet sent when a channel queries for an eligible Ad

   * Attributes
     - channel
     - country
     - categories

** Channel
   * Description:
     - collection of channels

   * Attributes:
     - id
     - label
     - categories
     - country

   * Associations:
     - has-many categories
     - has-one country
     - has-one language

** Advert
   * Description:
     - collection of Ads

   * Attributes:
     - id
     - label
     - global-view-limit
     - constraint

   * Associations:
     - has-many categories
     - has-one rule

** Category
   * Description:
     - collection of categories
     - tree structure and hence can represent hierarchies like sub-category

   * Attributes:
     - id
     - label
     - parent-id
     - children
     - descendants
     - ancestors

   * Associations
     - has-many-and-belongs-to advert
     - has-many-and-belongs-to channel

** Country
   * Description:
     - collection of countries

   * Attributes
     - label

   * Associations
     - belongs-to advert
     - belongs-to channel

** Language
   * Description:
     - collection of languages

   * Attributes
     - label

  * Associations:
    - belongs-to advert
    - belongs-to channel

** AdChannelLimit
   * Description:
     - collection of ad-to-channel view limit

   * Attributes
     - advert-id
     - channel-id
     - view-limit
     - view-counter

   * Associations:
     - belongs-to advert
     - belongs-to channel

** AdCountryLimit
   * Description:
     - collection of ad-to-country view limit

   * Attributes
     - advert-id
     - country-id
     - view-limit
     - view-counter

   * Associations:
     - belongs-to advert
     - belongs-to country


** Request
  {
    channel: "reddit.com"
    country: "germany"
    categories: ["food", "travelling"]
  }

** Ad1
  {
    label: "nike"
    country: "germany"
    limit: 1000
    constraint: (and (== country "germany") (member? "sports" categories))
  }

  Ad1.satisifies?(request) -> (and true false) => false

** Ad2
  {
    label: "airbnb"
    country: "germany"
    limit: 1000
    constraint: (and (== country "germany") (member? "travelling" categories))
  }
  Ad2.satisfied?(request) -> (and true true) => true
curl -H "Content-Type: application/json" -X POST -d "{\"channel\":\"car-example.com\",\"country\":\"germany\",\"categories\":[\"cars\",\"gadgets\"]}" http://localhost:4567/match
