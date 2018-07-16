require 'rufus-scheduler'
# https://github.com/jmettraux/rufus-scheduler#so-rails
# Let's use the rufus-scheduler singleton
#
Rufus::Scheduler.singleton


# Stupid recurrent task to test if it's working
# Uncomment and modify code above to s = Rufus::Scheduler.singleton
#
# s.every '1m' do
#
#   Rails.logger.info "hello, it's #{Time.now}"
#   Rails.logger.flush
# end
