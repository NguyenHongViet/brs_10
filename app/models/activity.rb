class Activity < ActiveRecord::Base
  belongs_to :user
  has_many :likes 
  
  validates :target_id, presence: true
  validates :action_type, presence: true

  def message
    message = "#{self.user.name}"
    case self.action_type
    when "review"
      review = Review.find self.target_id
      return message + " write a review on #{review.book.title}"
    when "comment"
      comment = Comment.find self.target_id
      return message + " commented on a post: #{comment.content}"
    when "follow"
      followed_user = User.find self.target_id
      return message + " is following #{followed_user.name}"
    when "unfollow"
      unfollow_user = User.find self.target_id
      return message + " unfollowed #{unfollow_user.name}"
    when "read", "reading", "unread"
      book = Book.find self.target_id
      return message + " marked #{book.title} as #{self.action_type}"
    when "favorite"
      book = Book.find self.target_id
      return message + " add #{book.title} to favorite list"
    when "unfavorite"
      book = Book.find self.target_id
      return message + " remove #{book.title} from favorite list"
    when "request"
      request = Request.find self.target_id
      return message + " sent a new request: #{request.book_name}"
    when "request_accept", "request_decline"
      request = Request.find self.target_id
      return "Manager #{request.state} request book #{request.book_name} 
                of #{self.user.name}"
    end
  end

  scope :user_activity, -> user {where(user_id: user.following_ids + [user.id])}
end
