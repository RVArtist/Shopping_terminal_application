# Added Gems
require 'colorize'
require 'artii'
require 'tty-prompt'
require_relative './classes/product.rb'
require_relative './classes/cart.rb'
require_relative './classes/checkout'

# Diaplay a welcome message
artii = Artii::Base.new
tty_prompt = TTY::Prompt.new

puts artii.asciify('Welcome').colorize(:light_blue)

if ARGV.length > 0
    flag, *rest = ARGV
    ARGV.clear
    #flag.downcase
    case flag
    when '-help'
        tty_promt.ask("Please check readme file")
        exit
        #puts "Please check readme file"
    when '-info'
        puts "Written by Roby"
        exit
    else 
        puts "Invalid input"
        exit
    end
end

# Ask user whether customer or owner
is_customer = false

#hash map for customer selection
choices = {"customer": 1, "owner": 2, "exit": 3}
while true do
    begin
    user_selection = tty_prompt.select("Are you a customer or shop owner", choices)
    if user_selection == 1
        is_customer = true
    elsif user_selection == 2
        is_customer = false
    elsif user_selection == 3
        puts artii.asciify('Exiting, Bye....').colorize(:light_blue)
        exit
    else
        raise "Wrong input, please try again"
    end

    rescue StandardError => e
        puts e.message
        retry
    end

    #Product instance
    products = Product.new

    cart = Cart.new(products)
    checkout = Checkout.new(cart)

    #If customer is selected - display the menu for customer
    if is_customer
        #Customer menu
        choices_customer = {"Display products": 1, "Add product/products to cart": 2, "View cart": 3,
                            "Delete product/products from cart": 4, "Proceed to checkout": 5, "Exit": 6}

        while true do
            user_selection = tty_prompt.select("Please select one of the options to proceed", choices_customer)

            case user_selection
            when 1
                puts artii.asciify("Displaying products ......").colorize(:blue)
                #Call the display products from product class
                products.display_products
            when 2
                cart_item = Hash.new
                selected_products = products.select_products
                #Ask user about the quantity
                selected_products.each do |product|
                    puts ("How much #{product} quantity do you need?")
                    quantity = gets.chomp.to_i
                    cart_item[product] = quantity
                end
                #Create Cart
                pp "Calling add to cart"
                cart.add_to_cart(cart_item)
            when 3
                cart.view_cart
            when 4
                #if cart is not empty 
                if !cart.cart_array.empty?
                    cart_item_to_modify = Hash.new
                    selected_products = products.select_products           
                    #Ask user about the quantity
                    delete_option = tty_prompt.yes?("Do you want to remove all of the product line?")

                    if !delete_option
                        selected_products.each do |product|
                            puts ("How much #{product} item do you want to delete?")
                            quantity = gets.chomp.to_i
                            cart_item_to_modify[product] = quantity
                        end
                        cart.delete_from_cart(selected_products, cart_item_to_modify, false)
                    else
                        cart.delete_from_cart(selected_products, cart_item_to_modify, true)
                    end
                else
                    puts ("Nothing in cart to delete!")
                end
            when 5
                #proceed to check out
                if cart.cart_array.empty?
                    puts "Your cart is empty"
                else
                    checkout.process_payment()
                    #clear the cart
                    cart.cart_array.clear
                end
            when 6
                puts artii.asciify('Exiting, Bye....').colorize(:light_blue)
                exit
            else
                puts "Wrong choice entered, please try again, enter 7 if you want to exit"
            end
        end
        #for shop owner
    else
        #Owner menu
        choices_owner = {"Display products": 1, "Change the price of a product": 2, "Add a new product": 3,
                        "Delete an existing product": 4, "Exit": 5}
        user_selection = tty_prompt.select("Please select one of the options to proceed", choices_owner)
        #user_selection = tty_prompt.select("Hi, What would you like to do?", choices)
        if user_selection == 5
            exit
        else
            puts ("Shop ownwer functionalities are not implemented, please select customer options or exit")
        end
    end
end
