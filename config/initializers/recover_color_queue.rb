# After a server/worker restart, if there are queued colors but no pending
# DisplayNextColorJob, re-enqueue one so the queue resumes automatically.
Rails.application.config.after_initialize do
  next if Rails.env.test?
  next unless defined?(SolidQueue)
  next unless ActiveRecord::Base.connection.table_exists?("solid_queue_jobs")

  if QueuedColor.any? &&
     SolidQueue::Job.where(class_name: "DisplayNextColorJob", finished_at: nil).none?
    DisplayNextColorJob.set(wait: QueuedColor::DURATION_TIME.seconds).perform_later
  end
rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid
  nil  # skip during db:create / db:migrate
end
