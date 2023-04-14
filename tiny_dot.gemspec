Gem::Specification.new do |s|
  s.name        = "tiny_dot"
  s.version     = "3.1.3"
  s.description = "a tiny read/write dot notation wrapper for Hash, JSON, YAML, CSV, and ENV"
  s.summary     = "this library will take in one of the supported formats and will recursively build a nested set of Structs out of it"
  s.authors     = ["Jeff Lunt"]
  s.email       = "jefflunt@gmail.com"
  s.files       = ["lib/tiny_dot.rb"]
  s.homepage    = "https://github.com/jefflunt/tiny_dot"
  s.license     = "MIT"

  s.add_runtime_dependency 'oj'
end
