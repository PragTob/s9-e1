# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "odfdom/version"

Gem::Specification.new do |s|
  s.name        = "odfdom"
  s.version     = Odfdom::VERSION
  s.author     = "Tobias Pfeiffer"
  s.email       = "tobias.pfeiffer@student.hpi.uni-potsdam.de"
  s.homepage    = "https://github.com/PragTob/s9-e1"
  s.summary     = %q{A gem wrapping the ODFDOM library using JRuby}
  s.description = %q{A gem wrapping the ODFDOM library using JRuby.
                     Currently only text documents are (partly) supported.}

  s.files         = Dir['lib/**/*.rb'] + %w[
    README.md
    Rakefile
    textcomb.gemspec
    bin/cue.language.jar
  ]
  s.test_files    = Dir['spec/*.rb'] + ['spec/test_files']
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
end

