# Hubbado Policy

A lightweight, flexible policy framework for Ruby applications that helps you implement authorization logic in a consistent way.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hubbado-policy'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install hubbado-policy
```

## Overview

Hubbado Policy provides three main components:

1. **Policy** - Defines authorization rules
2. **Result** - Represents the outcome of policy checks
3. **Scope** - Filters collections based on authorization rules

## Policy Objects

Policy objects encapsulate authorization logic and determine whether certain actions are permitted for a given user and record combination.

### Basic Usage

```ruby
class ArticlePolicy < Hubbado::Policy::Base
  define_policy :view do
    return permitted if user.admin?

    if record.published?
      permitted
    else
      denied(:not_published)
    end
  end

  define_policy :edit do
    return permitted if user.admin?

    if record.author == user
      permitted
    else
      denied(:not_author)
    end
  end
end

# Usage
policy = ArticlePolicy.build(current_user, article)

# Check permissions
if policy.view?
  # User can view the article
end

# Get detailed result object
result = policy.edit
if result.permitted?
  # User can edit
else
  # Show error message
  flash[:error] = result.message
end
```

### Policy DSL

The `define_policy` method creates three methods for each policy rule:

1. The base method (e.g., `edit`) that returns a `Result` object
2. A predicate method (e.g., `edit?`) that returns a boolean
3. An underlying implementation method

The policy methods support using `return` statements within the block. If a policy method returns `nil` or doesn't explicitly return a `permitted` or `denied` result, it will automatically default to a generic `denied` result. This simplifies policy implementations by not requiring explicit denials for all paths.

```ruby
define_policy :publish do
  # Early returns work fine
  return permitted if user.admin?
  return denied(:not_verified) unless user.verified?

  # If this evaluates to nil, it automatically becomes a generic denial
  permitted if record.draft? && record.author == user

  # Reaching the end of the method without returning a result
  # will also produce a generic denial
end
```

### Policy Results

Every policy check returns a `Result` object, which can be either permitted or denied with a specific reason.

```ruby
# Allow access
permitted

# Deny access with a reason code
denied(:not_author)

# Deny with additional data
denied(:quota_exceeded, data: { limit: 10, usage: 12 })
```

### Internationalization

Hubbado Policy integrates with I18n for translating error messages:

```ruby
# config/locales/en.yml
en:
  article_policy:
    not_published: "This article hasn't been published yet"
    not_author: "Only the author can edit this article"
  hubbado_policy:
    errors:
      denied: "Access denied"
```

You can also specify a custom i18n scope when returning denied results:

```ruby
define_policy :edit do
  # Use a different i18n scope for this specific denial
  return denied(:not_authorized, i18n_scope: "custom_errors.article")

  permitted
end
```

Both the class method and instance method versions of `denied` support the `i18n_scope` parameter:

```ruby
# Class method
ArticlePolicy.denied(:custom_reason, i18n_scope: "errors.custom")

# Instance method
policy.denied(:custom_reason, i18n_scope: "errors.custom")
```

### Testing

Policies can be mimiced using a built-in control

```ruby
module Control
  module Policies
    module ArticlePolicy
      def self.example(attributes = nil)
        attributes ||= {}
        Policy.new(**attributes)
      end

      class Policy < ::Hubbado::Policy::Controls::Policy
        mimic ::ArticlePolicy
      end
    end
  end
end

mimic_policy = Control::Policies::ArticlePolicy.example
mimic_policy.view? # returns false (denied by default)

# Override specific policies
mimic_policy = Control::Policies::ArticlePolicy.example(view: ArticlePolicy.denied)
mimic_policy.view? # returns false

# Control policy behavior with permit/deny methods
mimic_policy = Control::Policies::ArticlePolicy.example
mimic_policy.permit(:view)
mimic_policy.view? # returns true

mimic_policy.deny(:view)
mimic_policy.view? # returns false

# Deny with reason and data
mimic_policy.deny(:view, :not_authorized)
mimic_policy.deny(:view, data: { reason: "custom data" })
mimic_policy.deny(:view, :not_authorized, data: { user_id: 123 })
```

In addition, there are two RSpec matcher `permit` and `deny` and
have to be required manually:
```ruby
require 'hubbado/policy/rspec_matchers/permit'
require 'hubbado/policy/rspec_matchers/deny'
```

## Result Objects

Result objects represent the outcome of a policy check, containing:

- Permission status (permitted or denied)
- Reason code for denial
- Optional additional data
- I18n integration for error messages

### Usage

```ruby
result = ArticlePolicy.build(current_user, article).view

if result.permitted?
  # Proceed with action
elsif result.denied?
  # Handle denial
  error_message = result.message  # Automatically translated
  additional_data = result.data   # Any extra context provided
end
```

### Built-in Methods

- `permitted?` - Returns true if access is allowed
- `denied?` - Returns true if access is denied
- `generic_deny?` - Returns true if using the default denial reason
- `message` - Returns the localized error message
- `data` - Returns any additional context data

### Error Handling

Policies validate their inputs and will raise errors for invalid usage:

```ruby
# Will raise "User not provided" error
ArticlePolicy.build(nil, article)

# Control policies raise UnkownPolicy for invalid policy names
mimic_policy = Control::Policies::ArticlePolicy.example
mimic_policy.permit(:invalid_policy)  # raises UnkownPolicy
```

### Accessing Result Data

When policies return additional context data, you can access it through the result:

```ruby
# In your policy
define_policy :edit do
  return denied(:quota_exceeded, data: { limit: 10, current: 12 }) if over_quota?
  permitted
end

# Using the result
result = policy.edit
if result.denied?
  puts result.message  # "You have exceeded your quota"
  puts result.data[:limit]    # 10
  puts result.data[:current]  # 12
