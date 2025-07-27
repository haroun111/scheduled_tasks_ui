# frozen_string_literal: true

require_relative "lib/scheduled_tasks_ui/version"

Gem::Specification.new do |spec|
  spec.name = "scheduled_tasks_ui"
  spec.version = ScheduledTasksUi::VERSION
  spec.authors = ["haroun111"]
  spec.email = ["haroundhim97@gmail.com"]

  spec.summary = "UI and management for scheduled tasks in Rails applications."
  spec.description = "A Rails engine gem providing UI and management features for scheduling and running background tasks."  
  spec.homepage = "https://example.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"]    = "https://example.com"
  spec.metadata["source_code_uri"] = "https://example.com"
  spec.metadata["changelog_uri"]   = "https://example.com/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  minimum_rails_version = "7.1"
  spec.add_dependency("actionpack", ">= #{minimum_rails_version}")
  spec.add_dependency("activejob", ">= #{minimum_rails_version}")
  spec.add_dependency("activerecord", ">= #{minimum_rails_version}")
  spec.add_dependency("csv")
  spec.add_dependency("job-iteration", ">= 1.3.6")
  spec.add_dependency("railties", ">= #{minimum_rails_version}")
  spec.add_dependency("zeitwerk", ">= 2.6.2")
end
  