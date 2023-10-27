# Simple API endpoint implementation with Rails
To create an endpoint(`/register`) that registers user for exam window existing that matches with their start_time. It returns a `200` response if:
* college_id is valid
* exam_id is valid and is associated to college_id in request
* user is valid and found/created
* user's requested start_time falls within range of some exam_window
* user successfully registered with exam window

This endpoint returns a `400` response if:
* data is invalid/unclean
* invalid college_id
* invalid exam_id or exam belongs to some other college
* user is not found/created
* user fails to get associated with exam
* requested start_time is not in range of any exam_window associated with exam_id

Uses rubocop-rails for linting, rspec for testing, and factory-bot to help write specs

### Requirements
* Ruby "3.2.2"
* Rails 7.1
* Linux x86_64
* Postgres 16

### Services
Start postgres with
`sudo pg_ctlcluster 16 main start`

#### Database creation: 
`rails db:setup`

#### Database initialization:
`rails db:migrate`

### How to run the test suite
Install dependencies:
`bundle install`

Create the database for rails test env: 
`RAILS_ENV=test rails db:setup`

Then run migrations: 
`RAILS_ENV=test rails db:migrate`

Run tests:
`RAILS_ENV=test bundle exec rspec`

### Start server
`bundle install` \
`rails db:setup db:create db:migrate` \
`rails s`

#### Making requests to the server
* The db is populated with some seed data that you can use to make curl requests.
Sample Curl: \
`curl --location 'localhost:3000/register?first_name=John&last_name=Doe&phone_number=4567123890&college_id=1&exam_id=1&start_time=20-Nov-2023'` \
* The above will succeed, but the following will get a `400` status code: \
`curl --location 'localhost:3000/register?first_name=John1&last_name=Doe&phone_number=4567123890&college_id=1&exam_id=1&start_time=20-Nov-2023'` \
due to user's first_name being invalid

* The following will also return a `400` status code: \
`curl --location 'localhost:3000/register?first_name=John&last_name=Doe&phone_number=4567123890&college_id=1&exam_id=1&start_time=25-Nov-2023'` \
due to user's exam start_time being out of range of exam window inserted in seed migration.
### Tests
* Integration test in `spec/requests/register_spec.rb`
* Tests in models for validations, Note: `spec\models\api_request_spec.rb`
* User validation in `spec\models\user_spec.rb`
* When running `rspec`, it is normal to see error messages, which are logs of expected failures in tests
* You can change Logger level in environment configs. Right now, it is configured to also show all database queries.

## Author
[Bavani Sankar A B](mailto:wakingbavani@gmail.com) \
[LinkedIn](https://www.linkedin.com/in/layman806/)