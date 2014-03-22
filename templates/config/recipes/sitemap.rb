namespace :sitemap do

  # task :copy_old_sitemap do
  #   run "if [ -e #{previous_release}/public/sitemap.xml.gz ]; then cp #{previous_release}/public/sitemap* #{current_release}/public/; fi"
  # end
  # after "deploy:update_code", "sitemap:copy_old_sitemap"


  task :refresh_sitemaps do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake sitemap:refresh"
  end
  after "deploy", "sitemap:refresh_sitemaps"
end