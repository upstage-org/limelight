module AvatarsHelper
  def medium_select_options
    Medium.images_only.all.map { |m| [ m.name, m.id ] }
  end
end
