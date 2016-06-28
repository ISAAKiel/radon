class CommentsController < ApplicationController
#  include SimpleCaptcha::ControllerHelpers
  
  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy 

  def index
    @comments = Comment.all
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def new
    @comment = Comment.new
  end
  
  def create
    @comment = Comment.new(params[:comment])
    if verify_recaptcha(:model => @comment, :message => "Oh! It's error with reCAPTCHA!")
	
			 if @comment.comment && !@comment.comment.strip.empty? && @comment.save
				flash[:notice] = "Successfully created comment."
				redirect_to :back
			 else
				redirect_to :back
			 end
		else
				flash[:error] = "Your entered validation code was wrong!"
				redirect_to :back
		end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @comment
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to :back
  end
end
