require 'psych'
require 'oj'

# The TinyDot module provides methods for converting data from different
# formats (environment variables, YAML, JSON and Hashes) into a nested Struct.
# This allows for easy access to the data using dot notation.
#
# The `from_env` method converts the current environment variables into a
# Struct.
#
# The `from_yaml` method takes a string containing YAML data and converts it
# into a Struct.
#
# The `from_json` method takes a string containing JSON data and converts it
# into a Struct.
#
# The `from_csv` method takes a string containing raw CSV data and converts it
# to an Array of Struct.
#
# The `from_hash` method takes a Hash and converts it into a Struct. It really
# just calls the `_hash_to_struct` method.
#
# The `_hash_to_struct` is a private method that is used by the other methods
# to convert the data from a hash into a Struct. It handles nested data by
# recursively calling itself when it encounters a Hash or an array within the
# data.
#
# The `_to_attr_friendly_symbols` is a private method that is used to convert
# keys in the hash to symbols that can be used as attributes in a Struct. It
# replaces spaces and dashes with underscores and converts the keys to symbols.
#
# Please note that the JSON and YAML are required to be passed as String.
#
# Because this module constructs a series of nested Structs from Hash-like
# inputs, it means you can read/write data pretty easily:
#
#   > s = TinyDot.from_json(<some deeply nested JSON>)
#  => <struct ... >
#   > s.foo.bar.baz
#  => 5
#   > s.foo.bar.baz = 99
#   < s.foo.bar.baz
#  => 99
module TinyDot
  class << self
    def from_env
      _hash_to_struct(ENV.to_h)
    end

    def from_yaml(yaml_string)
      yaml = Psych.load(yaml_string)
      _hash_to_struct(yaml)
    end

    def from_json(json_string)
      json = Oj.load(json_string)
      _hash_to_struct(json)
    end

    def from_csv(csv_string)
      data = CSV.parse(csv_string, headers: true)
      data.map { |row| _hash_to_struct(row.to_hash) }
    end

    def from_hash(hash)
      _hash_to_struct(hash)
    end

    def _hash_to_struct(hash)
      case hash
      when Hash
        struct = ::Struct.new(*_to_attr_friendly_symbols(hash.keys))
        struct.new(*hash.values.map { |v| _hash_to_struct(v) })
      when Array
        hash.map { |v| _hash_to_struct(v) }
      else
        hash
      end
    end

    def _to_attr_friendly_symbols(keys)
      keys
        .map{|k| k.to_s.gsub(/[-\s]/, '_') }
        .map(&:to_sym)
    end
  end
end
