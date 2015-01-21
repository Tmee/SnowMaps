class Trail < ActiveRecord::Base
  belongs_to :peak
  belongs_to :mountain

  validates :peak_id, :presence => true


  def beginner?
    array = ['easiest', 'beginner', 'beg'].map {|x| x == difficulty}
    array.include? true
  end

  def intermediate?
    array = ['int', 'intermediate', 'moreDifficult'].map {|x| x == difficulty}
    array.include? true
  end

  def advanced?
    array = ['adv', 'advanced', 'mostDifficult'].map {|x| x == difficulty}
    array.include? true
  end

  def expert?
    array = ['expert', 'exp', 'doubleDiamond'].map {|x| x == difficulty}
    array.include? true
  end
end
