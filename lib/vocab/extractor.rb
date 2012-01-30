module Vocab
  module Extractor
    autoload :Base,  'vocab/extractor/base'
    autoload :Rails, 'vocab/extractor/rails'
    autoload :Android, 'vocab/extractor/android'
  end
end