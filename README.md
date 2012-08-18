# Soft Launch

Soft Launch is a mechanism that allows you to add new features to a web application, but limit which of your users has access to them. This allows you to give access to a new feature to a limited set of users,
while at the same time letting them try out the new feature in a full production environment.

You use Soft Launch by defining "features". A feature is a piece of functionality that you want to roll out to a specific subset of individuals. An example feature may be a newly designed
account settings page, for example.

You define features in your config/softlaunch.yml file. This file specifies the name of a feature and whether or not the feature should be enabled for a particular rails environment or not.
Here is an example configuration file for launching a newly redesigned accout settings page:

```ruby
development:
  acctsettings:
    name: New Account Settings Page
    status: enabled

test:
  acctsettings:
    name: New Account Settings Page
    status: enabled

production:
  acctsettings:
    name: New Account Settings Page
    status: disabled
```

Now, in your controllers, models, views, helpers, etc., you can query whether a given feature is enabled for a specific page request or not by using code similar to this?

```ruby
if launched? :acctsettings
  ...code for the new page...
else
  ...code for the old page...
end
```

Using Soft Launch, you can enable/disable features by rails environment (shown above). For a disabled feature, you can enable it for a given subset of users.
You can also allow a user to enable the feature by setting a cookie by going to a special URL in your application to enable/disable a feature.

Note: Soft Launch should not be used to enable unstable or untested features. It's purpose isn't to replace the normal testing process. It's purpose is to provide limited exposure to a set
of features before making them more globally available to everyone using your application.

# Installation

Soft Launch requires Rails 3.0 or greater.
Add this to your Gemfile and run the bundle command:

```ruby
gem "softlaunch"
```

Now, run this command:

```ruby
rails generate soft_launch:setup
```

This will create an initializer file and add an entry to your route.rb file.

# Getting Started

Let's say you added a feature to display a new newsfeed on your home page. You want to develop and test that feature in a controlled environment, as normal.
However, you'll want to roll this out to only a few people in production to judge feedback first, before rolling it out to everyone, so you enable
Soft Launch.

Follow the installation instructions above, then you'll find a config/softlaunch.yml file in your application, it will contain something like this:

```yml
development:
  myfeature:
    name: My New Feature
    status: enabled

test:
  myfeature:
    name: My New Feature
    status: enabled

production:
  myfeature:
    name: My New Feature
    status: disabled
```

By default, this feature will be setup to be enabled in development and test, but not production. Let's change the name and identifier of this feature to
something more meaningful to us:

```yml
development:
  newsfeed:
    name: Display home page newsfeed
    status: enabled

test:
  newsfeed:
    name: Display home page newsfeed
    status: enabled

production:
  newsfeed:
    name: Display home page newsfeed
    status: disabled
```

Now, let's go to our view template for our home page:

```erb
file: app/views/home/index.html.erb
...
<%if launched? :newsfeed%>
  <h2>Welcome to my New Newsfeed!</h2>
  <@newsfeed.each do |article%>
    ...
  <%end%>
<%else%>
  Put whatever I had on the page before the newsfeed was added here.
<%end%>
...
```

Since your newsfeed will likely need data from our controller, add it as well:

```ruby
file: app/controllers/home_controller.rb
...
def index
  ... do other stuff here ...
  if launched? :newsfeed
    @newsfeed=NewsFeed.most_recent_news
  end
end
...
```

Now, when you show this page in development and test mode, you'll see the newsfeed. But when it is displayed in production, the original
content is displayed.

Alternately, you can check to see if a feature is launched at a controller level using a filter:

```ruby
file: app/controllers/newsfeed_controller.rb
...
check_softlaunched :newsfeed
...
def index
  ...
end
```

Or for only a few specific actions:

```ruby
file: app/controllers/newsfeed_controller.rb
...
check_softlaunched :newsfeed, only: [:index,:show]
...
def index
  ...
end
```

Or all but a few specific actions:

```ruby
file: app/controllers/newsfeed_controller.rb
...
check_softlaunched :newsfeed, except: [:new,:create]
...
def index
  ...
end
```

If an action is called that matches the check_softlaunched such that the identifier specifies a disabled softlaunch, then a
flash message will be generated and the application will redirect to the root_path URL.

## Enabling it for a Specific Person's Browser
Let's say you want to see what it looks like now in production.
Update your config file to show the following:

```yml
development:
  newsfeed:
    name: Display home page newsfeed
    status: enabled

test:
  newsfeed:
    name: Display home page newsfeed
    status: enabled

production:
  newsfeed:
    name: Display home page newsfeed
    status: user
    usercode: C04D9454C8EB449C8B4E6A72157B4AA4
```

The 'usercode' is a random, unique code assigned to this newsfeed. We used a UUID for this example (sans dashes), but you can
use any value you like. You want the value to be "hard to guess", as it will be used in the URL that enables your new feature
for a specific user and their browser.

Now, in production, go to your home page, you'll see the "old" content. You can enable the new content just for you by going to this
URL:

http://<myapplication>/softlaunch/C04D9454C8EB449C8B4E6A72157B4AA4

On this page, you'll see whether this feature is enabled for your browser or not, and will be given the option to enable/disable this feature.
Enable the feature, and go back to your home page.

You will now see that your home page has the new newsfeed.

Go to a different browser or a different computer and load the home page. You'll see the old content is still visible to you.

A cookie has been set in your browser, which is what is used to enable the feature. It is only enabled for you and only with the
current browser.

You can now give that URL to other people (beta testers, for instance) and let them use the feature. If they have problems with
it or don't like it, they can always turn it off. Note that you should tell them not to share the URL with other people, as
anyone with the URL will know how to enable the feature (which is why the unique identifier should be hard to guess).

At any point in time, you can enable this feature for everybody by changing your config file (and redeploying), changing the
production section of the config file to show this:

```yml
production:
  newsfeed:
    name: Display home page newsfeed
    status: enabled
```

Or, if you want to disable the feature to everyone (because it wasn't well received or you want to work on it some more),
you can change it to this:

```yml
production:
  newsfeed:
    name: Display home page newsfeed
    status: disabled
```

When it is disabled, even people with the cookie set will not be able to see the feature.

Once you have finished permanently launching the feature (or permanently deciding not to launch it), you can go and refactor
your code to remove the "if launched?" statements and the unused code, then remove the feature from the softlaunch.yml
file.

# Questions or Problems?

Please note that this is not yet released, and is still a work in progress.

Suggestions for this gem can be sent to me.

# Testing Soft Launch

Simply run "rake test". The gem uses rspec for all of it's test suites.

# Using Can Can?

If you are using Can Can, and have the following line in your application_controller.rb file:

```ruby
check_authorization
```

You should update it to exclude the soft launch controller:

```ruby
check_authorization :unless => :soft_launch_controller?
```
