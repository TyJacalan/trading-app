module UserCacheManagement
  extend ActiveSupport::Concern

  included do
    private

    def invalidate_cache
      Rails.cache.delete("users_ids")
      Rails.cache.delete("pending_ids")
      Rails.cache.delete("approved_ids")
      Rails.cache.delete("admins_ids")
      Rails.cache.delete("standards_ids")
    end

    def fetch_users(scope)
      cache_key = "#{params[:filter] || 'users'}_ids"
      Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
        scope.order(first_name: :desc).to_a
      end
    end
  end
end
