class ApplicantsController < ApplicationController
    
    # NOTE: Sometimes applicant and application are used interchangeably
    def index

        # Will render a page thanking you for submitting your application
        #render plain: params[:article].inspect
    end
    
    
    def new 
        # Will render the form to apply
        # Basically start off with all in the neutral zone
        @coursesPref= []
        @coursesIndif= Course.all
        @coursesAntiPref = []
        
    end
    
    
    # If user already has an application, allow them to view it.
    def edit
        # create will route here with that value
        # then we open up the view edit.html.erb with 
        # their fields and when they submit
        # it will redirect to update and we can save it there


        
        @object = Applicant.find(params[:id])

        @courses= Course.all
        # Need them to be in three different categories. What we need to to is actully
        # link them like make the actual belongs to relationship.
        # For now, this works.
        @coursesPref= Course.where({ name: @object.preferences})
        @coursesIndif= Course.where({ name: @object.indifferent})
        @coursesAntiPref = Course.where({ name: @object.antipref})
        
    end
    
    
    
    
    def create
        @email = User.find_by(login_token: session[:user_token]).email
        # Here, we cam check if they already have an applicatin
        
        @application = Applicant.find_by(email: @email)
        
            
        @name = User.find_by(login_token: session[:user_token]).fullname

        #basically here need to check if they have one already or not.
        # if so, just route them to the edit

        data = JSON.parse(params["application"]["payload"])
        @applicant = Applicant.new
        
        @applicant.name = @name
        @applicant.email = @email
        @applicant.advisor =  data["advisor"]
        @applicant.years = data["years"].to_i
        @applicant.degree_program = data["degree_program"]
        @applicant.isGrader = data["isGrader"]
        @applicant.isSG = data["isSG"]
        @applicant.isTA = data["isTA"]
        @applicant.preferences = data["preferences"]
        @applicant.antipref = data["antipref"]
        @applicant.indifferent = data["indifferent"]
        
        @applicant.save!
        
        redirect_to applicants_path
        
    end
    
    
    
    def update
        @email = User.find_by(login_token: session[:user_token]).email
        
        # get all the applications this user has, should only be one
        @application = Applicant.find(params[:id])
        
 
        # ok lets start here this is the data that ima get from the file
        data = JSON.parse(params["application"]["payload"])
        if @application.update(data)
            redirect_to applicants_path
        else
            render 'edit'
        end
    end
    

    def submitted
        # Shows Them Their Submitted Application if they have one
        # And Allows them to delete it
        @email = User.find_by(login_token: session[:user_token]).email
        
        
    
        # get all the applications this user has, should only be one
        @application = Applicant.where(:email => @email)
  
    end
    
    def destroy
        
        Applicant.destroy(params[:id])
       
    end
    
    
    
    
    
end
