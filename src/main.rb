# Added Gems
require 'colorize'
require 'artii'
require 'tty-prompt'
require_relative './classes/product.rb'
require_relative './classes/cart.rb'

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
choices = {"customer": 1, "owner": 2}
user_selection = tty_prompt.select("Are you a customer or shop owner", choices)

if user_selection == 1
    is_customer = true
end

#Owner menu
choices = {"Display products": 1, "Change the price of a product": 2, "Add a product": 3, "Delete a product": 4, "Exit": 5}
user_selection = tty_prompt.select("Are you a customer or shop owner", choices)
#Customer menu
#Product instance
products = Product.new
#If customer is selected - display the menu for customer
if is_customer
    menu_customer = tty_prompt.select("Do you want to see the produts?") do |menu|
        menu.choice "Yes", 1
        menu.choice "No", 2
    end

    if menu_customer == 1
        puts artii.asciify("Displaying products ......").colorize(:blue)
        #Call the display products from product class
        products.display_products
        #Ask user whether to buy products
        user_selection = tty_prompt.yes?("Do you want to buy products?")
        if user_selection == true
            selected_products = products.select_products
            #Ask user about the quantity
            cart_item = Hash.new

            selected_products.each do |product|
                puts ("How much #{product} quantity do you need?")
                quantity = gets.chomp.to_i
                cart_item[product] = quantity
            end

            #Create Cart
            cart = Cart.new(products, cart_item)
            cart.add_to_cart

            #Ask customer whether to view cart or proceed for payment
            cart.view_cart
        end

    else
        puts artii.asciify('Exiting, Bye....').colorize(:light_blue)
        exit
    end
else
    user_selection = tty_prompt.select("Hi, What would you like to do?", choices)
        if user_selection == 5
            exit
        end
end
