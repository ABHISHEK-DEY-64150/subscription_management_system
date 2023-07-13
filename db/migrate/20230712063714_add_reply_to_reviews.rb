class AddReplyToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :reply, :text
  end
end
