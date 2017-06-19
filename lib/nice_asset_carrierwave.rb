require 'nice_asset_carrierwave/version'

# NiceAssetCarrierwave
module NiceAssetCarrierwave
  # Takes an asset. Can be any model you like
  # as long as it has a Carrierwave uploader mounted
  # Default uploader name is attachment, but you can specify
  # this in the options

  def nice_asset(a, thumb = nil, options = nice_asset_options)
    return unless a
    @nice_asset_options = options
    uploader = nice_asset_uploader(a)
    return unless uploader && uploader.url
    if a.respond_to?(:is_image?) && !a.is_image?
      return uploader.url.split('/').last
    end
    nice_asset_image(a, thumb, options)
  end

  private

  def nice_asset_image(a, thumb = nil, options = {})
    options.merge!(nice_asset_options)
    image_method = nice_asset_image_method(a)
    image = thumb ? image_method.send(thumb) : image_method
    image_tag image.url, options.merge(alt: a.title ||= '')
  end

  def nice_asset_image_method(a)
    uploader = nice_asset_uploader(a)
    return uploader unless nice_asset_namespace
    uploader.send(nice_asset_namespace)
  end

  def nice_asset_namespace
    nice_asset_options[:namespace]
  end

  def nice_asset_options
    @nice_asset_options ||= {
      namespace: nil,
      uploader_name: :attachment
    }
  end

  def nice_asset_uploader(a)
    @nice_asset_uploader ||= a.send(nice_asset_uploader_name)
  end

  def nice_asset_uploader_name
    nice_asset_options[:uploader_name]
  end
end
