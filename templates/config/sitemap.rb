if Rails.env.production?
  
  # Set the host name for URL creation
  SitemapGenerator::Sitemap.default_host = "http://#{Env.host}"

  SitemapGenerator::Sitemap.create do
    # Put links creation logic here.
    #
    # The root path '/' and sitemap index file are added automatically for you.
    # Links are added to the Sitemap in the order they are specified.
    #
    # Usage: add(path, options={})
    #        (default options are used if you don't specify)
    #
    # Defaults: :priority => 0.5, :changefreq => 'weekly',
    #           :lastmod => Time.now, :host => default_host
    #
    # Examples:
    #
    # Add '/articles'
    #
    #   add articles_path, :priority => 0.7, :changefreq => 'daily'
    #
    # Add all articles:
    #

    # If you are using cardboard, uncomment the next lines
    # Cardboard::Page.find_each do |page|
    #   add page_path(page), :lastmod => page.updated_at
    # end
  end

  SitemapGenerator::Sitemap.ping_search_engines
end