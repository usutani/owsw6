class Bucket::IncinerateJob < ApplicationJob
  queue_as :incineration
  retry_on Recording::Incineratable::Incineration::RecordableNeedsIncineration

  def self.schedule(account)
    set(wait: Bucket::Incineratable::INCINERATABLE_AFTER).perform_later(account)
  end

  def perform
    bucket.incinerate
  end
end
