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

  def open?
    open_status_array = ['yesStatus', 'open'].map {|x| x == open}
    open_status_array.include? true
  end

  def closed?
    closed_status_array = ['noStatus', 'closed'].map {|x| x == open}
    closed_status_array.include? true
  end

  def park?
    array = ['terrain', 'park'].map {|x| x == difficulty}
    array.include? true
  end

end
