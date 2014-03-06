class LazyShopperCLI
  APPROVED_COMMANDS = [:search, :exit, :help]

  def initialize
    puts <<-TEXT
+-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+
|L| |a| |z| |y| |S| |h| |o| |p| |p| |e| |r|
+-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+ +-+
Welcome to LazyShopper!

    TEXT

    @on = true
  end

  def on?
    @on
  end

  def call
    while on?
      self.prompt
    end
  end

  def exit
    @on = false
  end

  def help
    puts <<-TEXT
"search" to search for a grocery item
"exit" to quit
"help" to list these commands again
    TEXT
    self.command_request
  end

  def prompt
    puts "Enter a command:"
    self.command_request
  end

  def command(input)
    send(input) if command_valid?(input)
  end

  def command_valid?(input)
    APPROVED_COMMANDS.include?(input.downcase.to_sym)
  end

  def command_request
    self.command(user_input)
  end

  def user_input
    gets.downcase.strip
  end

  def search
    puts "What would you like to search for?"
    term = gets.chomp
    puts "wait for it..."

    max_delivery_search(term, 5)
    fresh_direct_search(term, 5)
  end

  def max_delivery_search(term, count)
    max_delivery_search = MaxDeliverySearch.new(term)
    results = max_delivery_search.search
    if results.count > 0
      puts "\nAvailable at MaxDelivery.com:"
      format_results(results[0..count-1]).each { |item| puts item }
    end
  end

  def fresh_direct_search(term, count)
    fresh_direct_search = FreshDirectSearch.new(term)
    results = fresh_direct_search.search
    if results.count > 0
      puts "\nAvailable at FreshDirect.com:"
      format_results(results[0..count-1]).each { |item| puts item }
    end
  end

  def format_results(array)
    array.collect do |result| 
      product_name = result[0][0..30]
      product_name.concat("…") if product_name != result[0]
      price = "at #{result[1].green}" if result[1]
      link = ShortURL.shorten(result[2], :tinyurl)

      formatted_result = <<-TEXT
#{product_name.white} #{price} (#{link})
      TEXT
    end
  end
end
