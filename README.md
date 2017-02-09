# Daily meals

**Live demo:** https://daily-meals.herokuapp.com/

Daily meal(s) is a simple REST-like API for getting restaurants near you (by several searchable params).

### API Documentation

##### Headers

`Authorization: Bearer %some_jwt_token%` _(Not used for user management endpoints, only with `searchable API`)_
`Content-Type`: `application/json`

#### User management

##### Registration `POST /users`

**body**
``` json
{
  "email": "email@example.com",
  "password": "12345678",
  "password_confirmation": "12345678"
}
```

##### Login `POST /users/sign_in`

**body**
``` json
{
  "email": "email@example.com",
  "password": "12345678"
}
```

- Both **registration** and **login** endpoints have the same response:

``` json
{
  "id": 3,
  "email": "email@example.com",
  "bearer": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImVtYWlsQGV4YW1wbGUuY29tIiwiZXhwIjoxNDg3NzkzMDIwfQ.WXKkiRkFM2Idi8bfzA0fzw44De2SeNZrpmVPhbnzneo"
}
```

#### Searchable API

Every request to Searchable endpoints has to be signed with "Authorization Header". For example:
`Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InRlc3RAZXhhbXBsZS5leGFtcGxlIiwiZXhwIjoxNDg3NzEwNDAzfQ.U8F8GEd7-DmNfOnuWSJ-CPxmbGFaIX84H74FsDHEBS4`

