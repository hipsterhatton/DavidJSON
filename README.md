# DavidJSON

This is a NSObject extension that I developed for use in networking application

You can initialize an NSObject and set its attributes with data extracted from some JSON (presumly returned from a API request) automatically

Each NSObject has a schema (which is a hash) mapping a JSON key -to- an object attribute. Each NSObject can have as many schemas as needed, and you can specify which schema to use when initializing the object

It automatically typecasts the relevant data types (int, string, float) and also supported more complex data types: array, hash

# Example

1. You have an NSObject called "Album" which has the attributes: (string) name, artis, genre, (integer) year of release
2. You make an API request to the URL: www.musicinfo.com/api/get-album-details?q=back-in-black
3. The request returns some JSON data like so: `{name: "Back in Black", artist: "AC/DC", released: "1980", genre: "rock"}`
4. You can now initialize the NSObject "Album" and automatically set its attributes with data from the JSON response
e.g.: so instead of writing `[[Album alloc] init]` which will return an initialized, but 'blank' Album object in memory

  You now write `[Album createViaJSON:(json_data_from_request) :(mapping_from_json_to_attributes)]` which will  return an initialized Album object with it's respective attributes set to the values in the JSON response
