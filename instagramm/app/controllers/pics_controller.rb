class PicsController < ApplicationController
  before_action :find_pic, only: [:show, :edit, :update, :destroy, :upvote, :downvote, :user_auth]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :user_auth, :only => [:edit, :update, :destroy]

  def index
    @pics = Pic.all.order('created_at DESC')
  end

  def show
  end

  def new
    @pic = current_user.pics.build
  end

  def create
    @pic = current_user.pics.build(pic_params)

    if @pic.save
      redirect_to @pic, notice: 'Yess! It was posted!'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @pic.update(pic_params)
      redirect_to @pic, notice: 'Congrats! Pic was updated!'
    else
      render 'edit'
    end
  end

  def destroy
    @pic.destroy
    redirect_to root_path
  end

  def upvote
    @pic.upvote_by current_user
    redirect_back(fallback_location: @pic)
  end

  def downvote
    @pic.downvote_by current_user
    redirect_back(fallback_location: @pic)    
  end

  private

    def pic_params
      params.require(:pic).permit(:title, :description, :featured_image)
    end

    def find_pic
      @pic = Pic.find(params[:id])
    end

    def user_auth
      unless current_user.id == @pic.user_id
        flash[:notice] = "You don't have access to this page"
        redirect_to root_path
        return false
      end
    end    

end
