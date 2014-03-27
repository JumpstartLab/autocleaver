title: Filters
output: filters.html
controls: true

--

# Filters
## Controllers

--

## Before, After, and Around

* `before_filter` runs before the controller action
* `after_filter` runs after the controller action
* `around_filter` yields to the controller action wherever it chooses

--

### Basic Usage

```ruby
class ArticlesController < ApplicationController
  before_filter do
    @article = Article.find(params[:id]) if params[:id]
  end
  #...
```

--

### Basic Usage

```ruby
class ArticlesController < ApplicationController
  before_filter :load_article

  # Actions...

private
  def load_article
    @article = Article.find(params[:id]) if params[:id]
  end
end
```

--

#### `after_filter`

--

#### `around_filter`

```ruby
around_filter :wrap_actions

def wrap_actions
  begin
    yield
  rescue
    render text: "It broke!"
  end
end
```

--

### `only` and `except`

* `:only`: a whitelist of actions for which the filter should run
* `:except`: a blacklist of actions for which the filter should *not* run.

```ruby
class ArticlesController < ApplicationController
  before_filter :load_article, only: [:show, :edit, :update, :destroy]

  # Actions...

private
  def load_article
    @article = Article.find(params[:id])
  end
end
```

--

### `only` and `except`

```ruby
class ArticlesController < ApplicationController
  before_filter :load_article, except: [:index, :new, :create]
  #...
```

--

## Sharing Filters

--

### Sharing through `ApplicationController`

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery

private
  def load_article
    @article = Article.find(params[:id])
  end
end

class ArticlesController < ApplicationController
  before_filter :load_article, only: [:show, :edit, :update, :destroy]

  # Actions...
end
```

--

#### Generalizing to `find_resource`

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery

private
  def find_resource
    class_name = params[:controller].singularize
    klass = class_name.camelize.constantize
    self.instance_variable_set "@" + class_name, klass.find(params[:id])
  end
end

class ArticlesController < ApplicationController
  before_filter :find_resource, only: [:show, :edit, :update, :destroy]

  # Actions...
end
```

--

## Exercises

{% include custom/sample_project_advanced.html %}

1. Implement a `before_filter` in `ArticlesController` to remove all calls to `find` in the actions.
2. Implement an `after_filter` that turns the article titles to all uppercase, but does not change the data in the database.
3. Implement a `before_filter` for just the `create` action on `CommentsController` that replaces the word `"sad"` with `"happy"` in the incoming comment body.
4. Implement an `around_filter` that catches an exception, writes an apology into the `flash[:notice]`, and redirects to the articles `index`. If the exception was raised in `articles#index`, render the message as plain text (`render text: "xyz"`). Cause an exception and make sure it works.

--

## References

* Rails Guide on Controller Filters: http://guides.rubyonrails.org/action_controller_overview.html#filters
