require 'time'

module Logger
  def self.log_info(message)
    write_log("info", message)
  end
  def self.log_warning(message)
    write_log("warning", message)
  end
  def self.log_error(message)
    write_log("error", message)
  end

  def self.write_log(type, message)
    timestamp = Time.now.iso8601
    File.open("app.logs.txt", "a") do |file|
      file.puts("#{timestamp} -- #{type} -- #{message}")
    end
  end
end

class User
  attr_accessor :name, :balance
  def initialize(name, balance)
    @name = name
    @balance = balance
  end
end

class Transaction
  attr_reader :user, :value
  def initialize(user, value)
    @user = user
    @value = value
  end
end


class Bank #abstract class
    def process_transactions(transactions, &block)
        raise "Method #{__method__} is abstract,please override this method"
    end
end

class CBABank < Bank
  def initialize(users)
    @users = users
  end

  def process_transactions(transactions, &block)

    desc = transactions.map { |t| "User #{t.user.name} transaction with value #{t.value}" }.join(", ")
    Logger.log_info("Processing Transactions #{desc}...")

    transactions.each do |transaction|
      user = transaction.user
      value = transaction.value
      begin
        unless @users.include?(user)
          raise "#{user.name} not exist in the bank!!"
        end
        if user.balance + value < 0
          raise "Not enough balance"
        end
        user.balance += value

        Logger.log_info("User #{user.name} transaction with value #{value} succeeded")

        if user.balance == 0
          Logger.log_warning("#{user.name} has 0 balance")
        end

        block.call(:success, transaction) if block_given?

        puts "Call endpoint for success of User #{user.name} transaction with value #{value}"

      rescue => e
        Logger.log_error("User #{user.name} transaction with value #{value} failed with message #{e.message}")

        block.call(:failure, transaction, e.message) if block_given?

        puts "Call endpoint for failure of User #{user.name} transaction with value #{value} with reason #{e.message}"
      end
    end
  end
end

# ===== Main =====

users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

out_side_bank_users = [
  User.new("Menna", 400)
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]

bank = CBABank.new(users)

bank.process_transactions(transactions) 
