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
    input_string = "##Apples\n\nThey taste like fruits\n\n`code example` for you\n\n* `list` item 1\n* list item 2"
    expected_output = "--\n\n##Apples\n\n* `list` item 1\n* list item 2\n"
    assert_equal expected_output, @renderer.transpile(input_string)
  end

  def test_keeps_code_blocks
    input_string = "##Apples\n\nThey taste like fruits\n\n* list item 1\n* list item 2\n\n```ruby\na = 1\nb = a\n```\n\nconcluding paragraph"
    expected_output = "--\n\n##Apples\n\n* list item 1\n* list item 2\n\n```ruby\na = 1\nb = a\n```\n"
    assert_equal expected_output, @renderer.transpile(input_string)
  end

  def test_keeps_ordered_lists
    input_string = "##Apples\n\nThey taste like fruits\n\n1. list item 1\n2. list item 2\n\n```ruby\na = 1\nb = a\n```\n\nconcluding paragraph"
    expected_output = "--\n\n##Apples\n\n1. list item 1\n2. list item 2\n\n```ruby\na = 1\nb = a\n```\n"
    assert_equal expected_output, @renderer.transpile(input_string)
  end

  def test_inserts_new_slide_before_each_header
    input_string = "##Header1\n* list 1\n\n```ruby\ndef calc\n1+1\n# simple calc\nend\n```\n\n###Header2\n"
    expected_output = "--\n\n##Header1\n* list 1\n\n```ruby\ndef calc\n1+1\n# simple calc\nend\n```\n\n--\n\n###Header2\n"
    assert_equal expected_output, @renderer.transpile(input_string)
  end

  def test_inserts_previous_header_after_end_of_code_block
    input_string = "##Header1\n* list 1\n\n```ruby\ndef calc\n1+1\n# simple calc\nend\n```\n\n```ruby\nmore code\n```\n\n###Header2\n"
    expected_output = "--\n\n##Header1\n* list 1\n\n```ruby\ndef calc\n1+1\n# simple calc\nend\n```\n\n--\n\n##Header1\n\n```ruby\nmore code\n```\n\n--\n\n###Header2\n"
    result = @renderer.transpile(input_string)
    assert_equal expected_output, result
  end

  def test_transpiles_ignores_headers
    input_string = <<-HEADERS
---
layout: page
title: Filters
section: Controllers
---

    HEADERS
    expected_output = "\n"
    assert_equal expected_output, @renderer.transpile(input_string)
  end

  def test_removes_linebreak_after_sentence
    input_string = <<-INPUT
## Before, After, and Around

There are three types of filters implemented in Rails:

* `before_filter` runs before the controller action
    INPUT
    expected_output = <<-OUTPUT
--

## Before, After, and Around

* `before_filter` runs before the controller action
    OUTPUT
    assert_equal expected_output, @renderer.transpile(input_string)
  end

  def test_creates_properly_formatted_file
    expected_file = File.read('./test/support/sample_output.markdown')
    @renderer.render
    output_file = File.read(@output_filename)
    assert_equal expected_file, output_file
  end

end
