require 'yaml'
require 'json'

# this class gives you read-only access to Hases, JSON, and YAML files using
# dot notation. it makes clever use of #method_missing to allow you to do the
# following:
#
#   > t = TinyDot.new({ 'foo' => { 'bar' => 'baz' }})
#   > t.foo                                               # returns another instance of TinyDot
#  => #<TinyDot:0x0201243 @data={ 'bar' => 'baz' }>
#   > t.foo!                                              # ! returns the value under the chain of keys
#  => { 'bar' => 'baz' }
#
# ... in other words, it gives you a convenient dot notation syntax for
# accessing nested hashes. you can chain calls to this and you'll get a new
# object that's essentially a #dig into the top-level hash.
#
# if you add '!' to the last method in a chain it will return the value under
# that key.
#
# finally, you can use dot syntax as deep as you want, and if there's no key at
# that level you'll just get `nil' back:
#
#   > t.foo.bar.baz.whatever.as.deep.as.you.want
#  => nil
#
# ... which is sort of safe navigation operator-like without the save
# navigation operator
class TinyDot
  # returns a TinyDot instance from the ENV constant
  def self.from_env
    TinyDot.new(ENV)
  end

  # returns a TinyDot instance after parsing the YAML in the named filename
  def self.from_yaml_file(filename)
    TinyDot.new(YAML.safe_load_file(filename))
  end

  # returns a TinyDot instance after parsing the JSON in the named filename
  def self.from_json_file(filename)
    TinyDot.new(JSON.parse(IO.read(filename)))
  end

  # give it a Hash and it'll give you dot notation over it
  def initialize(hash)
    @data = hash
  end

  def method_missing(m)
    ms = m.to_s

    case @data
    when Hash
      if ms.end_with?('!')
        @data[ms[0..-2]]
      else
        if @data.has_key?(ms)
          TinyDot.new(@data[ms])
        else
          TinyDot.new({})
        end
      end
    else
      TinyDot.new({})
    end
  end

  def to_json
    @data.to_json
  end

  # NOTE: this returns the raw hash inside of the TinyDot instance, which means
  # if you modify anything here you're modifying the internal data in this
  # TinyDot instance
  def to_hash
    @data
  end

  def to_yaml
    @data.to_yaml
  end
end
