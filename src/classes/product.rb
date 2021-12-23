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
end