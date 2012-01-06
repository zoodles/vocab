require "bundler/gem_tasks"

require "rspec/core/rake_task"
Rspec::Core::RakeTask.new(:spec)

gemspec = eval(File.read("vocab.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["vocab.gemspec"] do
  system "gem build vocab.gemspec"
  system "gem install vocab-#{Vocab::VERSION}.gem"
end