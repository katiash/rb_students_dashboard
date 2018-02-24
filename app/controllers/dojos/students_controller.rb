class Dojos::StudentsController < ApplicationController
# This is default behaviour for all views actually...
# layout "application", only: [:new, :index, :edit, :show] 

# ***************************************************
# If in our app/views/layouts folder, we will have the following files:

# application.html.erb
# dojos.html.erb
# students.html.erb

# Can specify non-default layout option to render views through:
# layout "dojos", only: [:show]
#****************************************************

 before_action :set_student, only: [:edit, :show, :update, :destroy]
 before_action :set_dojo, only: [:edit, :destroy, :update, :new, :show]
 
 require 'date'

###########
# METHODS:#
###########

  def new
    @student=Student.new
    @dojos=Dojo.all
  end

  def create
    puts "In create method. Selected dojo is: ", params[:dojo_id]
    puts "New student parameters are: ", student_params
    @student=Student.new(student_params)
    puts "Assigned id to updated student object? ", @student
    if @student.save
      redirect_to "/dojos/#{params[:dojo_id]}", notice: "Successfully updated a student for a Dojo Branch!"  # another one is 'alert:' or 'flash: flash: { referral_code: 1234 }'
    else
      @dojos=Dojo.all
      puts "in else statement our params are ", params.inspect
      @dojo=Dojo.find(params[:id])
      flash[:alert] = "Your updates did not pass Object Class Validations. The submitted data was: #{params[:student].inspect}."
      render :new # renders without going to controller, 
      # which is why we need to recreate all needed for template instance variables here!
      # COMMENTED OUT flash[:errors] SINCE THEY ARE ITERATED THROUGH DIRECTLY ON THE VIEW
      # flash[:errors] = @student.errors.full_messages # DON'T FORGET TO DISPLAY THESE INSTEAD OF WHAT IS ON EDIT VIEW NOW
    end
  end

  def combined_name (student)
    puts student.first_name
    puts student.last_name
    "#{student.first_name} #{student.last_name}"
  end

  def show
    @combined_name=combined_name(@student)
    puts @combined_name
    puts @dojo.branch 
    #@students=Dojo.joins(:students).select("students.first_name", "students.last_name", "students.email", "students.created_at").where("students.id != ? AND students.dojo_id = ?", @student.id, @student.dojo_id)
    #@students = Students.joins(:dojo)

    @cohorts=cohort(@student) # WORKS!!!
    puts "Got my cohorts", @cohorts
    #@cohorts=Student.cohort(@student) WORKS !! (UNCOMMENT IN MODEL FILE FOR THIS)

    ######################
    # USING MORE OF TIME #
    ######################
    puts Time.zone # => (GMT+00:00) UTC
    day= Date.today - 1.day # =>2018-01-06
    puts day
  
    # CURRENTS:
    puts Time.current #=> 2018-01-07 02:28:40 UTC
    puts Time.current.to_date # => 2018-01-07
    puts Date.current # => 2018-01-07

    #BOTH BELOW ITEMS PRODUCE SAME FORMAT:
    #=====================================
    puts @student.created_at.to_date  # WORKS! (HERE AND IN VIEW) =>2018-01-05
    date = @student.created_at.strftime("%Y-%m-%d") # WORKS! HERE AND IN VIEW =>2018-01-05
    puts date


    # "dojos.id = #{@dojo.id} AND students.created_at = @student.created_at.strftime("%Y-%m-%d")")
  end

  def cohort(student)
    Student.where("id != ? AND dojo_id = ? AND Date(created_at) = ?", student.id, student.dojo_id, student.created_at.strftime("%Y-%m-%d"))
  end

  def edit
    @combined_name=combined_name(@student)
    puts @combined_name
    puts @student
    puts @dojo
    @dojos=Dojo.all
    # fail
    # - in order to see the parameters etc, can always 'fail' the method..
  end

  def update
    puts "In student update method. Params are: ", params.inspect
    puts "In student update method. Selected student per student_params from form is: ", student_params
    @student=Student.find(params[:id])
    puts "Assigned dojo_id to the student object: ", @student.dojo_id

    if @student.update(student_params)
     # puts "Successfully updated student attributes"
      redirect_to "/dojos/#{@student.dojo_id}/students/#{@student.id}" , notice: "Successfully updated a student for a Dojo Branch!" 
       # another one is 'alert:' or 'flash: flash: { referral_code: 1234 }'
    else
      # COMMENTED OUT flash[:errors] SINCE THEY ARE ITERATED THROUGH DIRECTLY ON THE VIEW
      # flash[:errors] = @student.errors.full_messages 
      puts "Received some errors on updating with new student attributes"
      flash[:alert] = "Your updates did not pass Object Class Validations. The submitted data was: #{params[:student].inspect}."
      @combined_name=combined_name(@student)
      @dojo=Dojo.find(params[:dojo_id])
      @dojos=Dojo.all
      render :edit
    end
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
    puts "Visited the set_student method"
    @student = Student.find(params[:id])
  end

  def set_dojo
    puts "Visited the set_dojo method"
    @dojo = Dojo.find(params[:dojo_id])
  end
  
  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :dojo_id)
  end
end 