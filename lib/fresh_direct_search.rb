class FreshDirectSearch

  BASE_URL = "https://www.freshdirect.com"
  REQUEST_URL = "https://www.freshdirect.com/search.jsp?searchParams="

  def initialize(search_term)
    @term = search_term.gsub(" ", "+")
  end

  def search
    page = Nokogiri::HTML(open(request_url))

    query_title = page.css("span.search-string").text

    names = page.css("div.items .grid-item-name a").text.split("\n\t")
    products = names.select { |p| p.length > 0 }

    figures = page.css("div.items .grid-item-price .prices").text.split("\n\t\t")
    prices = figures.select { |p| p.length > 0 }

    links = page.css("div.items .grid-item-name a").collect { |link| BASE_URL + link.attribute("href").value }

    products.zip(prices, links)
  end

  def request_url
    REQUEST_URL + @term
  end

end
