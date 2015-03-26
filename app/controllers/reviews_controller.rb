class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :correct_user!, only: [:edit, :update, :destroy]

  def create
    @book = Book.find params[:book_id]
    @review = Review.new review_params
    @review.user = current_user
    @review.book = @book
    if @review.save
      Activity.create(user: current_user, 
                      target_id: @review.id, 
                      action_type: "review")
      respond_to do |format|
        format.html {redirect_to @book}
        format.js
      end
    end
  end

  def destroy
    @review = Review.find params[:id]
    @review.destroy
    respond_to do |format|
      format.js
    end
  end

  def show
    @review = Review.find params[:id]
    @comments = @review.comments.paginate page: params[:page], per_page: 8
    @comment = @review.comments.build if user_signed_in?
  end

  def edit
    @book = Book.find params[:book_id]
    @review = Review.find params[:id]
  end

  def update
    @book = Book.find params[:book_id]
    @review = Review.find params[:id]
    if @review.update_attributes review_params
      flash[:success] = "Review updated!"
      redirect_to [@book, @review]
    end
  end

  private
    def review_params
      params.require(:review).permit :content, :rating
    end

    def correct_user!
      @review = current_user.reviews.find_by id: params[:id]
      redirect_to root_url if @review.nil?
    end
end
