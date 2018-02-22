class Dojos::StudentsController < ApplicationController
 before_action :set_student, only: [:edit, :show, :update, :destroy]
 before_action :set_dojo, only: [:edit, :destroy, :update, :new, :show]
 
 require 'date'

  def new
    @student=Student.new
    @dojos=Dojo.all
  end

  def create
    puts "In create method. Selected dojo is: ", student_params
    @student=Student.new(student_params)
    puts "Assigned id to new student object: ", @student.dojo_id
    if @student.save
      redirect_to '/', notice: "Successfully added/created a student for a Dojo Branch!"  # another one is 'alert:' or 'flash: flash: { referral_code: 1234 }'
    else
      @dojos=Dojo.all
      @dojo=Dojo.find(@student.dojo_id)
      render :new
    end
  end

  def show
    puts @dojo.branch 
    #@students=Dojo.joins(:students).select("students.first_name", "students.last_name", "students.email", "students.created_at").where("students.id != ? AND students.dojo_id = ?", @student.id, @student.dojo_id)
    #@students = Students.joins(:dojo)

    #@students=cohort(@student) # WORKS!!!
    @students=Student.cohort(@student)

    puts @student.created_at.to_date  # WORKS! (HERE AND IN VIEW) =>2018-01-05
    puts @student.created_at.strftime("%Y-%m-%d") # WORKS! HERE AND IN VIEW =>2018-01-05

    date = @student.created_at.strftime("%Y-%m-%d")
    puts date # => 2018-01-05
    puts Time.zone # => (GMT+00:00) UTC
    day= Date.today - 1.day # =>2018-01-06
    puts day
    # CURRENTS:
    puts Time.current #=> 2018-01-07 02:28:40 UTC
    puts Time.current.to_date # => 2018-01-07
    puts Date.current # => 2018-01-07

    # "dojos.id = #{@dojo.id} AND students.created_at = @student.created_at.strftime("%Y-%m-%d")")
  end

  def cohort(student)
    Student.where("id != ? AND dojo_id = ? AND Date(created_at) = ?", student.id, student.dojo_id, student.created_at.strftime("%Y-%m-%d"))
  end

  def edit
    # fail
  end

  def update
  end

  def destroy
    if @student.delete
      puts "Deleted student successfully."
      redirect_to dojo_path(@dojo)
    else
      puts "Not able to delete.."
      render controller: 'dojos', action: :show, id: @dojo.id
    end
    # fail
  end


  private
  def set_student
    @student = Student.find(params[:id])
  end

  def set_dojo
    @dojo = Dojo.find(params[:dojo_id])
  end
  
  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :dojo_id)
  end
end 