require "socket"

server = TCPServer.new("localhost", 3003)

def parse_request(request_line)
  http_method, path_params, http_version = request_line.split(' ')
  path, query = path_params.split('?')
  params = parse_params(query)

  [http_method, path, params]
end

def parse_params(query)
  query.split("&").each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end
end

loop do
  client = server.accept
  
  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  puts request_line

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Rolls</h1>"
  number_of_rolls = params["rolls"].to_i
  number_of_sides = params["sides"].to_i

  number_of_rolls.times do |n|
    client.puts "<p>Roll #{n + 1}: #{rand(number_of_sides) + 1}</p>"
  end
 
  client.puts "</body>"
  client.puts "</html>"
  client.close
end