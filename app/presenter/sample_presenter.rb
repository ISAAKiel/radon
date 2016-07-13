class SamplePresenter < BasePresenter
  presents :sample
#  delegate :country_subdivison, to: :site

  def title
    standard_title
  end

  def lab_name
    handle_none sample.lab.name do
      sample.lab.name
    end  
  end

  def bp
    handle_none sample.bp do
      sample.bp
    end  
  end

  def std
    handle_none sample.std do
      sample.std
    end
  end

  def delta_13_c
    handle_none sample.delta_13_c do
      sample.delta_13_c
    end  
  end

  def delta_13_c_std
    handle_none sample.delta_13_c_std do
      sample.delta_13_c_std
    end  
  end

  def prmat_name
    handle_none sample.prmat.name do
      sample.prmat.name
    end  
  end

  def prmat_comment
    handle_none sample.prmat_comment do
      sample.prmat_comment
    end  
  end

  def feature_type_name
    handle_none sample.feature_type.name do
      sample.feature_type.name
    end  
  end

  def feature
    handle_none sample.feature do
      sample.feature
    end  
  end

  def culture_name
    handle_none sample.phase.culture.name do
      sample.phase.culture.name
    end  
  end

  def phase_name
    handle_none sample.phase.name do
      sample.phase.name
    end  
  end

  def linked_site
    handle_none sample.site.name do
      link_to sample.site.name, sample.site
    end  
  end

  def map
    if sample.site.present? && sample.site.lat.present? && sample.site.lng.present?
      loc=sample.site
      out = content_tag(:div, nil, :id => "map", style: "width: 100%; height: 512px")
      #out << (render partial: 'layouts/basic_map', locals: {loc: loc}, formats: [:js])
      out
    else
      out = "No location available."
    end
  end
end
