require_relative 'product.rb'

class Cart
    attr_accessor :its_product, :product_quantity, :cart_line, :cart_array

    def initialize(its_product)
        self.its_product = its_product
        @cart_array = []

    end

    def add_to_cart(product_quantity)
        line_total = 0
        product_quantity.each do |product_price|
            match_found = false
            #append to same array in case same product is selected again
            if @cart_array.empty?
                product_details = its_product.products.fetch(product_price[0])
                #make cart line
                # product quantity price
                line_total = product_price[1].to_i * product_details[1].to_f
                @cart_sub_array = []
                @cart_sub_array.push(product_price[0])
                @cart_sub_array.push(product_price[1])
                @cart_sub_array.push(product_details[1])
                @cart_sub_array.push(line_total)

                @cart_array.push(@cart_sub_array)
            else
                @cart_array.each do |x|
                    if product_price[0] == x[0]
                        x[1] += product_price[1]
                        x[3] = x[1] * x[2].to_i
                        match_found = true
                    end
                end
                if !match_found
                    product_details = its_product.products.fetch(product_price[0])
                    #make cart line
                    # product quantity price
                    line_total = product_price[1].to_i * product_details[1].to_f
                    @cart_sub_array = []
                    @cart_sub_array.push(product_price[0])
                    @cart_sub_array.push(product_price[1])
                    @cart_sub_array.push(product_details[1])
                    @cart_sub_array.push(line_total)
        
                    @cart_array.push(@cart_sub_array)
                end
            end
        end
    end

    def calculate_subtotal
        subtotal = 0
        @cart_array.each do |cart_sub_array|
            #pp cart_sub_array[3]
            subtotal += cart_sub_array[3]
        end
        subtotal
    end

    def view_cart
        table = TTY::Table.new(header: ["Product", "Quantity", "Unit price", "Total"])
        @cart_array.each do |cart_sub_array|
            table << cart_sub_array
        end
        subtotal = calculate_subtotal
        #cart_sub_array =[]
        #cart_sub_array.push("Subtotal")
        #cart_sub_array.push(" ")
        #cart_sub_array.push(" ")
        #cart_sub_array.push(subtotal)
        #@cart_array.push(cart_sub_array)

        table << ["Subtotal ", " ", " ",subtotal]
        puts table.render(:ascii)
    end

    def delete_from_cart(selected_products, product_quantity, delete_line)
        if delete_line
            #iterate through cart array and delete row for each selected\
            @cart_array.each do |cart_sub_array|
                selected_products.each do |selected_product|
                    if cart_sub_array[0] == selected_product
                        @cart_array.delete(cart_sub_array)
                    end
                end
            end
        else
            #iterate and change the quantity
            #raise error for negative quantity
            #delete line for 0 quantity
            product_quantity.each do |key, value|
                @cart_array.each do |cart_sub_array|
                    #pp cart_sub_array[0]
                    if key == cart_sub_array[0]
                        #match found
                        if  value == cart_sub_array[1]
                            #same quantity from cart to delete, so delete the cart line
                            @cart_array.delete(cart_sub_array)
                        elsif value > cart_sub_array[1]
                            #more quantity to delete selected than in the cart
                            puts " That much is #{value} not avialable in the cart to delete!"
                            puts " Proceeding adjusting other items"
                            puts " Please view cart for details"
                        else
                            cart_sub_array[1] -= value
                            cart_sub_array[3] = cart_sub_array[1] * cart_sub_array[2].to_i
                        end
                    end
                end
            end
        end
    end
end