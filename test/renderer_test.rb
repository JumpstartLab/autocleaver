gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require './lib/autocleaver/renderer'

class RendererTest < Minitest::Test
  attr_reader :renderer

  def setup
    data_file = './test/support/sample_input.markdown'
    @output_filename = 'output_file.html'
    @renderer = Autocleaver::Renderer.load(data_file)
  end

  def teardown
    FileUtils.rm(@output_filename) if File.exists?(@output_filename)
  end

  def test_load_pulls_input_data_from_a_file
    assert @renderer.input_text
  end

  def test_renders_a_file
    assert_equal File, @renderer.render.class
  end

  def test_outputs_frontmatter
    input_string = "---\nlayout: page\ntitle: Filters\nsection: Controllers\n---\n"
    expected_output = "title: Filters\noutput: basic.html\ncontrols: true\n\n--\n\n# Filters\n## Controllers\n\n"
    assert_equal expected_output, @renderer.generate_headers(input_string)
  end

  def test_removes_paragraphs_from_simple_text
    input_string = "##Apples\n\nThey taste like fruits\n\n* list item 1\n* list item 2"
    expected_output = "##Apples\n\n\n* list item 1\n* list item 2"
    assert_equal expected_output, @renderer.transpile(input_string)
  end

  def test_keeps_code_blocks
    input_string = "##Apples\n\nThey taste like fruits\n\n* list item 1\n* list item 2\n\n```\na = 1\nb = a\n```\n\nconcluding paragraph"
    expected_output = "##Apples\n\n\n* list item 1\n* list item 2\n\n```\na = 1\nb = a\n```\n"
    assert_equal expected_output, @renderer.transpile(input_string)
  end

  def test_creates_properly_formatted_file
    expected_file = File.read('./test/support/sample_output.markdown')
    @renderer.render
    output_file = File.read(@output_filename)
    assert_equal expected_file, output_file
  end

end
