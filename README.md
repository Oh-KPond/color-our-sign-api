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
| `color` | string             | Color chosen by user in digit form

## Installed Gems Include

[rufus-scheduler](https://github.com/jmettraux/rufus-scheduler)

## This App is deployed through Heroku
- https://color-our-sign-api.herokuapp.com/


## Links to Connecting Code (React App & Hardware Repos)
- [Color Our Sign React App](https://github.com/Oh-KPond/color-our-sign)
- [Color Our Sign Hardware](https://github.com/Oh-KPond/color-our-sign-feather)
