# DavidJSON

This is a NSObject extension that I developed for use in networking application

You can initialize an NSObject and set its attributes with data extracted from some JSON (presumly returned from a API request) automatically

Each NSObject has a schema (which is a hash) mapping a JSON key -to- an object attribute. Each NSObject can have as many schemas as needed, and you can specify which schema to use when initializing the object

It automatically typecasts the relevant data types (int, string, float) and also supported more complex data types: array, hash
