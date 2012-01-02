# Run this template like this: 
#  rails <myproject> -m intridea.rb
#
# Or if you want to live on the bleeding edge you can use the gist-based template:
#  rails <myproject> -m http://gist.github.com/gists/182433
#
# Author: Peter Jackson
# License: MIT License
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
puts "Applying the Intreda template. Copyright 2012 Intridea, Inc."

git :init 
git :add => "."
git :commit => "-a -m 'Initial Commit -- Before template apply'"

gem 'omniauth'
plugin 'hoptoad_notifier', :git => 'git://github.com/thoughtbot/hoptoad_notifier.git', :submodule => true
plugin 'paperclip', :git => 'git://github.com/thoughtbot/paperclip.git', :submodule => true
plugin 'factory_girl', :git => 'git://github.com/thoughtbot/factory_girl', :submodule => true
# plugin 'limerick_rake', :git => 'git://github.com/thoughtbot/limerick_rake.git', :submodule => true
# plugin "peteonrails-seo-kit", :git => "git://github.com/peteonrails/seo-kit.git", :submodule => true

git :submodule => "init"

gem 'will_paginate'
gem 'haml'
gem "mbleigh-acts-as-taggable-on", :source => "http://gems.github.com", :lib => "acts-as-taggable-on"
gem 'w3c_validators', :version => '0.9.3'
gem 'friendly_id'
gem "peteonrails-simple_tooltips", :lib => "simple_tooltips",:source  => 'http://gems.github.com'
gem "peteonrails-vote_fu", :source => "http://gems.github.com", :lib => "vote_fu"

rake("gems:install", :sudo => true)
rake("gems:unpack")

run("haml --rails .")

run 'mkdir app/views/pages'
file 'app/views/pages/home.html.haml',
%q{.mouseover1
  This is the home page!

= tooltip_for "mouseover1", "Here's the hint!"
}

file 'app/views/layouts/application.html.haml', 
%q{%html
  %head
    %title= application_title("FasterAgile", controller.controller_name, controller.action_name)
    = yield :head
    = stylesheet_link_tag "application", "tooltip"
    = javascript_include_tag :defaults
    
  %body
    #flash= flash_notices
    #header
      #logo
        = render :partial => "shared/logo"  
      .clearfix
      #topnav
        = render :partial => 'shared/topnav'                
    #outer-container
      #main-content
        = yield
      .clearfloat 
    #footer
      #footer-content.ctr
      = render :partial => 'shared/footer'
    = yield :javascript
    = render :partial => 'shared/analytics'    
}

file 'app/helpers/application_helper.rb',
%q{# --- 
module ApplicationHelper
  def application_title(name, controller, action)
    "#{name} #{controller} #{action}"
  end
  
  def flash_notices
    flash_types = [:error, :warning, :notice]

    messages = ((flash_types & flash.keys).collect do |key|
      "$.jGrowl('#{flash[key]}', { header: '#{I18n.t(key, :default => key.to_s)}', theme: '#{key.to_s}'});"
    end.join("\n"))

    if messages.size > 0
      content_tag(:script, :type => "text/javascript") do
        "$(document).ready(function() { #{messages} });"
      end
    else
      ""
    end
  end
end
}

run 'mkdir -p public/stylesheets/sass'
file 'public/stylesheets/sass/util.sass', 
%q{.clearfix
  :clear both
  :width 100%
  :height 0  
}

file 'public/stylesheets/sass/navigation.sass',
%q{@import colors.sass

#topnav
  :margin 0 auto
  :width= !content_width
  :height 100%
  :padding 0px

  .lefttab
    :width auto
    :margin-right= !tabmargin
    :padding= !tabpadding
    :float left
    :font-weight bold

  .righttab
    :width auto
    :margin-left= !tabmargin
    :padding= !tabpadding
    :float right
    :font-weight bold

  .selected
    :background-color= !white
    :color= !black
    a
      :color= !black
      :text-decoration none

  .unselected
    :background-color= !black
    :color= !white
    a
      :color= !white
      :text-decoration none
}

