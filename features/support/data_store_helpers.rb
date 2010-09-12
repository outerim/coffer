module DataStore
  def self.test_buckets
    %w( bucket )
  end

  module RealRiak
    def wipe_data_store
      DataStore.test_buckets.each do |bucket|
        bucket = Coffer.store.bucket(bucket)
        bucket.keys do |keys|
          keys.each do |key|
            bucket.delete(key, :rw => 'all')
          end
        end
      end
    end
  end
end
