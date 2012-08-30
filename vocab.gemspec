# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vocab/version"

Gem::Specification.new do |s|
  s.name        = "vocab"
  s.version     = Vocab::VERSION
  s.authors     = ["Jeff LaBarge"]
  s.email       = ["jefflabarge@gmail.com"]
  s.homepage    = "https://github.com/zoodles/vocab"
  s.summary     = %q{Automate management of i18n locale files}
  s.description = %q{Export strings that need to be translated and integrate the completed translations}
  s.rubyforge_project = "vocab"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.bindir        = 'bin'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "i18n"
  s.add_dependency "nokogiri"
  s.add_dependency "htmlentities", "~> 4.3.1"
  s.add_dependency "ya2yaml"
  s.add_dependency "active_support"
  s.add_dependency "builder"
  s.add_development_dependency "rspec", "~> 2.7.0"
  s.add_development_dependency "simplecov"
  # s.add_runtime_dependency "rest-client"
end
