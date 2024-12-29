require 'mina/rails'
require 'mina/git'
require 'mina/rbenv' # for rbenv support. (https://rbenv.org)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'charidy'
set :domain, 'ct'
set :deploy_to, '/var/www/chesedtrain'

set :repository, 'git@github.com:staycreativedesign/chesedtrain.git'
set :branch, 'main'

# Optional settings:
# set :user, 'deploy'
#   set :port, '30000'           # SSH port number.
set :forward_agent, true

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
set :shared_dirs,
    fetch(:shared_dirs, []).push('public/assets', 'public/uploads', 'public/storage', 'tmp/pids', 'tmp/cache',
                                 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system')
set :shared_files,
    fetch(:shared_files, []).push('config/database.yml', 'config/master.key', 'config/storage.yml',
                                  'config/credentials.ym.enc')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  command %(rbenv install 3.2.2)
  command %( nvm use 18.18.0 )
  command %(gem install bundler 2.6.2)
end

desc 'Deploys the current version to the server.'
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set LinXZ231!1veCr3drErj*!xup an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %(mkdir -p tmp/)
        command %(touch tmp/restart.txt)
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
