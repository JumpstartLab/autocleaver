require 'pry'
module Autocleaver
  class Renderer

    attr_reader :input_text

    def initialize(text)
      @input_text = text
    end

    def self.load(filename)
      new(File.read(filename))
    end

    def render
      output_file = File.new("output_file.html", 'w+')

      # generate_headers

      output_file
    end

    def transpile(text)
      text.split("\n").map do |line|
        line unless is_paragraph?(line)
      end.compact.join("\n")
    end

    def generate_headers(text)
      frontmatter = Autocleaver::Frontmatter.new(text)
      header = ""
      header << frontmatter.generate
      header << "\n\n--\n\n"
      header << "# #{frontmatter.title}\n"
      header << "## #{frontmatter.section}\n\n"
    end

    private

    def is_paragraph?(line)
      line.match(/^\w/)
    end

  end
end
