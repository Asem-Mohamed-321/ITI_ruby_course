def list_books
  if !File.exist?("books_file.txt") || File.read("books_file.txt").strip.empty?
    puts "No books in inventory."
  else
    inventory = eval(File.read("books_file.txt"))
      if inventory.empty?
        puts "No books in inventory."
      else

        for book in inventory
          puts "---> Title : #{book[:title]} by #{book[:author]} (ISBN: #{book[:isbn]})"
        end
      end
    
  end
end

def add_book
  puts "Enter title: "
  title = gets.chomp
  puts "Enter author: "
  author = gets.chomp
  puts "Enter ISBN: "
  isbn = gets.chomp

  if !File.exist?("books_file.txt") || File.read("books_file.txt").strip.empty?
    inventory = []
  else
    inventory = eval(File.read("books_file.txt"))
  end
  
  inventory.push({ title: title, author: author, isbn: isbn })
  File.write("books_file.txt", inventory.inspect)
end

def remove_book(isbn)
  if !File.exist?("books_file.txt") || File.read("books_file.txt").strip.empty? 
    puts "No books to remove."
  else
    inventory = eval(File.read("books_file.txt")) || []
      if inventory.empty?
        puts "No books in inventory."
      else
        target_book = inventory.find {|book| book[:isbn]==isbn.to_s }
        if target_book
          inventory.delete(target_book)
          File.write("books_file.txt", inventory.inspect)
        else
        puts "Book with ISBN #{isbn} not found."
        end
    end
  end
end

######################################
list_books
# add_book
# remove_book(2)
# list_books

