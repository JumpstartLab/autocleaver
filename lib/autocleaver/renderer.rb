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

      output_file
    end

    def transpile(text)
      header = ""
      frontmatter = Autocleaver::Frontmatter.new(text)
      header << frontmatter.generate
      header << "\n\n--\n\n"
      header << "# #{frontmatter.title}\n"
      header << "## #{frontmatter.section}\n\n"
    end

  end
end
