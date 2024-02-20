# frozen_string_literal: true

class String
  def format_path(wd)
    gsub(/\/{2,}/, '/').gsub("#{wd}/", "")
  end
end