class DeliveryDotComSearch
  attr_reader :merchants
  TOKEN = "MzI4M2RjN2VjMTM4ZDNiN2I3YjgxNjQ5YWMxZDI4ZGY4"

  def initialize(search_term)
    @term = search_term
    @address = "243 East Broadway 10002".gsub(" ", "%20")
    get_merchants
  end
  def search
    store_ids = @merchants.collect{|m| m[:id]}
    # merchant_urls = @merchants.collect{|m| m[:url]}
    # merchant_urls.collect do |url|
    #   agent = Mechanize.new
    #   page = agent.get(url)

    #   form = page.form_with(:action => 'https://www.delivery.com/catalog_item.php')
    #   form.search_keyword = @term
    #   search_results = agent.submit(form)


    # binding.pry

    merchant_urls = store_ids.collect { |store_id| "https://api.delivery.com/merchant/#{store_id}/menu?client_id=#{TOKEN}&address=#{@address}" }
    merchant_urls.collect do |url|
      page = RestClient.get(url)
      menu = JSON.parse(page)
      
      # want to do /\W#{@term}\W/ but the backslashes are stripped :(
      search_string = "$..name[?(@.match(/#{@term}/))]"
      products = JsonPath.new(search_string).on(menu)
      #binding.pry
      products.size > 0 ? products : nil

      # binding.pry
    end
  end
  def get_merchants
    page = RestClient.get("https://api.delivery.com/merchant/search/delivery?client_id=#{TOKEN}&address=#{@address}&merchant_type=I")
    store_fronts = JSON.parse(page)
    @merchants = store_fronts["merchants"].collect do |merchant| 
      {
        :id => merchant["id"],
        :name => merchant["summary"]["name"],
        :url => merchant["summary"]["url"]["complete"],
        :is_open => merchant["ordering"]["is_open"]
      }
    end
  end
end







# class DeliveryDotComSearch
#   TOKEN = "MzI4M2RjN2VjMTM4ZDNiN2I3YjgxNjQ5YWMxZDI4ZGY4"
#   MERCHANTS_URL = "https://api.delivery.com/merchant/search/delivery?client_id=#{TOKEN}&address=243%20east%20broadway%2010002"
#   MERCHANT_URL = "https://api.delivery.com/merchant/74911/menu?client_id=#{TOKEN}&address=243%20east%20broadway%2010002"
  
#   include HTTParty
#   format :json

#   def self.search(term)
#     #term = "Super Nutty Granola"
#     get(MERCHANT_URL, :query => {"name" => term, :output => 'json'})
#   end
# end

# puts DeliveryDotComSearch.search("Super Nutty Granola").inspect