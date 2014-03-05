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
    # What does the ruby send method do and why would we use it?
    # http://ruby-doc.org/core-2.1.0/Object.html#method-i-send
    send(input) if command_valid?(input)
  end

  def command_valid?(input)
    APPROVED_COMMANDS.include?(input.downcase.to_sym)
  end

  def search
    puts "What would you like to search for?"
    term = gets.chomp
    max_delivery_search = MaxDeliverySearch.new(term)
    puts "Available at MaxDelivery.com..."
    results = max_delivery_search.search
    results[0..2].each {|result| puts result.join(" | ")}
    fresh_direct_search = FreshDirectSearch.new(term)
    puts "Available at FreshDirect.com..."
    results = fresh_direct_search.search
    results[0..2].each {|result| puts result.join(" | ")}
  end

  def command_request
    self.command(user_input)
  end

  def user_input
    gets.downcase.strip
  end
end
