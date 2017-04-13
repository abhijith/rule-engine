##### Countries

* Germany
* India
* Sweden

##### Channels

* reddit.com
* team-bhp.com
* trip-advisor.com

##### Categories
 	cars
      |
      [bmw, volvo]

	travel
        |
		airlines
		        |
                [air-berlin, air-india]
        |
        food
			|
            [dosa, meatballs]

##### Advertisements and rules

| name         |live?| ad-limit | country-limit | channel-limit | constraints |
|:------------:|:---:|:--------:|:-------------:|:-------------:|:------------|
| volvo-s40    | Yes | 10       | 2             | 2             | country is `sweden` and channel is `team-bhp.com` and preferences is equal to `cars`
| bmw-i8       | yes | 2        | 2             | 2             | country is `germany` and channel is `team-bhp.com` and `cars` is an ancestor to preferences
| master-chef  | yes | 10       | 3             | 3             | country is in `(germany, sweden, india)` and channel is `trip-advisor.com` and preferences intersect with `(food, dosa, travel)`
| air-berlin   | yes | 10       | 3             | 3             | country is in `(germany, sweden)` and channel is `trip-advisor.com` and `travel` is an ancestor to either preferences or channel-categories
| coke         | yes | 10       | -             | -             | channel is `reddit.com`
| catch-all-ad | yes | 20       | -             | -             | always true
| jogurt       | no  | 10       | -             | -             | always true
