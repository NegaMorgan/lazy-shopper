class LazyShopperCLI
  # attr_accessor :songs
  APPROVED_COMMANDS = [:search, :exit, :help]

  def initialize
    puts "Welcome to Lazy Shopper"

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
"search term" to search for a grocery item
"exit" to quit
"help" to list these commands again
    TEXT
    self.command_request
  end

  def prompt
    puts "Enter a command..."
    self.command_request
  end

  def command(input)
    send(input) if command_valid?(input)
  end

  def command_valid?(input)
    APPROVED_COMMANDS.include?(input.downcase.to_sym)
  end

  def search
    count = 5
    puts "What would you like to search for?"
    term = gets.chomp
    puts "wait for it..."

    max_delivery_search = MaxDeliverySearch.new(term)
    results = max_delivery_search.search
    puts "\nAvailable at MaxDelivery.com:" if results.count > 0
    results[0..count-1].each do |result| 
      product_name = result[0][0..30]
      product_name.concat("...") if product_name != result[0]
      price = "at #{result[1].green}" if result[1]
      puts <<-TEXT
#{product_name.white} #{price} (#{result[2]})
      TEXT
    end
    results = []

    fresh_direct_search = FreshDirectSearch.new(term)
    results = fresh_direct_search.search
    puts "\nAvailable at FreshDirect.com:" if results.count > 0
    results[0..count-1].each do |result| 
      product_name = result[0][0..30]
      product_name.concat("...") if product_name != result[0]
      price = "at #{result[1].green}" if result[1]
      puts <<-TEXT
#{product_name.white} #{price} (#{result[2]})
      TEXT
    end
    results = []

    # delivery_dot_com_search = DeliveryDotComSearch.new(term)
    # results = delivery_dot_com_search.search
  end

  def command_request
    self.command(user_input)
  end

  def user_input
    gets.downcase.strip
  end
end
