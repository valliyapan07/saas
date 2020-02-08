require "date"

class Todo
  attr_accessor :text, :date, :completed

  def initialize(text, date, completed)
    @text = text
    @date = date
    @completed = completed
  end

  def overdue?
    if @date < Date.today
      Todo.new(@text, @date, @completed)
    end
  end

  def due_later?
    if @date > Date.today
      Todo.new(@text, @date, @completed)
    end
  end

  def due_today?
    if @date == Date.today
      Todo.new(@text, @date, @completed)
    end
  end

  def to_displayable_string
    "#{@text} #{@date} #{@completed}"
  end
end

class TodosList
  def initialize(todos)
    @todos = todos
  end

  def overdue
    TodosList.new(@todos.filter { |todo| todo.overdue? })
  end

  def due_today
    TodosList.new(@todos.filter { |todo| todo.due_today? })
  end

  def due_later
    TodosList.new(@todos.filter { |todo| todo.due_later? })
  end

  def add(todo)
    @todos.push(todo)
  end

  def to_displayable_list
    list = []
    @todos.each { |todo|
      if todo.completed == false
        list.push ("[] ".concat(todo.text).concat(" "))
      else
        list.push ("[x] ".concat(todo.text).concat(" "))
      end
      if todo.date != Date.today
        list.last.concat(todo.date.to_s)
      end
    }
    list.join("\n")
  end
end

date = Date.today
todos = [
  { text: "Submit assignment", due_date: date - 1, completed: false },
  { text: "Pay rent", due_date: date, completed: true },
  { text: "File taxes", due_date: date + 1, completed: false },
  { text: "Call Acme Corp.", due_date: date + 1, completed: false },
]

todos = todos.map { |todo|
  Todo.new(todo[:text], todo[:due_date], todo[:completed])
}

todos_list = TodosList.new(todos)

todos_list.add(Todo.new("Service vehicle", date, false))

puts "My Todo-list\n\n"

puts "Overdue\n"
puts todos_list.overdue.to_displayable_list
puts "\n\n"

puts "Due Today\n"
puts todos_list.due_today.to_displayable_list
puts "\n\n"

puts "Due Later\n"
puts todos_list.due_later.to_displayable_list
puts "\n\n"
