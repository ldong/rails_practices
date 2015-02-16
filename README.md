# Riding On Rails

Author: Lin Dong

Date: Fri Feb 13 03:35:58 PST 2015

Notes I took while learning Riding on Rails

Rails version was 3.2.

## 1. Install

I use `vagrant` to do RoR developement, so grab one of vagrantfile from `rove.io`

After install rails, `rails s -b 0.0.0.0`, and then you can see the result from
your home machine on http://localhost:3000


Please take a little to read the installation guide [here](http://railsapps.github.io/installing-rails.html)

You must install **NodeJS** after Rails 3.1 for building webpages.

## 2. Controller

`rails`:

1. `-d` select database, `SQLite3` is default
2. `-J` select JavaScript libraries, `jQuery` is default

App:
* assets: css, js, coffee
* controllers: requests and responses
* helpers: utilities functions
* mailers: to send emails
* models: all the files interactive with databases, `activeRecord Base` as default class
* views: templates

Config:
* database.yml: config to access DB and credentials
* routes: handles routes

DB:
DB: migration file

Gemfile:
All the gem files we want to use

`rails new APP`: start a new rails project

`rails s`: rails server, to boot up

`rails g controller controllerName action1 action2`

## 3. Models

`rails g model issue`

`rails g model issue title:string description:text no_followers:integer`


rake: make for ruby

i.e.

`rake db:mirgrate`


`rails console`, irb like but with rails built-in.

## 4. Scaffold
`rails new new_Issues`

`rails g scaffold issue title description:text no_followers:integer`

`rake db:migrate`

Controller:

1. `index`: get a list of resources
2. `show`: get a single
3. `new`: create one
4. `edit`: edit existing one
5. `create`: create a new one
6. `update`: update
7. `destroy`: remove


## 5. Routing

Router -> Controller

Rails is resourceful.

```
GET /issues            --> index
GET /issues/:id        --> show
Get /issues/new        --> new
Get /issues/:id/edit   --> edit
POST /issues           --> create
PUT /issues/:id        --> update
DELETE /issues/:id     --> destroy
```

Use `rake routes` to see all the available routes for the project

Use **curl** or other frameworks to test routes

See configuration file in `config/routes.rb`.

See more [here](http://guides.rubyonrails.org/routing.html)

## 6. Render and redirect

Log file is in **log/development.log**

render: action response to html format by default

rails will search the same name of the controller folder in the *Views* directory
to see the file name as the action


```ruby
class IssuesController < ApplicationController
    def index
        @issues = Issues.all
        render :inline => "<p>OK</p>"
        render "shared/fileName"
        render "/usr/share/myTemplate"

        render js:  "alert('Hello world)"
        render json: "/usr/share/myTemplate"
        render xml: "/usr/share/myTemplate"

        head status: 404
        head status: 503
    end

    def create
        @issue = Issue.new(issue_params)

        respond_to do |format|
            if @issue.save
                # logics
            else
                # logics
            end
        end
    end
end
```

Notes:

* `flash` variable:
* `before_filter`:
    1. **only**: `before_filter :validate_user, only: [:index, :show]`
    2. **except**: `before_filter :validate_user, except: [:index, :show]`
* `after_filter`: similarly to `before_filter`


## 7. Layout

Using layout for templates. `yield`, `content_for` is the keyword.

See example in `views/issues/index.html.erb` and `views/layouts/application.html.erb`

## ERB Tags

1. `<% Ruby code -- inline with output %>`, execute ruby code and not print out the return value
2. `<%= Ruby expression -- replace with result %>`, execute ruby code and print out the return value
3. `<%# comment -- ignored -- useful in testing %>`, comments

See [doc](http://apidock.com/ruby/ERB)

## 8. View Helpers

use `render` to render a partial html template


Form:

```
<h2>search</h2>
<%= form_tag '/search' , method: :get do %>
<% end %>
```

Helper Methods:
* link_to
* highlight
* pluralize
* truncate

See [More](http://api.rubyonrails.org/classes/ActionView/Helpers.html)

## 9. Content Negotiation

Add the following changes in `controller`
```
def index
    @issues = Issue.all
    respond_to do | format |
      format.html #index.html.erb
      format.json {render json: @issues}
      format.xml {render xml: @issues}
      format.rss # index.rss.builder
    end
  end
```

Create a file `views/issues/index.rss.builder`

## 10. Query Interface

`rails console`

Examples:

```ruby
Issue.first

Issue.last

Issue.destroy_all

Issue.order('title').first

Issue.order('title').last

Issue.order('title desc')

Issue.order('title desc').first

Issue.order('title desc').last

Issue.order('title desc').limit 3

Issue.order('title').find(1)

Issue.order('title').find(100)

Issue.find_by_no_followers(1)

Issue.find_all_by_no_followers(1), deprecated.

Issue.where(no_followers: 0)
Issue.where(no_followers: 1)
Issue.where(no_followers: 1)

Issue.all
Issue.where(no_followers: 1).all

Issue.where("no_followers= ?", 1)

# Chaining
Issue.where("no_followers= ?", 1).where("title= ?", 'Check box')

```

All dynamic methods except for find_by_... and find_by_...! are deprecated. Here's how you can rewrite the code:

```
find_all_by_... can be rewritten using where(...).
find_last_by_... can be rewritten using where(...).last.
scoped_by_... can be rewritten using where(...).
find_or_initialize_by_... can be rewritten using find_or_initialize_by(...).
find_or_create_by_... can be rewritten using find_or_create_by(...).
find_or_create_by_...! can be rewritten using find_or_create_by!(...).
```

More example [here](http://guides.rubyonrails.org/active_record_querying.html)

## 11. Validations

In your application.rb, add the app/validators path to the auto load path

```ruby
config.autoload_paths += [Rails.root.join('app', 'validators').to_s]
```

## 12. Relationships between models

```ruby
rails g scaffold project name description:text
rake db:migrate
rails g migration add_project_id_to_issues project_id:integer

# ./db/migrate/
vim db/migrate/20150215182003_add_project_id_to_issues.rb
rake db:migrate

rake db:rollback

# Add change with default ID
class AddProjectIdToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :project_id, :integer, :default => 1
  end
end

rake db:migrate
rails c
Issue.all

# Get all items with specific attributes
Issue.pluck :project_id
```

More relationships:

```
Project class
Issue class

has_many :issues     #project.issues
belongs_to :project  #issue.project

has_one :issue #project.issue
belongs_to :project  #issue.project

has_many :issues, through: :join_model
has_many :projects, through: :join_model

has_many_and_belongs_to :issues
has_many_and_belongs_to :project

create_table :issues_projects, :id => false do |t|
             # ^ i comes before p
    t.references :issue,   :null => false
    t.references :project, :null => false
end
add_index(:issues_project, [:issue_id, :project_id], :unique => true)
```

Of course, `has_many_and_belongs_to`.

"DEPRECATED: Using additional attributes on has_and_belongs_to_many
associations. Instead upgrade your association to be a real join model.

Use `has_many :through` instead or one actual `join_model`

Alternative:

```ruby
  1 class Issue < ActiveRecord::Base
  2   validates_presence_of :title
  3   validates_uniqueness_of :title, message: 'Title should be unique, sir.'
  4
  5   validates_length_of :description, minimum: 10, maximum: 20
  6   validates_numericality_of :no_followers, allow_blank: true
  7
  8   validates_with Yesnovalidator
  9   belongs_to :project
 10   has_many :projects, through: :join_model
 11 end
 12
 13 # needed to act as join model
 14 class JoinModel < ActiveRecord::Base
 15   belongs_to :project
 16   belongs_to :issue
 17 end

  1 class Project < ActiveRecord::Base
  2   has_one :issue
  3
  4   has_many :issues, through: :join_model # project.issues
  5   has_many :join_model                   # project.join_model
  6 end
```

[1-1, 1-M, M-M](http://archive.railsforum.com/viewtopic.php?id=12144)

## 13. Callbacks

`rails g controller timeline index`

`vim config/routes.rb`

`http://localhost:3000/timeline/index`

Add `<li><a href="/timeline/index">Timeline</a></li>` to view/layouts/application.html.erb

`rails g model timeline content timelineable_type timelineable_id:integer`


add the following to `Issue < ActiveRecord::Base`


```ruby
after_save :add_to_timeline
#after_udpate
#after_destroy
#after_create
#before_save
#before_destroy

private
def add_to_timeline
  Timeline.create!({content: 'An issue was created!', timelineable_id: id,
                    timelineable_type: self.class.to_s})
end
```

`rake db:migrate`

`rails c`

`Timeline.all`

Add another Active_record to DB:
`rails g migration add_tags_to_issues tags`


Go to issues controller to permit the parameters:

```ruby
def issue_params
  params.require(:issue).permit(:title, :description, :no_followers, :tags)
end
```

## 14. I18N

`config/application.rb` change `"config.i18n.default_locale = 'zh-CN'"`

Download and save it to `config/locale/zh-CN.yml`
https://raw.githubusercontent.com/svenfuchs/rails-i18n/master/rails/locale/zh-CN.yml

'http://localhost:3000/issues?locale=en'
'http://localhost:3000/zh-CN/issues'
'http://localhost:3000/en/issues'

## 15. Assets Pipeline

* `development.rb` set `config.assets.debug` to `false`
* `application.css`
* `application.js`
* `application.rb`, to change `:sass` to `:less`

## 16. Gemfile

Test, production, development

Use `bundle` to manage gems

1. `bundle install`
2. `bundle update`

Gemfile.lock, gemfile dependencies

`gem "haml-rails"`

HAML example

## 17. Email

`rails g mailer issue_mailer`

## 18. Some More Tips

Sites:

* Ruby on rails guide
* Railscasts
* Ruby toolbox
* Tutsplus
* Reddit.com/r/rails

Useful Gem:

* Authentication: Devise, sorcery
* File uploads: CarrierWave
* PDF generation: PDFKit, Prawn
* Deployment: Capistrano, Heroku
* Fulltext search: Sunspot, Thinking sphinx
* SOAP webservices: Savon

## Resource
[Others notes](https://github.com/jingen/rails/blob/master/notes.sh)



## Rails tutorial I wish I had

[Video](https://www.youtube.com/watch?v=1D3_ivHhKXI)

`rails new appsName -T`, tells to create TDD

gem file

```
group :test, :development do
    gem 'turn'
    gem 'rspec-rails'
    gem 'capybara'
    gem 'guard-rspec'
    gem 'growl_notify'
end
```

`rails g`, to see what generators are available

`rails g rspec:install`

`graud` to run test

`gem install rbs-event`





#for user authentication
gem 'devise'

#for layout and helpers generations
gem "nifty-generators", :group => :development


require 'spec_helper'




# Steps

```text
vagrant@vagrant:~/issues$ rails g controller hello world cowsay
Warning: You're using Rubygems 2.0.14 with Spring. Upgrade to at least Rubygems 2.1.0 and run `gem pristine --all` for better startup performance.
      create  app/controllers/hello_controller.rb
       route  get 'hello/cowsay'
       route  get 'hello/world'
      invoke  erb
      create    app/views/hello
      create    app/views/hello/world.html.erb
      create    app/views/hello/cowsay.html.erb
      invoke  test_unit
      create    test/controllers/hello_controller_test.rb
      invoke  helper
      create    app/helpers/hello_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    js
      create      app/assets/javascripts/hello.js
      invoke    scss
      create      app/assets/stylesheets/hello.scss

vagrant@vagrant:~/issues$ rails g model hello world cowsay
Warning: You're using Rubygems 2.0.14 with Spring. Upgrade to at least Rubygems 2.1.0 and run `gem pristine --all` for better startup performance.
      invoke  active_record
      create    db/migrate/20150214091319_create_hellos.rb
      create    app/models/hello.rb
      invoke    test_unit
      create      test/models/hello_test.rb
      create      test/fixtures/hellos.yml

rails g model issue title:string description:text no_followers:integer

rails console

Issue.all

Issue.create(title: 'My 1st issue', description: "something", no_followers: 0)
Issue.create(title: 'My 2nd issue', description: "something")

Issue.all
pp Issue.all

```

string gsub

```ruby
"hello".gsub(/[aeiou]/, '*')                  #=> "h*ll*"
"hello".gsub(/([aeiou])/, '<\1>')             #=> "h<e>ll<o>"
"hello".gsub(/./) {|s| s.ord.to_s + ' '}      #=> "104 101 108 108 111 "
"hello".gsub(/(?<foo>[aeiou])/, '{\k<foo>}')  #=> "h{e}ll{o}"
'hello'.gsub(/[eo]/, 'e' => 3, 'o' => '*')    #=> "h3ll*"
```
