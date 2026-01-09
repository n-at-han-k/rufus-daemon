# frozen_string_literal: true

require_relative "lib/rufus/daemon"

Gem::Specification.new do |spec|
  spec.name = "rufus-daemon"
  spec.version = Rufus::Daemon::VERSION
  spec.authors = ["Nathan Kidd"]
  spec.email = ["nathankidd@hey.com"]

  spec.summary = "Run rufus-scheduler in the background"

  spec.description = <<~DESC
    Run rufus-scheduler in the background with a DRb unix socket.
    You can save schedule files in the ~/.rufus directory or as ~/rufus.rb
  DESC

  spec.homepage = "https://github.com/n-at-han-k/rufus-daemon"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|data)/}) }
  spec.bindir = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rufus-scheduler", "~> 3.9"
  spec.add_dependency "drb"

  #spec.add_development_dependency "minitest", "~> 5.0"
  #spec.add_development_dependency "rake", "~> 13.0"
  #spec.add_development_dependency "rubocop", "~> 1.21"
  #spec.add_development_dependency "yard", "~> 0.9"
end
