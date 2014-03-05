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
    puts "What would you like to search for?"
    term = gets.chomp
    puts "wait for it..."

    max_delivery_search = MaxDeliverySearch.new(term)
    results = max_delivery_search.search
    puts "\nAvailable at MaxDelivery.com:" if results.count > 0
    results[0..2].each {|result| puts result.join(" | ")}
    results = []

    fresh_direct_search = FreshDirectSearch.new(term)
    results = fresh_direct_search.search
    puts "\nAvailable at FreshDirect.com:" if results.count > 0
    results[0..2].each {|result| puts result.join(" | ")}
    results = []

    delivery_dot_com_search = DeliveryDotComSearch.new(term)
    results = delivery_dot_com_search.search
  end

  def command_request
    self.command(user_input)
  end

  def user_input
    gets.downcase.strip
  end
end
