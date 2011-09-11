# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "odfdom/version"

Gem::Specification.new do |s|
  s.name        = "odfdom"
  s.version     = Odfdom::VERSION
  s.authors     = ["Tobias Pfeiffer"]
  s.email       = ["tobias.pfeiffer@student.hpi.uni-potsdam.de"]
  s.homepage    = ""
  s.summary     = %q{A gem wrapping the ODFDOM library using JRuby}
  s.description = %q{A gem wrapping the ODFDOM library using JRuby}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end

