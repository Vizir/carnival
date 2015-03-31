module Features
  module IndexHelpers
    def page_should_have_todos(todos)
      todos.each do |todo|
        expect(page).to have_selector('td', text: todo.title, exact: true)
      end
    end

    def page_should_not_have_todos(todos)
      todos.each do |todo|
        expect(page).to have_no_selector('td', text: todo.title, exact: true)
      end
    end
  end
end
