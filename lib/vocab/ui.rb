module Vocab
  class UI

    attr_accessor :silent

    def initialize()
      @silent = false
    end

    def say( message )
      puts message unless silent
    end
  end
end