`Bearer` is Json Web Token (https://jwt.io/) with email and expiration data.

Responses are paginated. Pagination info is in response headers. To provide custom number of results per page (default is 5) add query param `per_page`, for example: `GET /restaurants?per_page=17`.

**Example** response headers:

``` json
...
Link → <http://localhost:5000/restaurants?city=Zagreb&page=2>; rel="last", <http://localhost:5000/restaurants?city=Zagreb&page=2>; rel="next"
Per-Page → 5
Total → 10
```

##### Restaurants

Restaurants are searchable by following params:
- `city`
- `restaurant_name`
- `meal_name`
- `lat` (restaurant's latitude)
- `lng` (restaurant's longitude)


`GET /restaurants?city=Zagreb&lat=45.79&lng=15.92&restaurant_name=Fisher-O'Hara&meal_name=Radicchio`

**response**

```json
[
  {
    "id": 82,
    "name": "Fisher-O'Hara Oriental Meals",
    "city": "Zagreb",
    "address": "89274 Shany Mission",
    "website": "http://gleichner.org/ashlynn",
    "latitude": "45.7968021106021",
    "longitude": "15.9256064678199",
    "logo": "https://pigment.github.io/fake-logos/logos/medium/color/10.png",
    "meals": [
      {
        "id": 1668,
        "name": "Ricotta in Radicchio with Thyme",
        "price": "73.64",
        "calories": "416.0",
        "date_next_served": "2017-02-10",
        "day_served": "Friday"
      },
      {
        "id": 1667,
        "name": "Fromage Blanc in Mastic with Chillies Whole",
        "price": "55.72",
        "calories": "388.0",
        "date_next_served": "2017-02-09",
        "day_served": "Thursday"
      },
      ...
    ]
  }
]
```

To get single restaurant use `GET /restaurants/:id`. For example:
- `GET /restaurants/82`

**response**

```json
{
  "id": 82,
  "name": "Fisher-O'Hara Oriental Meals",
  "city": "Zagreb",
  "address": "89274 Shany Mission",
  "website": "http://gleichner.org/ashlynn",
  "latitude": "45.7968021106021",
  "longitude": "15.9256064678199",
  "logo": "https://pigment.github.io/fake-logos/logos/medium/color/10.png",
  "meals": [
    {
      "id": 1668,
      "name": "Ricotta in Radicchio with Thyme",
      "price": "73.64",
      "calories": "416.0",
      "date_next_served": "2017-02-10",
      "day_served": "Friday"
    },
    {
      "id": 1667,
      "name": "Fromage Blanc in Mastic with Chillies Whole",
      "price": "55.72",
      "calories": "388.0",
      "date_next_served": "2017-02-09",
      "day_served": "Thursday"
    },
    ...
  ]
}
```
or if there is no data with given `:id`:

```json
{
  "errors": {
    "restaurant": [
      "not_found"
    ]
  }
}
```

##### Meals

Meals are searchable by following params:
- `meal_name`

`GET /meals?meal_name=beans`

**response**

``` json
[
  {
    "id": 2,
    "name": "Rosemary in Butter Beans with Parsley",
    "price": "97.54",
    "calories": "539.0",
    "date_next_served": "2017-02-15",
    "day_served": "Wednesday",
    "image": "http://lorempixel.com/400/300/food/",
    "restaurant": {
      "id": 1,
      "name": "Schroeder-Sawayn Restaurant",
      "city": "East Hellenshire",
      "address": "78729 Damaris Unions",
      "website": "http://kerlukerippin.net/nigel",
      "latitude": "37.739919984603816",
      "longitude": "147.59112846963262",
      "logo": "https://pigment.github.io/fake-logos/logos/medium/color/11.png"
    }
  },
  {
    "id": 5,
    "name": "Chia seeds in Kidney Beans with Celery Seed",
    "price": "34.58",
    "calories": "383.0",
    "date_next_served": "2017-02-12",
    "day_served": "Sunday",
    "image": "http://lorempixel.com/400/300/food/",
    "restaurant": {
      "id": 1,
      "name": "Schroeder-Sawayn Restaurant",
      "city": "East Hellenshire",
      "address": "78729 Damaris Unions",
      "website": "http://kerlukerippin.net/nigel",
      "latitude": "37.739919984603816",
      "longitude": "147.59112846963262",
      "logo": "https://pigment.github.io/fake-logos/logos/medium/color/11.png"
    }
  },
  ...
]
```

To get single meal use `GET /meals/:id`. For example:
- `GET /meals/2001`
 
**response**

``` json
{
  "id": 2001,
  "name": "Prunes in Balsamic Vinegar with Mixed Spice",
  "price": "71.49",
  "calories": "528.0",
  "date_next_served": "2017-02-09",
  "day_served": "Thursday",
  "image": "http://lorempixel.com/400/300/food/",
  "restaurant": {
    "id": 100,
    "name": "Carroll-Swaniawski Pancakes",
    "city": "Ljubljana",
    "address": "47906 Valerie Circle",
    "website": "http://lind.co/rory",
    "latitude": "46.0811315185515",
    "longitude": "14.4434576440182",
    "logo": "https://pigment.github.io/fake-logos/logos/medium/color/4.png"
  }
}
```

or if there is no data with given `:id`:

```json
{
  "errors": {
    "meal": [
      "not_found"
    ]
  }
}
```

**response**

#### Live CURL examples

- Register a new user
```
curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: f5b2860d-db57-52a9-e809-e7f7b844f13a" -d '{
  "email": "user.new@example.com",
  "password": "12345678",
  "password_confirmation": "12345678"
}' "https://daily-meals.herokuapp.com/users"
```

- Login

```
curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 93f3999a-6f31-3806-4ee9-11e4ad3c3187" -d '{
  "email": "test@example.example",
  "password": "12345678"
}' "https://daily-meals.herokuapp.com/users/sign_in"
```
- Search restaurants by city
```
curl -X GET -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InRlc3RAZXhhbXBsZS5leGFtcGxlIiwiZXhwIjoxNDg3NzEwNDAzfQ.U8F8GEd7-DmNfOnuWSJ-CPxmbGFaIX84H74FsDHEBS4" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: af9d9c41-08b5-c37d-d41e-da1ba39a3128" "https://daily-meals.herokuapp.com/restaurants?city=Ljubljana"
```
- Search restaurants by restaurant name
```
curl -X GET -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InRlc3RAZXhhbXBsZS5leGFtcGxlIiwiZXhwIjoxNDg3NzEwNDAzfQ.U8F8GEd7-DmNfOnuWSJ-CPxmbGFaIX84H74FsDHEBS4" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 681c0f4b-1932-fa79-9346-7314b9fe227a" "https://daily-meals.herokuapp.com/restaurants?restaurant_name=Lehner%20Restaurant"
```
- Search restaurants by latitude and longitude
```
curl -X GET -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InRlc3RAZXhhbXBsZS5leGFtcGxlIiwiZXhwIjoxNDg3NzEwNDAzfQ.U8F8GEd7-DmNfOnuWSJ-CPxmbGFaIX84H74FsDHEBS4" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 139e4669-d819-8937-1142-4c6c67e0dcf9" "https://daily-meals.herokuapp.com/restaurants?lat=46.1&lng=14.45"
```
- Search restaurants by meal name
```
curl -X GET -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InRlc3RAZXhhbXBsZS5leGFtcGxlIiwiZXhwIjoxNDg3NzEwNDAzfQ.U8F8GEd7-DmNfOnuWSJ-CPxmbGFaIX84H74FsDHEBS4" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 3fbbc574-8d38-cdc3-cc69-1a974f8e8a25" "https://daily-meals.herokuapp.com/restaurants?meal_name=Beans"
```

- Get restaurant by id
```
curl -X GET -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InRlc3RAZXhhbXBsZS5leGFtcGxlIiwiZXhwIjoxNDg3NzEwNDAzfQ.U8F8GEd7-DmNfOnuWSJ-CPxmbGFaIX84H74FsDHEBS4" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 8df536ae-fef2-fc09-c57c-aba6f3749bfb" "https://daily-meals.herokuapp.com/restaurants/19"
```

- Search meals by meal name
```
curl -X GET -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InRlc3RAZXhhbXBsZS5leGFtcGxlIiwiZXhwIjoxNDg3NzEwNDAzfQ.U8F8GEd7-DmNfOnuWSJ-CPxmbGFaIX84H74FsDHEBS4" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: dc973669-9482-0e0d-7cab-9e1deac5ad21" "https://daily-meals.herokuapp.com/meals?meal_name=garlic"
```
- Get meal by id
```
curl -X GET -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InRlc3RAZXhhbXBsZS5leGFtcGxlIiwiZXhwIjoxNDg3NzEwNDAzfQ.U8F8GEd7-DmNfOnuWSJ-CPxmbGFaIX84H74FsDHEBS4" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: a1fa79cf-c3b9-7da8-665d-68d4641ced30" "https://daily-meals.herokuapp.com/meals/1988"
```

<hr/>

**NOTE!!** *All data is randomly (or semi-randomly) generated so it has fake and wrong field values and that could sometimes lead to strange results.*
