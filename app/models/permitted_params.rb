class PermittedParams < Struct.new(:params, :user)
  def country
    params.require(:country).permit(*country_attributes)
  end

  def country_attributes
    [:name, :country_subdivisions_attributes, :abreviation]
  end

  def country_subdivision
    params.require(:country_subdivision).permit(*country_subdivision_attributes)
  end

  def country_subdivision_attributes
    [:name, :country_id]
  end

  def prmat
    params.require(:prmat).permit(*prmat_attributes)
  end

  def prmat_attributes
    [:name]
  end

  def lab
    params.require(:lab).permit(*lab_attributes)
  end

  def lab_attributes
    [:name, :dating_method_id, :lab_code, :country, :active]
  end

  def right
    params.require(:right).permit(*right_attributes)
  end

  def right_attributes
    [:name]
  end

  def feature_type
    params.require(:feature_type).permit(*feature_type_attributes)
  end

  def feature_type_attributes
    [:name, :comment]
  end

  def dating_method
    params.require(:dating_method).permit(*dating_method_attributes)
  end

  def dating_method_attributes
    [:name]
  end

  def sample
    params.require(:sample).permit(*sample_attributes)
  end

  def sample_attributes
    attributes =[:lab_id, :lab_nr, :bp, :std, :delta_13_c, :delta_13_c_std, :prmat_id, :prmat_comment, :comment, :feature, :feature_type_id, :phase_id, :site_id, :approved, :right_id, :dating_method_id, :contact_e_mail, :creator_ip, :tenant_ids => []]
    attributes << {site_attributes: site_attributes}
    attributes << {literatures_attributes: literature_attributes}
    attributes << {literatures_samples_attributes: literatures_sample_attributes}
  end

  def site
    params.require(:site).permit(*site_attributes)
  end

  def site_attributes
    attributes = [:name, :parish, :district, :country_subdivision_id, :lat, :lng]
#    attributes << {samples_attributes: sample_attributes}
  end

  def literature
    params.require(:literature).permit(*literature_attributes)
  end

  def literature_attributes
    attributes = [:short_citation, :year, :author, :long_citation, :url, :bibtex, :term]
    attributes << {literatures_samples_attributes: literatures_sample_attributes}
  end

  def literatures_sample
    params.require(:literatures_sample).permit(*literatures_sample_attributes)
  end

  def literatures_sample_attributes
    attributes = [:literature_short_citation_autocomplete, :pages, :literature, :literature_id]
#    attributes << {literature_attributes: literature_attributes}
  end

  def culture
    params.require(:culture).permit(*culture_attributes)
  end

  def culture_attributes
    attributes = [:name]
#    attributes << {:phases_attributes: :phase_attributes}
  end

  def phase
    params.require(:phase).permit(*phase_attributes)
  end

  def phase_attributes
    attributes = [:name, :culture_id]
  end

  def page
    params.require(:page).permit(*page_attributes)
  end

  def page_attributes
    [:name, :content]
  end

  def announcement
    params.require(:announcement).permit(*announcement_attributes)
  end

  def announcement_attributes
    attributes = [:title, :content, :tenant_ids => []]
  end
end
