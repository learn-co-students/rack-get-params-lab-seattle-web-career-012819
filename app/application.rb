class Application
  @@items = ["Apples","Carrots","Pears"]
  @@cart = []   # New "cart" class variable

  @@resp = nil  # Providing global access to Response and Request.
  @@req = nil

  def call(env)
    @@resp = Rack::Response.new
    @@req = Rack::Request.new(env)

    if @@req.path     =~ /items/
      show_all_items                      # Abstracted for readability and DRY

    elsif @@req.path  =~ /search/
      show_search_results @@req.params["q"] # Abstracted for readability and DRY

    elsif @@req.path  =~ /add/
      add_to_cart @@req.params["item"]      # New #add_to_cart method for GET param "item"

    elsif @@req.path  =~ /cart/
      show_all_in_cart                      # New #show_all_in_cart method

    else
      show_not_found                        # Abstracted for readability and DRY
    end

    @@resp.finish
  end

  def show_all_items
    @@items.each do |item|
      @@resp.write "#{item}\n"
    end
  end

  def show_search_results(search_term)
    result_string = "Couldn't find #{search_term}"

    # Conditionally assign the interpolated value of "search_term" if a match is found.
    if @@items.include?(search_term)
      result_string = "#{search_term} is one of our items"
    end

    @@resp.write result_string
  end

  def add_to_cart(requested_item)
    message_string = "We don't have that item" # Worst case
    item_in_stock = @@items.select { |i| i == requested_item }.first

    if item_in_stock
      @@cart << item_in_stock
      message_string = "added #{item_in_stock}" # Best case
    end

    @@resp.write message_string
  end

  def show_all_in_cart
    if @@cart.length < 1
      @@resp.write "Your cart is empty"
    else
      @@cart.each do |item|
        @@resp.write "#{item}\n"
      end
    end
  end

  def show_not_found
    @@resp.write "Path Not Found"
  end
end
