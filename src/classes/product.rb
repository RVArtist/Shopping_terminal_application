require 'json'
require 'tty-prompt'
require 'tty-table'

class Product
    attr_accessor :products, :tty_prompt, :selected_products

    def initialize()
        @products = {}
        @tty_prompt = TTY::Prompt.new
        @selected_products = []

        # Make hash for all products
        json = File.read('./data/products.json')
        @products = JSON.parse(json)
    end

    def display_products
        table = TTY::Table.new(header: ["Product", "Unit price", "Stock available"])
        @products.each do |key, value|
            table << value
        end
        puts table.render(:ascii)
    end

    def select_products
        @selected_products = @tty_prompt.multi_select("Select products?", @products.keys)
        @selected_products
    end

    def change_price
        #loop through products and find product to change the price
        @selected_products.each do |selected_product|
            edit_product = @products.fetch(selected_product)
            pp edit_product.class
            puts "Please enter the new price for #{selected_product}"
            new_price = gets.chomp.to_f
            edit_product[1] = new_price.to_s
            puts "New price of #{new_price} added for #{selected_product}"
            #Update JSON file
            File.open("./data/products.json", "w") do |f|
              f.write(JSON.pretty_generate(products))
            end
        end
    end
end