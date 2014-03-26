gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require './lib/autocleaver/renderer'

class RendererTest < Minitest::Test
  attr_reader :renderer

  def setup
    data_file = './test/support/sample_input.markdown'
    @renderer = Autocleaver::Renderer.load(data_file)
  end

  def test_it_renders_a_file
    
    assert_equal expected, @renderer.render
  end
end
