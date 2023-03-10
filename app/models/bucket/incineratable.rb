module Bucket::Incineratable
  extend ActiveSupport::Concern

  DELETABLE_AFTER = 25.days
  INCINERATABLE_AFTER = 5.days

  included do
    after_update_commit :change_trashed_to_deleted_later, if: :changed_to_trashed?
    after_update_commit :incinerate_later, if: :changed_to_deleted?

    def delete
      Deletion.new(self).run
    end

    def incinerate
      Incineration.new(self).run
    end

    private
      def change_trashed_to_deleted_later
        Bucket::ChangeTrashedToDeletedJob.schedule(self)
      end

      def incinerate_later
        Bucket::IncinerateJob.schedule(self)
      end
  end
end
