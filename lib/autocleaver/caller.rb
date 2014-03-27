module AutoCleaver
  class Caller
    attr_reader :filepath

    def initialize(filepath)
      @filepath = filepath
    end

    def create_presentation
      Autocleaver::Renderer.load(filepath).render
    end

  end
end
