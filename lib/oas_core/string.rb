# frozen_string_literal: true

class String
  def squish
    dup.squish!
  end

  def squish!
    gsub!(/[[:space:]]+/, ' ')
    strip!
    self
  end
end
