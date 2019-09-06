require 'byebug'
class ApplicationController < Sinatra::Base
  set :public_folder, File.expand_path('../../assets', __FILE__)

  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)

  set :method_override, true

  enable :sessions

  get '/' do
    @question = Question.all
    erb :intro  
  end

  get '/intro' do 
    @question = Question.all
    erb :index
  end
  
  get '/question' do
  	@question = Question.new
  	erb :question
  end
  
  post '/question' do
  	@question = Question.new(params[:question])
  	if @question.save
  		redirect to('/index')
  	else
  		erb :question
  	end
  	
    end
  
   get '/q/edit/:id' do
   	@qs = Question.find(params[:id])
   	erb :edit
   end

   patch '/q/:id' do
   	@qs = Question.find(params[:id])
   	@qs.update(params[:question])
   	redirect to('/index')
   end

   get '/delete' do
  	@qs = Question.find(params[:id])
  	@qd = @qs.destroy
  	redirect to('/index')
  end

   get '/display/:id' do 
   	@q = Question.find(params[:id])
   	erb :display
   end

  post '/display/' do 
    @answer = Answer.new(params[:answer])
    if @answer.save
      redirect to("/display/#{@answer.question.id}")
    else
      redirect to('/') 
    end
  end

  get '/login' do 
    erb :login 
  end

  post '/login' do 
    @user = User.find_by_email(params[:user][:email])

    
    if  @user && @user.authenticate(params[:user][:password])
        # session[:user_id] = user.id
        redirect to('/index')
    else
        redirect to('/login')
    end
  end

  get '/index' do 
    @question = Question.all
    erb :index 
  end

  post '/index' do 
    erb :index
  end

  get '/register' do 
    erb :register
  end

  post '/register' do 
    # session[:user] = User.authenticate([:email],[:password  ])

    @user = User.new(email: params[:user][:email])
    @user.password = params[:user][:password]
    
    if @user.save 
      puts "registration is successful"
      redirect to('/register') #add text "your registration is successful
    else
      erb :register 
    end
  end

  get '/logout' do
    erb :intro
  end

  post '/logout' do 
    session.clear
    redirect to('/intro')
  end
end
