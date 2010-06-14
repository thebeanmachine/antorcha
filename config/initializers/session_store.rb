# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_antorcha_session',
  :secret      => '109d8b0f6ac3bd03267a2a6e667e7a32e6b38ad43fdfd4aee25bc864e231acc360c3594e4f70954ebc435e53621422e05937a0d3d45cb33d113272258d8555f0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
