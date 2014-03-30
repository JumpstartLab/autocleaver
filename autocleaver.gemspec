# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "autocleaver/version"

Gem::Specification.new do |s|
  s.name         = "autocleaver"
  s.version      = Autocleaver::VERSION
  s.authors      = ["Simon Taranto",           "Jeff Casimir",          "Josh Cheek"]
  s.email        = ["simon.taranto@gmail.com", "jeff@jumpstartlab.com", "josh.cheek@gmail.com"]
  s.homepage     = "https://github.com/JumpstartLab/autocleaver"
  s.summary      = %q{Converts Markdown tutorials into Cleaver slides}
  s.description  = "There are markdown files that are good for the web, "\
                   "but wouldn't it be delightful if a human could also use them for slides in a presentation? "\
                   "Well, that's what we're doing here, y'all!"
  s.license       = "Creative Commons Attribution-NonCommercial-ShareAlike 3.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "pry",      "~> 0.9.12.6"
  s.add_development_dependency "minitest", "~> 5.3.1"
end
