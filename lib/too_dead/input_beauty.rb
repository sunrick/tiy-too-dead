module InputBeauty

  def prompt(question)
    print_dashes
    puts question
    print_dashes
    result = gets.chomp
    until yield(result)
      print_dashes
      puts "Sorry, your input is invalid. #{question}"
      print_dashes
      result = gets.chomp
    end
    result
  end

  def print_dashes
    puts "-"*80
  end

end