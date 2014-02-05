# config/schedule.rb
every 1.day, :at => '3:00 am' do
  rake "-s sitemap:refresh"
end
