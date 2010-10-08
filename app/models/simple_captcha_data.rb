# Copyright (c) 2008 [Sur http://expressica.com]

class SimpleCaptchaData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key,     :type => String, :limit => 40
  field :value,   :type => String, :limit => 20
  
  class << self
    def get_data(key)
      find_by_key(key) || new(:key => key)
    end
    
    def remove_data(key)
      clear_old_data
      data = find_by_key(key)
      data.destroy if data
    end
    
    def clear_old_data(time = 1.hour.ago)
      return unless Time === time
      destroy_all("updated_at < '#{time.to_s(:db)}'")
    end
    
    def find_by_key(key)
      find(:first, :conditions => { :key => key})
    end
  end
  
end