file 'public/stylesheets/sass/application.sass', 
%q{@import colors.sass
@import navigation.sass
@import util.sass

html, body 
  :height 100%
  
body  
  :font 100% Arial, Verdana, sans-serif
  :font-size 14px
  :background-color= !white
  :margin 0 
  :padding 0
  :text-align center
  :color= !textcolor

#footer
  :background url(../images/footer.jpg) repeat-x
  :margin 0px
  :width 100%
  :height= !footer_height
  :position relative

  #footer-content
    :width= !content_width
    :margin 0 auto
    :padding-top 20px  

#header 
  :background url(../images/header.jpg) repeat-x
  :height 99px
      
  #logo 
    :margin 0px auto
    :width= !content_width
    :font-size 3.0em
    :font-weight bold
    :height 65px 
      
#outer-container
  :width= !content_width
  :margin 0px auto
  :background= !white
  :text-align left
  :min-height 70%    
  :position relative

#main-content 
  :padding 10px

  #centerpanel
    :margin-top 30px
    :margin-left auto
    :margin-right auto
    :width 80%
    :border #000 1px solid important 
    :color= !textcolor
    :font-size 1.75em
    
    .headline
      :width 80%
    .sub-headline
      :font-size 0.75em
      :font-weight bold
    .message 
      :margin-top 20px
      :font-size 0.75em
}

file 'public/robots.txt', 
%q{# Ban all spiders from indeing the site until we are ready for SEO launch.
User-Agent: *
Disallow: /
}

file 'config/deploy.rb', 
%q{set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'  

before "deploy:setup", "db:password"

namespace :deploy do
  desc "Default deploy - updated to run migrations"
  task :default do
    set :migrate_target, :latest
    update_code
    migrate
    symlink
    restart
  end

  desc "Run this after every successful deployment" 
  task :after_default do
    cleanup
  end

  before :deploy do
    if real_revision.empty?
      raise "The tag, revision, or branch #{revision} does not exist."
    end
  end
end

namespace :db do
  desc "Create database password in shared path" 
  task :password do
    set :db_password, Proc.new { Capistrano::CLI.password_prompt("Remote database password: ") }
    run "mkdir -p #{shared_path}/config" 
    put db_password, "#{shared_path}/config/dbpassword" 
  end
end

}

run 'mkdir config/deploy'

file 'config/deploy/staging.rb',
%q{# For migrations
set :rails_env, 'staging'

default_run_options[:pty] = true

# Who are we?
set :application, CHANGEME
set :repository, CHANGEME
set :scm, "git"
set :deploy_via, :remote_cache
set :branch, "staging"
set :group_writable, false

# Where to deploy to?
role :web, "staging.CHANGEME.com"
role :app, "staging.CHANGEME.com"
role :db,  "staging.CHANGEME.com", :primary => true

# Deploy details
set :user, CHANGEME
set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false
set :checkout, 'export'

# We need to know how to use mongrel
set :mongrel_rails, '/usr/local/bin/mongrel_rails'
set :mongrel_cluster_config, "#{deploy_to}/#{current_dir}/config/mongrel_cluster_staging.yml"

namespace :deploy do
  after "deploy:restart", 
    "deploy:railsplayground:fix_permissions", 
    "deploy:railsplayground:set_production" ,
    "deploy:railsplayground:kill_dispatch_fcgi",
    "deploy:railsplayground:copy_htaccess"
    
  desc "RailsPlayground version of restart task."
  task :restart do
    railsplayground::kill_dispatch_fcgi
  end
 
  namespace :railsplayground do
    
    desc "Uncomment the RAILS_ENV setting"
    task :set_production do
      run "sed -i.cap.orig -e 's/^# ENV/ENV/' #{release_path}/config/environment.rb"
    end
    
    desc "Kills Ruby instances on RailsPlayground"
    task :kill_dispatch_fcgi do
      run "pkill -9 -u #{user} -f dispatch.fcgi"
    end
    
    desc "Fix g-w issues with RailsPlayground"
    task :fix_permissions do
      run "cd #{current_path}; chmod -R g-w *"
    end
    
    desc "Copy over the RailsPlayground htaccess file"
    task :copy_htaccess do 
      run "cp #{shared_path}/config/htaccess #{release_path}/public/.htaccess"
    end
    
  end
end
}

