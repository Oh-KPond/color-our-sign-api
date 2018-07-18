## System Requirements
- This app was created using
  - Ruby version 2.5.0p0 (2017-12-25 revision 61468) [x86_64-darwin17]
  - Rails version: 5.2.0

## Up & Running on Localhost
1. Clone project
2. cd into 'color-our-sign-api'
3. run `bundle install`
4. run `rails s`

## API Description

#### `GET /queued_colors`
Lists all queues colors and their created at timestamps

#### `GET /color`
Returns single object with color information

#### `POST /queued_colors`
Create a new color in the queued colors.

Upon success, this request should return the `id` of the color created and the time until this color will appear on the sign.

Request body:

| Field         | Datatype            | Description
|---------------|---------------------|------------
| `color` | string             | Color chosen by user


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
