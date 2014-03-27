gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require './lib/autocleaver/caller'

class CallerTest < Minitest::Test

  def setup
    filepath = './test/support/sample_input.markdown'
    @caller = Autocleaver::Caller.new(filepath)
  end

  def test_it_accepts_a_filepath
    output = @caller.create_presentation
    expected_file = File.read('./test/support/sample_output.markdown')
    assert_equal expected_file, File.read(output)
  end


end
