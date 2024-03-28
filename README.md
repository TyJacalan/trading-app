# TRADING APP

## Main dependencies:

* Devise
* Tailwind CSS
* Shadcn
* JSBundling
* Turbo Stimulus
* Rspec

## Features
* Admin console with RESTful actions for users
* User email and admin verification
* Users can view stock market information from [api](https://github.com/dblock/iex-ruby-client)
* Users can create transactions
* Users can view their transactions
* Users can view their portfolio

## Usage/Examples
1. Install dependencies
```bundle install && yarn install```

2. Set the environment variables:
4. Create the users database
```
bin/rails db:create && 
bin/rails db:migrate &&
bin/rails db:migrate RAILS_ENV=test
```
5. Run the application
`bin/rails s`

## Environment Variables

To run this project, you will need to add the following environment variables to your .env file
```
host
google_oauth_client_id:
google_oauth_client_secret:
  google_smtp
  - email
  - password
iex_publishable_token:
iex_secret_token:
```
