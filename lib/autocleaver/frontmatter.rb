module Autocleaver
  class Frontmatter
    attr_reader :input_text
    attr_accessor :title, :style, :output, :section

    def initialize(text)
      @input_text = text
      parse
    end

    def self.load(filename)
      new(File.read(filename))
    end

    def parse
      extract_frontmatter.each do |line|
        key, value = line.split(':', 2).map(&:strip)
        if respond_to?(key + '=')
          self.send(key + '=', value)
        end
      end
    end

    def extract_frontmatter
      # input_text[/(?<=^---$)\n(.*?)\n(?=^---$)/m, 1].lines.map(&:strip) # this works, too, :P
      input_text.each_line
                .map(&:strip)
                .drop_while { |line| line != '---' }
                .drop(1)
                .take_while { |line| line != '---' }
    end

    def style
      @style || default_style
    end

    def default_style
      "basic-style.css"
    end

    def output
      @output || default_output
    end

    def controls
      @controls || default_controls
    end

    def section
      @section
    end

    def default_output
      "#{title.downcase.gsub(" ", '_').strip}.html"
    end

    def default_controls
      "true"
    end

    def generate
      [:title, :output, :controls].map do |key|
        "#{key}: #{send(key)}"
      end.join("\n")
    end

    def to_s
      h = generate
      h << "\n\n--\n\n"
      h << "# #{title}\n"
      h << "## #{section}\n\n"
    end

  end
end