run "mkdir -p app/views/shared"
file "app/views/shared/_logo.html.haml", "#logo"
file "app/views/shared/_topnav.html.haml", "#topnav"
file "app/views/shared/_footer.html.haml", "#footer"
file "app/views/shared/_analytics.html.haml",
%q{%script{ :type => "text/javascript" }
  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
  document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));

%script{ :type => "text/javascript" }
  try {
  var pageTracker = _gat._getTracker("ENTER TRACKER ID");
  pageTracker._trackPageview();
  } catch(err) {}</script>  
}

file 'config/deploy/production.rb', 
%q{# For migrations
set :rails_env, 'production'

# Who are we?
set :application, CHANGEME
set :repository, CHANGEME
set :scm, "git"
set :deploy_via, :remote_cache
set :branch, "production"

# Where to deploy to?
role :web, "www.CHANGEME.com"
role :app, "www.CHANGEME.com"
role :db,  "www.CHANGEME.com", :primary => true

# Deploy details
set :user, "#{application}"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false
set :checkout, 'export'

# We need to know how to use mongrel
set :mongrel_rails, '/usr/local/bin/mongrel_rails'
set :mongrel_cluster_config, "#{deploy_to}/#{current_dir}/config/mongrel_cluster_production.yml"
}

# I still use the dispatchers and fast_cgi in my staging environment. :) 
file 'public/.htaccess', 
%q{# ---
Options +FollowSymLinks +ExecCGI
AddHandler cgi-script .cgi

RewriteEngine On
RewriteRule ^$ index.html [QSA]
RewriteRule ^([^.]+)$ $1.html [QSA]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.*)$ dispatch.fcgi [QSA,L]
ErrorDocument 500 /500.html
}

run 'mkdir -p "public/stylesheets/sass"'
file 'public/stylesheets/sass/application.sass',  "@import colors.sass"

file 'public/stylesheets/sass/colors.sass', 
%q{!white = #f1f1f1
!black = #000
!blue = #cfe0f0
}

file 'config/initializers/hoptoad.rb', 
%q{
HoptoadNotifier.configure do |config|
  config.api_key = ''
end 
}

file 'config/initializers/time_formats.rb',
%q[
{ :short_date   => "%x",              # 01/03/74
  :long_date    => "%a, %b %d, %Y",   # Mon, Sep 7, 2009
  :header_date  => "%A, %B %d, %Y",   # Tuesday, Sep 07, 2009
  :ics => "%Y%m%dT%H%M%S",             # 20090907T120000 (formatted for ICS / iCal / vCal)
  :w3cdate => '%Y-%m-%d'
}.each do |k, v|
  ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.update(k => v)
end
]

file 'config/initializers/array.rb',
%q{# ---
class Array
  # If +number+ is greater than the size of the array, the method
  # will simply return the array itself sorted randomly
  def randomly_pick(number)
    sort_by{ rand }.slice(0...number)
  end
end  
}

