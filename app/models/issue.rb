class Issue < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title, message: 'Title should be unique, sir.'

  validates_length_of :description, minimum: 10, maximum: 20
  validates_numericality_of :no_followers, allow_blank: true

  validates_with Yesnovalidator
  belongs_to :project

  after_create :add_to_timeline

  before_save :strip_spaces_from_tags

  private
  def add_to_timeline
    Timeline.create!({content: 'An issue was created!', timelineable_id: id,
                      timelineable_type: self.class.to_s})
  end

  def strip_spaces_from_tags
    self.tags.gsub! ', ', ','
  end
end


