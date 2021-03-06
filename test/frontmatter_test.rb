require 'autocleaver/frontmatter'

class FrontmatterTest < Minitest::Test
  attr_reader :frontmatter

  def setup
    data_file = File.expand_path '../support/sample_input.markdown', __FILE__
    @frontmatter = Autocleaver::Frontmatter.load(data_file)
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
    expected = "title: Filters\noutput: filters.html\ncontrols: true"
    assert_equal expected, @frontmatter.generate
  end

  def test_it_generates_the_needed_header
     expected=<<EOS
title: Filters
output: filters.html
controls: true

--

# Filters
## Controllers

EOS
     assert_equal expected, @frontmatter.to_s
   end
end
