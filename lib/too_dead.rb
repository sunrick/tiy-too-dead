$LOAD_PATH.unshift(File.dirname(__FILE__))

require "too_dead/version"
require 'too_dead/init_db'
require 'too_dead/input_beauty'
require 'too_dead/user'
require 'too_dead/todo_list'
require 'too_dead/todo_item'

require 'pry'
require 'vedeu'
require 'date'

module TooDead

  class Menu
    
    include InputBeauty

    def initialize
      @user = nil
      @todo_list = nil
      @todo_item = nil
    end

    def login
      name = prompt("What user do you want to login as?") {|input| input =~ /^\w+$/}
      @user = User.find_or_create_by(name: name)
      print_dashes
      puts "You are logged in as #{@user.name}"
    end

    def delete_user
      @user.destroy
    end

    def create_list
      result = prompt("What is the name of your list?") {|input| input =~ /^\w+$/}
      @todo_list = @user.todo_lists.find_or_create_by(name: result)
    end

    def delete_list
      self.choose_list
      @todo_list.destroy
    end

    def update_list_name
      result = prompt("Type in your new name!")
      @todo_list.update(name: result)
    end

    def show_lists
      @user.todo_lists.find_each do |list|
        puts "#{list.id} | #{list.name}"
      end
    end

    def choose_list
      result = prompt("Choose a list by number!") {|input| input =~ /^\d+$/}
      @todo_list = @user.todo_lists.find(result.to_i)
    end

    def show_items
      @todo_list.todo_items.find_each do |item|
        puts "#{item.id} | #{item.name} | #{item.due_date} | #{item.status}"
      end
    end

    def choose_item
      result = prompt("Choose an item by number!") {|input| input =~ /^\d+$/}
      @todo_item = @todo_list.todo_items.find(result.to_i)
    end

    def create_item
      name = prompt("What name do you want to give the item?") {|input| input =~ /^\w+$/}
      result = prompt("Do you want to put a due date? (y/n)") {|input| input =~ /^[yn]$/i}
        if result.downcase == "y"
          due_date = prompt("What date do you want? MM/DD/YYYY") {|input| input =~ /^.+$/}
          due_date = DateTime.strptime(due_date, "%m/%d/%Y")
          @todo_item = @todo_list.todo_items.find_or_create_by(name: name)
          @todo_item.update(due_date: due_date)
      else
        @todo_list.todo_items.find_or_create_by(name: name)
      end
    end

    def update_item
      self.choose_item
      result = prompt("What do you want to update? Name (n), Status (s), Due date (d)") {|input| input =~ /^[nsd]$/i}
      if result.downcase == "n"
        self.update_item_name
      elsif result.downcase == "s"
        self.update_item_status
      else
        self.update_item_date
      end
    end

    def update_item_name
      name = prompt("What name do you want?") {|input| input =~ /^\w+$/}
      @todo_item.update(name: name)
    end

    def update_item_status
      status = prompt("What is the status?") {|input| input =~ /^\w+$/}
      @todo_item.update(status: status)
    end

    def update_item_date
      due_date = prompt("What is the due date? MM/DD/YYYY") {|input| input =~ /^.+$/}
      due_date = DateTime.strptime(due_date, "%m/%d/%Y")
      @todo_item.update(due_date: due_date)
    end

    def delete_item
      self.choose_item
      @todo_item.destroy
    end

    def start_options
      result = prompt("What do you want to do? List options (l), Quit (q), Delete account (d)") {|input| input =~ /^[lqd]$/i}
      if result.downcase == "l"
        self.list_options
      elsif result.downcase == "q"
        print_dashes
        puts "Peace out"
        print_dashes
        exit
      else
        self.delete_user
        print_dashes
        puts "User deleted, peace!"
        print_dashes
      end
    end

    def list_options
      puts "These are your current todo lists!"
      self.show_lists
      result = prompt("Do you want to create (c), edit (e), delete (d) a list?") {|input| input =~ /^[ced]$/i}
      if result.downcase == "c"
        self.create_list
      elsif result.downcase == "e"
        self.choose_list
        result = prompt("Do you want to change the name of your list? (y/n)") {|input| input =~ /^[yn]$/i}
        if result.downcase == "y"
          self.update_list_name
        else
          self.item_options
        end
      else
        self.delete_list
      end
    end

    def item_options
      puts "These are your current todo items in your #{@todo_list.name} list!"
      self.show_items
      result = prompt("Do you want to create (c), edit (e), delete (d) an item?") {|input| input =~ /^[ced]$/}
      if result.downcase == "c"
        self.create_item
      elsif result.downcase == "e"
        done_updating = "n"
        until done_updating.downcase == "n"
          self.update_item
          done_updating = prompt("Are you done updating? (y/n)") {|input| input =~ /^[yn]$/i}
        end
      else
        self.delete_item
      end
    end

  end
end

include InputBeauty

def run
  menu = TooDead::Menu.new
  menu.login
  menu.start_options
end

run