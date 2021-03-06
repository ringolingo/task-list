require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
    completed_at: Time.now + 5.days
  }
  
  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path
      
      # Assert
      must_respond_with :success
    end
    
    it "can get the root path" do
      # Act
      get root_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # skip
      # Act
      get task_path(task.id)
      
      # Assert
      must_respond_with :success
    end
    
    it "will redirect for an invalid task" do
      # skip
      # Act
      get task_path(-1)
      
      # Assert
      must_respond_with :redirect
    end
  end
  
  describe "new" do
    it "can get the new task page" do
      # skip
      
      # Act
      get new_task_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new task" do
      # skip
      
      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completed_at: nil,
        },
      }
      
      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1
      
      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed_at).must_equal task_hash[:task][:completed_at]
      
      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end
  
  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      # skip
      get edit_task_path(task.id)

      must_respond_with :success
    end
    
    it "will respond with redirect when attempting to edit a nonexistant task" do
      # skip

      get edit_task_path(-1)

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end
  
  # Uncomment and complete these tests for Wave 3
  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.

    before do
      Task.create(name: "wave 3", description: "describe 'update' do tests")
    end
    let (:new_task_hash) {
      {
          task: {
              name: "wave 4",
              description: "describe 'destroy' do tests"
          }
      }
    }

    it "can update an existing task" do
      task = Task.first
      expect {
        patch task_path(task.id), params: new_task_hash
      }.wont_change "Task.count"

      must_redirect_to task_path(task.id)

      task = Task.find_by(id: task.id)
      expect(task.name).must_equal new_task_hash[:task][:name]
      expect(task.description).must_equal new_task_hash[:task][:description]
    end
    
    it "will redirect to the root page if given an invalid id" do
      expect {
        patch task_path(-1), params: new_task_hash
      }.wont_change "Task.count"

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end
  
  # Complete these tests for Wave 4
  describe "destroy" do
    it "will destroy a task" do
      trash = Task.create(name: "throw this away", description: "delete this task")

      expect {
        delete task_path(trash.id)
      }.must_change "Task.count", -1

      trash = Task.find_by(name: "throw this away")

      expect trash.must_be_nil

      must_respond_with :redirect
      must_redirect_to tasks_path
    end

    it "will respond not_found for invalid tasks" do
      expect {
        delete task_path(-1)
      }.wont_change "Task.count"

      must_respond_with :not_found
    end
    
  end
  
  # Complete for Wave 4
  describe "toggle_complete" do
    it "will mark an incomplete task as complete" do
      done = Task.create(name: "food", description: "eat it")
      expect {
        patch toggle_task_path(done.id)
      }.wont_change "Task.count"

      must_redirect_to task_path(done.id)

      done = Task.find_by(name: "food")
      expect(task.completed_at).wont_be_nil
    end

    it "will mark a complete task as incomplete" do
      not_done = Task.create(name: "floors", description: "wash 'em'", completed_at: Time.now)
      id = not_done.id

      expect {
        patch toggle_task_path(id)
      }.wont_change "Task.count"

      must_redirect_to task_path(id)

      not_done = Task.find_by(id: id)
      expect(not_done.completed_at).must_be_nil
    end

    it "will redirect to to index if given invalid task" do
      expect {
        patch toggle_task_path(-1)
      }.wont_change "Task.count"

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end
end
