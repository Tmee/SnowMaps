module ApplicationHelper

  def check_open_status(mount)
    mount.open if mount
  end

end