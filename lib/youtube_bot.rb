class YoutubeBot
  
  attr_accessor :client

  # Initialize youtube client based on ebearfm@gmail.com app and user's gmail credentials
  # Must initialize simple data youtube client on every app restart
  # OAuth2 client used for retrieving user specific data (i.e. subscriptions, playlist etc.)
  # Inputs: access_token: string - user's google access token
  # =>      refresh_token: string - user's google refresh token
  # =>      nil: - Initialize youtube client based on developer key, use this constructor for simple youtube data api queries
  # Return: none
  def initialize(access_token = nil, refresh_token = nil)
    if access_token.nil? && refresh_token.nil?
      @client = YouTubeIt::Client.new(:dev_key => ENV['GOOGLE_DEV_KEY'])
    else
      if Rails.env.development?
        redirect_uri = "http://localhost:3000"
      elsif Rails.env.production?
        redirect_uri = "https://ebearfm.herokuapp.com"
      end

      # Register client via OAuth2 with access_token
      @client = YouTubeIt::OAuth2Client.new(client_access_token: access_token,
                          client_refresh_token: refresh_token,
                          client_id: ENV['GOOGLE_CLIENT_ID'],
                          client_secret: ENV['GOOGLE_CLIENT_SECRET'],
                          dev_key: ENV['GOOGLE_DEV_KEY'])
    end
  end

  # Retrieves a youtube user's playlists. Throws an error if the google user 
  # doesn't have a linked youtube account
  # Input: none
  # Return: pt_pair - an array, index 0 an array of playlist objects, index 1 an access token if refreshed
  def get_playlists
    pt_pair = []
    begin
      pt_pair.push(@client.playlists)
    rescue OAuth2::Error => error
      if error.response.response.env.status == 401
          # Retrieve Google error message
          message = error.response.response.env.body.match(/<H1>.+?<\/H1>/).to_s.split("<H1>")[1].split("</H1>")[0]

          if message == "NoLinkedYouTubeAccount"
              # TODO: Link them to youtube to create a channel/write better error message
              raise "ERROR: You don't have a Youtube account linked to this Google account."
          elsif message == "Token invalid"
            puts "Invalid access token......refreshing token"
            new_access_token = @client.refresh_access_token!.token
            pt_pair.push(@client.playlists)
            pt_pair.push(new_access_token)
          end
        end 
    end
  end

  def get_playlist_videos(playlist_id)
    @client.playlist(playlist_id).videos
    # vt_pair = []
    # begin
    #   vt_pair.push(@client.playlist(playlist_id).videos)
    # rescue OAuth2::Error => error
    #   if error.response.response.env.status == 401
    #     # Retrieve Google error message
    #     message = error.response.response.env.body.match(/<H1>.+?<\/H1>/).to_s.split("<H1>")[1].split("</H1>")[0]
        
    #     if message == "Token invalid"
    #       puts "Invalid access token......refreshing token"
    #       new_access_token = @client.refresh_access_token!.token
    #       binding.pry
    #       vt_pair.push(@client.playlist(playlist_id))
    #     end
    #   end
    # end
  end

  # Checks if url sent by twitter user is a valid youtube video url
  # Inputs: url: string - url of youtube video
  # Return: boolean - true if valid, false otherwise
  def valid_song(url)
    begin
      video = @client.video_by(url.to_s)

      return true
    resque OpenURI::HTTPError
      puts 'Invalid youtube url'

      return false
    end
  end

  # Gets youtube video object from youtube video url
  # Inputs: url: string - url of youtube video
  # Return: video: YouTubeIt::Model::Video - return video object based on url or nil if not found 
  def get_video(url)
    long_url = unshorten_url(url.to_s)

    begin
      video = @client.video_by(long_url)

      return video
    rescue OpenURI::HTTPError
      puts "Youtube Client ERROR: Could not find video"

      return nil
    end
  end

  private

  # Takes shorten url and retrieves the unshortened version (e.g. https://t.co/e1ATVRfZwm vs. http://www.youtube.com/?watch....)
  # Inputs: url: string - url of youtube video
  # Return: url: string - unshortened youtube video url
  def unshorten_url(url)
    response = Typhoeus.get(url.to_s)
    
    # parse response for unshortened url
    long_url = response.headers[:location]

    return long_url
  end
end