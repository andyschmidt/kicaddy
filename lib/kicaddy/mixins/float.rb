class Float
  def to_mils
    self / 0.0254
  end

  # tenth of mils
  def to_tmils
    self / 0.00254
  end
end