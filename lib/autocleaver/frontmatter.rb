module Autocleaver
  class Frontmatter
    attr_reader :input_text
    attr_accessor :title

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

  end
end
