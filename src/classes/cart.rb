require_relative 'product.rb'

class Cart
    attr_accessor :its_product, :product_quantity, :cart_line, :cart_array

    def initialize(its_product, product_quantity)
        self.its_product = its_product
        self.product_quantity = product_quantity
        @cart_array = []
        #@cart_sub_array = []
    end

    def add_to_cart
        pp product_quantity
        pp its_product.products
        i = 0
        line_total = 0

        @product_quantity.each do |product_price|
            product_details = its_product.products.fetch(product_price[0])
            #make cart line
            cart_sub_array = []
            # product quantity price
            line_total = product_price[1].to_i * product_details[2].to_i

            cart_sub_array.push(product_price[0])
            cart_sub_array.push(product_price[1])
            cart_sub_array.push(product_details[2])
            cart_sub_array.push(line_total)

            @cart_array.push(cart_sub_array)
            pp @cart_array[i]
            i+=1
        end
    end

    def view_cart
        table = TTY::Table.new(header: ["Product", "Quantity", "Unit price", "Total"])

        cart_array.each do |cart_sub_array|
            table << cart_sub_array
        end
        puts table.render(:ascii)
    end
end