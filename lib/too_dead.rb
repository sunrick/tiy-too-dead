$LOAD_PATH.unshift(File.dirname(__FILE__))

require "too_dead/version"
require 'too_dead/init_db'
require 'too_dead/user'
require 'too_dead/todo_list'
require 'too_dead/todo_item'

require 'pry'
require 'vedeu'

module TooDead
  class Menu
    # include Vedeu
    def initialize
      @user = nil
      @todo_list = nil
    end

    def login(name)
      @user = TooDead::User.find_or_create_by(name: name)
    end

    def delete_user
      @user.destroy
      @user.todo_lists.each {|x| x.destroy}
    end

    def create_list(name)
      @todo_list = @user.todo_lists.find_or_create_by(name: name)
    end

    def delete_list(name)
      @user.todo_lists.where(name: name).destroy_all
    end

    def show_lists
      @user.todo_lists.find_each do |list|
        puts "#{list.id} | #{list.name}"
      end
    end

    def choose_list
      self.show_lists
      puts "Please choose a list to edit! Type number"
      result = gets.chomp
      until result =~ /^\d+$/
        puts "Please choose a number dude..."
        result = gets.chomp
      end
      @todo_list = @user.todo_lists.find(result.to_i)
    end

  end
end

binding.pry