end
```

## Scope Objects

Scope objects filter collections based on what a user is authorized to access.

### Basic Usage

Scope objects require two template methods to be implemented in subclasses:

```ruby
class ArticleScope < Hubbado::Policy::Scope
  # Required: Define the base collection to filter
  def self.default_scope
    Article.all
  end

  # Required: Implement the filtering logic
  def resolve(record, scope, **options)
    return scope if record.admin?

    scope.where(published: true).or(scope.where(author_id: record.id))
  end
end

# Usage
visible_articles = ArticleScope.call(current_user)
```

**Required Methods:**
- `default_scope` - Class method that returns the base collection to filter
- `resolve(record, scope, **options)` - Instance method that applies filtering logic

Both methods must be implemented or a `MethodMissing` error will be raised.

**Important:** Like policies, use `Scope.call()` instead of manual instantiation to ensure the `configure` method is called if defined.

### Custom Scopes

You can pass custom base scopes:

```ruby
# Scope only to a specific category
category_articles = ArticleScope.call(
  current_user,
  Article.where(category_id: params[:category_id])
)

# Pass additional options
recent_articles = ArticleScope.call(
  current_user,
  Article.all,
  only_recent: true
)
```

### Testing with Substitutes

Scope objects include a Substitute module for testing:

```ruby
# In your tests
scope = ArticleScope.new
scope.extend(Hubbado::Policy::Scope::Substitute)
scope.result = [article1, article2]

# Now you can assert the scope was called with expected arguments
scope.call(user)
assert scope.scoped?(user)
```

### Using with Eventide Dependency

Hubbado Policy is designed to work seamlessly with the [eventide-project/dependency](https://github.com/eventide-project/dependency) gem. Creating substitutes for testing is as simple as:

```ruby
# Create a substitute instance of ArticleScope
article_scope = Dependency::Substitute.build(ArticleScope)

# Configure the result
article_scope.result = [article1, article2]

# Use in tests
service = SomeService.new
service.article_scope = article_scope

# Run the service
result = service.list_articles(user)

# Verify the scope was called with expected arguments
assert article_scope.scoped?(user)
```

This approach makes testing with substitutes straightforward while maintaining all the benefits of dependency injection.

## Dependency Configuration

Policy and Scope objects support the `configure` instance method that can be defined in a subclass. This method is called when the object is initialized and is intended to be used for configuring dependencies.

### Basic Configuration

```ruby
class ComplexPolicy < HubbadoPolicy::Policy
  attr_reader :permission_service

  def configure
    @permission_service = PermissionService.new
  end

  define_policy :complex_rule do
    if permission_service.check_permission(user, record)
      permitted
    else
      denied(:no_permission)
    end
  end
end
```

### Integration with Eventide Dependency

Hubbado Policy is designed to work seamlessly with the [eventide-project/dependency](https://github.com/eventide-project/dependency) gem for dependency management. This provides a powerful way to handle service dependencies in your policies and scopes.

```ruby
# First, set up your dependencies
require 'dependency'; Dependency.activate
require 'hubbado-policy'

# Then use them in your policy
class ArticlePolicy < HubbadoPolicy::Policy
  dependency :permission_service, PermissionService
  dependency :audit_logger, AuditLogger

  def configure
    PermissionService.configure(self)
    AuditLogger.configure(self)
  end

  define_policy :publish do
    # Log the attempt
    audit_logger.log_action("publish_attempt", user: user, record: record)

    # Check permissions
    if permission_service.can_publish?(user, record)
      permitted
    else
      denied(:cannot_publish)
    end
  end
end
```

### Benefits of Using Dependency

Using the `dependency` gem with Hubbado Policy offers several advantages:

1. **Clear dependency declaration** - Dependencies are explicitly declared at the class level
2. **Consistent initialization** - The `configure` method provides a standard place for setting up dependencies
3. **Testability** - Dependencies can be easily substituted in tests
4. **Service reuse** - Common services can be configured once and reused across policies and scopes

### Using Dependency with Scopes

The same pattern works for Scope objects:

```ruby
class ArticleScope < HubbadoPolicy::Scope
  include Dependency

  dependency :visibility_service, VisibilityService

  def configure
    VisibilityService.configure(self)
  end

  def self.default_scope
    Article.all
  end

  def resolve(record, scope, **options)
    visibility_service.filter_visible_for(record, scope, **options)
  end
end
```

## Rails Integration

Hubbado Policy includes built-in Rails integration through a Railtie that automatically loads the necessary components and configurations.

### Automatic Loading

When used with Rails, the gem automatically loads its default locale file:

```ruby
# lib/hubbado/policy/railtie.rb
module Hubbado
  module Policy
    class Railtie < ::Rails::Railtie
      I18n.load_path << File.expand_path("../../../../config/locales/en.yml", __FILE__)
    end
  end
end
```

The Railtie is loaded automatically when Rails is detected:

```ruby
# lib/hubbado-policy.rb
require "hubbado/policy/railtie" if defined?(Rails::Railtie)
```

### Recommended Rails Setup

For Rails applications, we recommend organizing your policies in the `app/policies` directory:

```
app/
  ├── policies/
  │   ├── application_policy.rb
  │   ├── article_policy.rb
  │   └── user_policy.rb
  ├── scopes/
  │   ├── article_scope.rb
  │   └── user_scope.rb
  ├── controllers/
  ├── models/
  └── ...
```

You may want to create a base `ApplicationPolicy` that all your policies inherit from:

```ruby
# app/policies/application_policy.rb
class ApplicationPolicy < Hubbado::Policy::Base
  # Common methods for all policies
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
