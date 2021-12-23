require_relative 'cart.rb'

class Checkout
    attr_accessor :its_cart

    def initialize(its_cart)
        self.its_cart = its_cart
        #self.its_receipt = its_receipt
    end

    def detect_card_type(card_no)
        check_status = true
        length = card_no.size

        if length == 16 && card_no =~ /^5[1-5]/
            puts "MasterCard"
            puts card_no
        elsif (length == 13 || length == 16) && card_no =~ /^4/
            puts "Visa"
            puts card_no
        else
            puts "Card type unknown, try doing payment again"
            check_status = false
        end
        check_status
    end

    def process_payment
        # Ask the customer for pay by cash or credit card option
        # if pay by cash, enter the amount you would like to pay--recipt or bye
        #If pay by card enter no, date, cvv, amount
        #c if amount is not right , enter amount again
        #else processing payment ... and ask for recieipt and bye
        artii = Artii::Base.new
        tty_prompt = TTY::Prompt.new
        choices = {"Cash": 1, "Card": 2}

        user_selection = tty_prompt.select("Are you paying by cash or card?", choices)
        if user_selection == 1
            pp its_cart.cart_array
            cart_sub_array = its_cart.cart_array.pop
            #pp cart_sub_array
            if cart_sub_array.empty?
                puts "No item to checkout, please buy some items"
            else
                puts "Please enter $ #{cart_sub_array[3]} to make the payment"
                amount = gets.chomp.to_f
                if amount > cart_sub_array[3].to_f
                    balance = amount - cart_sub_array[3].to_f
                    puts ("Here is your balance - $#{balance}")
                end
                receipt_option = tty_prompt.yes?("Thank you for the payment, do you want a receipt?")
                if receipt_option
                    #Generate receipt
                else
                    puts artii.asciify('Thank you for shopping,see you again').colorize(:light_blue)
                    exit
                end
            end
        else
            #process card information
            begin
                puts "Please enter card no"
                card_no = gets.chomp
                check_status = detect_card_type(card_no)
                if !check_status
                    raise "Wrong card type detected, please try again"
                end
                puts "Please enter the expiry date in mm/yy format"
                expiry_date = gets.chomp
                status = expiry_date.match?(/^\d{2}\/\d{2}$/)
                #pp expiry_date.class
                if !status
                    raise "Wrong mm/yy format entered, please try again"
                else
                    #month_year = expiry_date.split("/")
                    #month_year.map {|a| a.to_i}

                    #pp Time.now.month.class
                    #if Time.now.month < month_year[0]
                        #puts "Invalid month"
                    #end
                    #if month_year[0] <= Time.now.month and month_year[1] <= Time.now.year
                        #raise "Card expired, please try with another card"
                    #end
                end
                #get the cvv
                puts "Please enter 3 digit cvv number"
                cvv =gets.chomp
                cvv_valid = cvv.match?(/[0-9]{3}/)
                if !cvv_valid
                    raise "wrong cvv entered, plese retry"
                else
                    puts "Thank you for your payment and shopping, see you next time"
                end
            rescue  StandardError => e
                puts e.message
                retry
            end
        end
    end
end