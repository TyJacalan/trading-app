# AVION FINANCE

A stock trading application that leverages real-world stock market information data from [iex api](https://github.com/dblock/iex-ruby-client). The application showcases user authentication, an admin dashboard, and stock portfolio management.

![Trading App](https://github.com/TyJacalan/trading-app/assets/143598524/0bb79d54-e8b8-4e3e-8998-2d633b79b910)

## Main dependencies:

* Devise
* Tailwind CSS
* Shadcn
* Chartkick
* Kaminari
* JSBundling
* Turbo Stimulus
* Rspec

## Features
* Admin console with RESTful actions for users
* User email and admin verification
* User can receive email notifications
* Users can view live stock market information
* Users can create transactions
* Users can view their transactions
* Users can view their portfolio

## Usage/Examples
1. Install dependencies
```
bundle install && yarn install
```

3. Set the environment variables:
```
IEX_API_SECRET_TOKEN       = <Create an iex account to access their api tokens>
IEX_API_PUBLISHABLE_TOKEN  = <Create an iex account to access their api tokens>
GOOGLE_SMTP_EMAIL          = <Add a google email address>
GOOGLE_SMTP_PASSWORD       = <Generate an app password from your Google account>
```
3. Create the database
```
bin/rails db:create && 
bin/rails db:migrate &&
bin/rails db:migrate RAILS_ENV=test
```

4. Create an admin account
```
bin/rails c

admin = User.create!(first_name: <first name>, email: <email>, password: <password>, role: 1)
admin.skip_confirmation!
admin.save

user = User.create!(first_name: <first name>, email: <email>, password: <password>, role: 0, approved: 1)
user.skip_confirmation!
user.save
```
5. Run the application
```
bin/rails s
```
