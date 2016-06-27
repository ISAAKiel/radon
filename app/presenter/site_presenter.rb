class SitePresenter < BasePresenter
  presents :site
#  delegate :country_subdivison, to: :site

  def title
    standard_title
  end

  def parish
    handle_none site.parish do
      site.parish
    end  
  end
  
  def district
    handle_none site.district do
      site.district
    end  
  end

  def country_subdivision_name
    handle_none site.country_subdivision.name do
      site.country_subdivision.name
    end
  end

  def country_name
    handle_none site.country_subdivision.country.name do
      site.country_subdivision.country.name
    end
  end

  def location
    lat= handle_none site.lat do site.lat.to_s + '&deg;' end
    lng= handle_none site.lng do site.lng.to_s + '&deg;' end
    
    content_tag :span, (lat.to_s + '/' + lng.to_s).html_safe
  end

  def map
    if site.present? && site.lat.present? && site.lng.present?
      loc=site
      out = content_tag(:div, nil, :id => "map", style: "width: 100%; height: 256px")
      out << (render partial: 'layouts/basic_map', locals: {loc: loc}, formats: [:js])
      out
    else
      out = "No location available."
    end
  end

end
