class Rack::Attack

  ### Throttle Spammy Clients ###

  # Throttle all requests by IP (60rpm)
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  throttle('req/ip', :limit => 300, :period => 5.minutes) do |req|
    req.ip
  end

  # Block requests from php bots.
  # After 2 blocked requests in 10 minutes, block all requests from that IP for 1 week.
  blacklist('php bots') do |req|
    # `filter` returns truthy value if request fails, or if it's from a previously banned IP
    # so the request is blocked
    Fail2Ban.filter(req.ip, :maxretry => 2, :findtime => 10.minutes, :bantime => 1.week) do
      # The count for the IP is incremented if the return value is truthy.
      CGI.unescape(req.fullpath) =~ /(phpmyadmin|setup\.php|\.cgi\?|System\.xml)/i
    end
  end


  ### Prevent Brute-Force Login Attacks ###

  # The most common brute-force login attack is a brute-force password attack
  # where an attacker simply tries a large number of emails and passwords to see
  # if any credentials match.
  #
  # Another common method of attack is to use a swarm of computers with
  # different IPs to try brute-forcing a password for a specific account.

  # Throttle POST requests to /login by IP address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
  throttle('logins/ip', :limit => 5, :period => 20.seconds) do |req|
    if req.path[/sign_in/] && req.post?
      req.ip
    end
  end
end