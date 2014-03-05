class MaxDeliverySearch

  REQUEST_URL = "http://www.maxdelivery.com"

  def initialize(search_term)
    @term = search_term
  end

  def search
    agent = Mechanize.new
    page = agent.get(REQUEST_URL)

    form = page.form('SearchForm')
    form.searchString = @term
    search_results = agent.submit(form)

    search_results.search("div.searchResultItem").collect do |item|
      product = item.search(".searchName a").text.strip
      price = item.search(".price").text.gsub(/[[:space:]]/,"")
      link = REQUEST_URL + item.search(".searchName a").attribute("href").value

      [product, price, link]
    end
  end

end
