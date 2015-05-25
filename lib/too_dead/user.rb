module TooDead
  class User < ActiveRecord::Base
    has_many :todo_lists, dependent: :destroy
    
  end
end
