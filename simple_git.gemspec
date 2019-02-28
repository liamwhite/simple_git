$:.unshift File.dirname(__FILE__)

require 'lib/simple_git/version'

Gem::Specification.new do |s|
  s.name        = 'simple_git'
  s.version     = SimpleGit::VERSION
  s.date        = '2019-02-27'
  s.summary     = "High-level git wrapper over rb-libgit2"
  s.description = "JRuby-compatible high level git library"
  s.authors     = ["Liam P. White"]
  s.email       = 'liamwhite@users.noreply.github.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/liamwhite/simple_git'
  s.license     = 'MIT'

  s.add_runtime_dependency 'rb-libgit2', '~> 0.27'
end
