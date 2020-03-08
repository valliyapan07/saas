require "./todo.rb"
require "./connect_db.rb"

connect_db!
Todo.show_list
