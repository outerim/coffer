module DataStore
  def self.test_buckets
    %w( bucket __coffer_tokens __coffer_buckets )
  end

  module RealRiak
    def wipe_data_store
      DataStore.test_buckets.each do |bucket|
        bucket = Coffer.store.bucket(bucket)
        bucket.keys.each do |key|
          bucket.delete(key, :rw => 'all')
        end
      end
    end
  end
end
