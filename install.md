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
