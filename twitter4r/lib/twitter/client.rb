# client.rb contains the classes, methods and extends <tt>Twitter4R</tt> 
# features to define client calls to the Twitter REST API.
# 
# See:
# * <tt>Twitter::Client</tt>

# Used to query or post to the Twitter REST API to simplify code.
class Twitter::Client
  include Twitter::ClassUtilMixin
end

require('twitter4r/lib/twitter/client/base')
require('twitter4r/lib/twitter/client/timeline')
require('twitter4r/lib/twitter/client/status')
require('twitter4r/lib/twitter/client/friendship')
require('twitter4r/lib/twitter/client/messaging')
require('twitter4r/lib/twitter/client/user')
require('twitter4r/lib/twitter/client/auth')
require('twitter4r/lib/twitter/client/favorites')
require('twitter4r/lib/twitter/client/blocks')
require('twitter4r/lib/twitter/client/account')
require('twitter4r/lib/twitter/client/graph')
require('twitter4r/lib/twitter/client/profile')
require('twitter4r/lib/twitter/client/search')
