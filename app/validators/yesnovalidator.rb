class Yesnovalidator < ActiveModel::Validator
  def validate(record)
    if record.title.upcase.include? "YES" and record.description.upcase.include? "NO"
      record.errors[:title] << 'Title has the word yes and the description has the word no'
    end
  end
end
