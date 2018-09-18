module image

def get_dimensions
  if @image.present?
    image = @image.source

    if image.present?
      geometry = Paperclip::Geometry.from_file(image)
      return [geometry.width.to_i, geometry.height.to_i]
    end
  end
end