file "lib/tasks/css.rake",
%q{# ---
  require 'w3c_validators'

  def error_messages_for_results(results)
    "Error details follow:" + 
      results.errors.inject("\n") do |memo, err| 
        memo += "   * #{err.message.strip} at line #{err.line.to_s}"
      end
  end

  namespace :css do 
    include W3CValidators 
    desc "Validate all CSS as W3C compliant" 
    task :validate => :environment do 
      v = CSSValidator.new
      v.set_profile!(:css3)
      Dir.glob(File.join(RAILS_ROOT, 'public', 'stylesheets', '*.css')) do |file|
        results = v.validate_file(file)
        puts "CSS File: #{file}: " + ((results.errors.length == 0) ? "Valid!" : error_messages_for_results(results))
      end
    end
  end
}

file 'config/environments/cucumber.rb',
%q{# ---
config.cache_classes = true # This must be true for Cucumber to operate correctly!

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

config.gem 'thoughtbot-factory_girl', 
           :lib => 'factory_girl', 
           :source => 'http://gems.github.com', 
           :version => '>= 1.2.0'

# Cucumber and dependencies
config.gem 'polyglot',
           :version => '0.2.6',
           :lib     => false
config.gem 'treetop',
           :version => '1.2.6',
           :lib     => false
config.gem 'term-ansicolor',
           :version => '1.0.3',
           :lib     => false
config.gem 'diff-lcs',
           :version => '1.1.2',
           :lib     => false
config.gem 'builder',
           :version => '2.1.2',
           :lib     => false
config.gem 'cucumber',
           :version => '0.3.11'

# Webrat and dependencies
# NOTE: don't vendor nokogiri - it's a binary Gem
config.gem 'nokogiri',
           :version => '1.3.3',
           :lib     => false
config.gem 'webrat',
           :version => '0.4.4'

HOST = 'localhost'  
}

file 'config/routes.rb',
%q{ActionController::Routing::Routes.draw do |map|
  map.root :controller => "high_voltage/pages", :action => "show", :id => "home"
  map.connect '/sitemap.xml', :controller => 'sitemap', :action => "sitemap", :format => "xml"
  # Defaults routes have been removed: If you need them, uncomment these two lines
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
}


run 'mkdir db/populate'
run 'mkdir db/populate/development'
run 'mkdir db/populate/staging'
run 'mkdir db/populate/production'

inside 'public/javascripts' do
  run 'wget http://jqueryjs.googlecode.com/svn/trunk/plugins/tooltip/jquery.tooltip.js'
  run 'wget http://jqueryjs.googlecode.com/svn/trunk/plugins/tooltip/jquery.formtooltip.js'
  run 'wget http://jqueryjs.googlecode.com/svn/trunk/plugins/tooltip/lib/jquery.dimensions.js'
  run 'wget http://jqueryjs.googlecode.com/svn/trunk/plugins/checkboxes/jquery.checkboxes.js'
  run 'wget http://jqueryjs.googlecode.com/svn/trunk/plugins/autocomplete/jquery.autocomplete.js'
  run 'wget http://jqueryjs.googlecode.com/svn/trunk/plugins/tablesorter/jquery.tablesorter.js'
end

inside 'public/stylesheets' do
  run 'wget http://jqueryjs.googlecode.com/svn/trunk/plugins/autocomplete/jquery.autocomplete.css'
  run 'css2saas jquery.autocomplete.css sass/jquery.autocomplete.sass'
end


run 'rm public/index.html'
run 'rm public/javascripts/prototype.js'
run 'rm public/javascripts/effects.js'
run 'rm public/javascripts/controls.js'
run 'rm public/javascripts/dragdrop.js'
run 'rmdir test/fixtures'

generate('tooltip')
generate('vote_fu')
generate('seo_kit')

rake("db:migrate")
run('capify .')

git :add => '.'
git :commit => '-a -m "After template application is complete."'

# Start up VIM with the files I want to edit 
run 'vim .'
run 'vim config/email.yml'
run 'vim app/views/layouts/application.html.haml'
run 'vim public/stylesheets/sass/colors.sass'
run 'vim public/stylesheets/sass/application.sass'
run 'vim config/database.yml'
run 'vim config/initializers/hoptoad.rb'
run 'vim config/routes.rb'


