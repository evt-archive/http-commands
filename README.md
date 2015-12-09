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

## Passing in a connection

You can pass in a connection instead of having the library establish one using the URI. This is useful if you need to support a different concurrency model (for instance, EventMachine, Celluloid, or ProcessHost cooperations). It's also useful if you are connecting to a proxy, where the connection will differ from the intended target.

```ruby
connection = TCPSocket.new '127.0.0.1', 8080
HTTP::Commands::Get.('http://www.example.com', connection: connection)
```

This is also how you support persistent HTTP connections. `HTTP::Commands` will close the connection for you when the server indicates the client must establish a new connection (e.g. via a `Connection: close` header).

```ruby
def connection
  @connection ||= HTTP::Commands::Connect.('127.0.0.1, 8080)
end

def get
  HTTP::Commands::Get.('http://www.example.com', connection: connection)

  # Reset connection to nil, causing it to reconnect next time it's used
  @connection = nil if connection.closed?
end
```
