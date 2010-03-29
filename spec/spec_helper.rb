require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hoth'
require 'spec'
require 'spec/autorun'

Hoth.env = "test"

Spec::Matchers.define :string_matching do |regex|
  match do |string|
    string =~ regex
  end
end
