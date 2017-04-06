#### Dependencies

* Ruby
* Bundler

#### Cloning and installing the application


	$ git clone ssh://git@bitbucket.org/abhijithg/rpm.git
	$ bundle install --path vendor/bundle

#### Project Tree:


	├── assumptions.md
	├── design.md
	├── extending.md
	├── Gemfile
	├── Gemfile.lock
	├── install.md
	├── lib
	│   ├── advert.rb
	│   ├── category.rb
	│   ├── channel.rb
	│   ├── country.rb
	│   ├── data.rb
	│   ├── exceptions.rb
	│   ├── expr.rb
	│   ├── limit.rb
	│   ├── request.rb
	│   ├── rpm.rb
	│   └── utils.rb
	├── README.md
	├── rpm.rb
	├── SPEC
	├── test
	│   ├── advert_test.rb
	│   ├── all.rb
	│   ├── category_test.rb
	│   ├── channel_test.rb
	│   ├── country_test.rb
	│   ├── expr_test.rb
	│   ├── http_test.rb
	│   ├── limit_test.rb
	│   ├── request_test.rb
	│   ├── rpm_test.rb
	│   └── utils.rb
	└── TODO

#### Running the code

* Starting the application

		$ cd rpm
		$ bundle exec ruby rpm.rb # starts the webserver on port localhost:4567

* Tests

		$ cd rpm
		$ bundle exec ruby tests/all.rb          # run all tests
		$ bundle exec ruby tests/<name>_test.rb  # run specific-test
