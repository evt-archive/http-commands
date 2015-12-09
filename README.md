# HTTP Commands

Convenience abstractions for common HTTP operations, such as post and get.

## Basic Usage

```ruby
# Get
response = HTTP::Commands::Get.('https://www.google.com')
response.status_code
=> 200
response.body
=> "<!doctype html><head> …"

# Post
data = JSON.dump({ 'foo' => 'bar' })
response = HTTP::Commands::Post.(data, 'http://www.example.com/some-resource')
response.status_code
=> 201
```

You can pass in HTTP headers as well:

```ruby
HTTP::Commands::Get.('http://www.example.com', 'Accept' => 'application/json')
```
