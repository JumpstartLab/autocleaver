gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require './lib/autocleaver/frontmatter'

class FrontmatterTest < Minitest::Test
  attr_reader :frontmatter

  def setup
    data_file = './test/support/sample_input.markdown'
    @frontmatter = Autocleaver::Frontmatter.load(data_file)
  end

  def test_it_exists
    assert Autocleaver::Frontmatter
  end

  def test_load_pulls_input_data_from_a_file
    assert @frontmatter.input_text
  end

  def test_it_extracts_the_raw_frontmatter_from_the_input
    expected = ["layout: page", "title: Filters", "section: Controllers"]
    assert_equal expected, @frontmatter.extract_frontmatter    
  end

  def test_it_extracts_the_title
    expected = "Filters"
    assert_equal expected, @frontmatter.title
  end

  def test_it_extracts_the_section
    expected = "Controllers"
    assert_equal expected, @frontmatter.section
  end

  def test_it_generates_frontmatter
    expected = "title: Filters\noutput: basic.html\ncontrols: true"
    assert_equal expected, @frontmatter.generate
  end
  # def test_it_generates_the_needed_fields
  #   # title: Basic Example
  #   # author:
  #   #   name: Jordan Scales
  #   #   twitter: jdan
  #   #   url: http://jordanscales.com
  #   # style: basic-style.css
  #   # output: basic.html

  # end
end
