module Autocleaver
  class Frontmatter
    attr_reader :input_text
    attr_accessor :title, :style, :output

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
      started = false
      finished = false
      result = []
      input_text.each_line do |line|
        line = line.strip
        unless finished
          if !started
            if line == '---'
              started = true
            end
          elsif line == '---'
            finished = true
          else
            result << line
          end
        end
      end
      return result
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

    def default_output
      "basic.html"
    end

    def default_controls
      "true"
    end

    def generate
      [:title, :output, :controls].map do |key|
        "#{key}: #{send(key)}"
      end.join("\n")
    end

  end
end
