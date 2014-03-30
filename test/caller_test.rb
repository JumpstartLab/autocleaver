require 'test_helper'
require 'autocleaver/caller'

class CallerTest < Minitest::Test
  def setup
    filepath = File.expand_path('../support/sample_input.markdown', __FILE__)
    @caller = Autocleaver::Caller.new(filepath)
  end

  def test_it_accepts_a_filepath
    output = @caller.create_presentation
    expected_file = File.read  File.expand_path('../support/sample_output.markdown', __FILE__)
    assert_equal expected_file, File.read(output)
  end
end
