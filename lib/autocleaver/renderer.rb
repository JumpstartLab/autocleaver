module Autocleaver
  class Renderer
    SENTENCE = /^\w|`/

    attr_reader :input_text

    def initialize(text)
      @input_text = text
    end

    def self.load(filename)
      new(File.read(filename))
    end

    def render
      output_file = File.new("output_file.html", 'w+')
      output_file.write(generate_headers(input_text))
      output_file.write(transpile(input_text))
      output_file.close

      output_file
    end

    def transpile(text)
      text = remove_paragraphs(text)
      result = add_slide_breaks(text)

      result << "\n"
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

    def add_slide_breaks(text)
      inside_code_block = false
      code_block_count = 0
      result = text.split("\n").map do |line|
        if code_block_count == 2
          inside_code_block = false
          code_block_count = 0
        end
        if code_block_edge?(line)
          inside_code_block = true
          code_block_count += 1
        end
        if header?(line) && !inside_code_block
          "--\n\n#{line}"
        else
          line
        end
      end.join("\n")
    end

    def remove_paragraphs(text)
      code_block = false
      lag_code_block = false
      code_block_count = 0

      text.split("\n").map do |line|
        code_block = false if !lag_code_block && code_block_edge?(line)

        if code_block_edge?(line)
          code_block = true
          code_block_count += 1
        end

        lag_code_block = code_block_edge?(line)
        current_code_block = code_block
        if code_block_count == 2
          code_block = false
          code_block_count = 0
        end
        line if current_code_block || !is_paragraph?(line)
      end.compact.join("\n")
    end

    def is_paragraph?(line)
      line.match(SENTENCE)
    end

    def header?(line)
      line.strip.start_with?("#")
    end

    def code_block_edge?(line)
      line.strip.start_with?("```")
    end

  end
end
