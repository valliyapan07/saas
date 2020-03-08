require "./connect_db.rb"
require "date"
connect_db!

class Todo < ActiveRecord::Base
  def self.over_due!
    Todo.all.where("due_date < ?", Date.today).map { |t| t.to_displayable_string }
  end

  def self.due_today!
    Todo.all.where("due_date = ?", Date.today).map { |t| t.to_displayable_string }
  end

  def self.due_later!
    Todo.all.where("due_date > ?", Date.today).map { |t| t.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list"
    puts "\n\nOverdue"
    over_due = Todo.over_due!
    puts over_due
    puts "\n\nDue Today"
    due_today = Todo.due_today!
    puts due_today
    puts "\n\nDue Later"
    due_later = Todo.due_later!
    puts due_later
  end

  def due_today?
    due_date == Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    " #{id} #{display_status} #{todo_text} #{display_date}"
  end

  def self.add_task(h)
    Todo.create!(todo_text: h[:todo_text], due_date: (Date.today + h[:due_in_days]), completed: false)
  end
  def self.mark_as_complete!(todo_id)
    todo = Todo.find(todo_id)
    todo.completed = true
    todo.save
    todo
  end
end
