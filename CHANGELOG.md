# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [x.x.x] - XXXX-XX-XX

### Added

- Policy control is improved:
  - When using a policy control you could permit or deny with a method
    ```ruby
    mimic_policy = Control::Policies::ArticlePolicy.example
    mimic_policy.permit(:view)
    # or
    mimic_policy.deny(:view)
    mimic_policy.deny(:view, :a_reason) # with a reason
    mimic_policy.deny(:view, data: :custom_data) # with data
    mimic_policy.deny(:view, :a_reason, data: :custom_data) # or both
    ```

## [1.1.1] - 2025-05-26

### Fixed

- Railtie is corrected with an initializer to load I18n locales correctly.

## [1.1.0] - 2025-05-20

### Added

- Control to mimic policies

## [1.0.1] - 2025-05-20

Bump because rubygems does not allow repushing the same version even if it is yanked.

## [1.0.0] - 2025-05-20

### Added

- Initial release of the hubbado-policy gem
- `Policy` class with DSL for defining authorization rules
- `Result` class to represent policy outcomes
- `Scope` class for filtering collections based on permissions
- Testing support with `Substitute` module for scopes
- Rails integration via Railtie
- Full compatibility with the eventide-project/dependency gem

### Documentation

- Comprehensive README with usage examples
- Detailed explanations of all major components
- Rails integration guide
- Testing instructions and examples
