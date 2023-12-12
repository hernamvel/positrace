# README

Here are the instructions to review and run the geolocation api exercise project.

## To run the project locally using docker

Clone this repository:

`git@github.com:hernamvel/positrace.git`

Build the image (change the build tag if feel you need to do):

`docker build --tag 'posistrace_rails' .`

Run the image:

`docker run -p 3000:3000 -e "PROVIDER_KEY=<insert your ipstack key here>" posistrace_rails`

And make a quick test to see all is working:

`curl http://localhost:3000/geolocations`

Should print a json with data already seeded.

For simplicity, the project will run on `development` mode so we
don't have to deal with secret keys, etc. Feel free to change the
the `ENV RAILS_ENV` to production in the `Dockerfile` if you need to
do so.


## Geolocation endpoints

For your reference, I'm providing working curl commands against already
seeded data that you can just run copy and pasting in your terminal.

- List all geo locations stored in the database

`curl http://localhost:3000/geolocations`

- List a geo location by its id

`curl http://localhost:3000/geolocations/1`

Change 1 by the id if you know it.

- Search by ip or url

By ip:

`curl --header "Content-Type: application/json"  --request GET  --data '{"search_key":"ip","search_value":"172.1.1.20"}' http://localhost:3000/geolocations/search_by`

By url:

curl --header "Content-Type: application/json"  --request GET  --data '{"search_key":"url","search_value":"www.positrace.com"}' http://localhost:3000/geolocations/search_by

- Create a new record by ip or url

By ip:

`curl --header "Content-Type: application/json"  --request POST  --data '{"search_key":"ip","search_value":"132.1.2.88"}' http://localhost:3000/geolocations`

By url:

curl --header "Content-Type: application/json"  --request POST  --data '{"search_key":"url","search_value":"www.stackoverflow.com"}' http://localhost:3000/geolocations

- Destroy a record by ip or url

By ip:

`curl --header "Content-Type: application/json"  --request DELETE  --data '{"search_key":"url","search_value":"www.positrace.com"}' http://localhost:3000/geolocations/destroy_by`

By url:

`curl --header "Content-Type: application/json"  --request DELETE  --data '{"search_key":"ip","search_value":"172.1.1.20"}' http://localhost:3000/geolocations/destroy_by`

As you can note, `create`, `search_by` and `destroy_by` actions recieves in the request the following json string:

```
{
   "search_key": <"url" | "ip">
   "search_value: <an url or and ip address dependint on search_key>
} 
```

In general terms, these will be used to locate the proper resource (gelocation) to be operated.
You can take a close look at `GeoLocation#locate_by` and at the
`Database` section of this document below.

## 3rd party Service Locator

As suggested, I implemented IPStack.com as a service locator. Exercise asked to be
easily configurable, so these are the steps to implement another service locator:

- Create a service class. User the suffix ServiceProvider, and implement the method
fetch with the logic of that provider:

```
class MyOtherLocatorServiceProvider
  def fetch(ip_or_url)
    # Write your logic here
  end  
end
```

Look at `IpStackServiceProvider#fetch` to see how data
is expected tu be returned

- Change `/confg/geolocator.yml` with the new locator im
the proper environment.  Example:

```
development:
  service_provider: MyOtherLocator
  access_key: <%= ENV.fetch("PROVIDER_KEY") { '' } %>
```

* Database

The project is shipped with `sqlite3` for simplicity. This means
if you destroy the container, all data will be lost. Some initial
data is seeded when creating the container.

Database will have to tables:

```
 --------------                 --------------
| geolocations | ------------> | url_locations|
 --------------             n   --------------
```

Both table's primary keys have the standard rails `id` as primary keys,
a geolocation can be also identified with its unique `ip` for an ip you
can have many url locations (i,e. when using virtualhosts to host many sites
in one server).

As already noted, `GeoLocation#locate_by` will deal to locate the correct
record by ip or url.

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

