module ActiveRecord
  class Base
    def self.german_float_setters(*syms)
      syms.each do |sym|
      define_method("#{sym}=") do |value|
          if value.class == String
            write_attribute(sym, value.tr(',','.'))
          else
            write_attribute(sym,value)
          end
        end
      end
    end
  end
end

class Sample < ActiveRecord::Base
  attr_accessible :lab_id, :lab_nr, :bp, :std, :delta_13_c, :delta_13_c_std, :prmat_id, :prmat_comment, :comment, :feature, :feature_type_id, :phase_id, :site_id, :approved, :right_id, :dating_method_id, :contact_e_mail, :creator_ip, :site_attributes, :literatures_attributes, :literatures_samples_attributes
  
  german_float_setters :delta_13_c, :delta_13_c_std

  belongs_to :phase
  belongs_to :site
  belongs_to :feature_type
  belongs_to :dating_method
  belongs_to :prmat
  belongs_to :lab
  belongs_to :right
  has_many :comments

  has_many :literatures_samples
  accepts_nested_attributes_for :literatures_samples, :allow_destroy => true

  has_many :literatures, :through => :literatures_samples
  accepts_nested_attributes_for :literatures, :allow_destroy => :false

  validates_presence_of :lab_nr, :bp, :std, :prmat, :feature_type, :right, :site, :phase, :lab
#FIXME  validates_unity_of :lab_nr, :scope => :lab_id

  has_one :culture, :through => :phase

#  accepts_nested_attributes_for :literatures


  accepts_nested_attributes_for :site


  HUMANIZED_ATTRIBUTES = {
    :prmat => "Sample Material",
    :prmat_comment => "Sample Material Comment",
    :lab => "Laboratory",
    :lab_nr => "Sample Number",
    :bp => 'Uncalibrated date',
    :std => 'Standard deviation',
    :delta_13_c => 'Delta 13C value',
    :delta_13_c_std => 'Delta 13C standard deviation',
    :contact_e_mail => 'Contact Email Address'
  }
  
  ATTRIBUTES_HINT_TEXT = {
    :prmat => "The material of the sample",
    :prmat_comment => "Use this field if you want to give additional informations about the sample material",
    :feature => "Enter here the detailed description of the feature (eg. Grave 17)",
    :lab => "Choose the abbreviation of the Laboratory (KIA for Kiel Accelerator)",
    :lab_nr => "Enter the number of the Sample (eg. KIA-2456 => 2456)",
    :bp => "Enter here the uncalibrated date bp",
    :std => 'Enter here standard deviation of the uncalibrated date in years',
    :contact_e_mail => 'Enter here your Email address for clarification requests (will not be shown at the website)'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def self.hint_text(attr)
    ATTRIBUTES_HINT_TEXT[attr.to_sym] || nil
  end


  
  def name
    (lab.lab_code rescue "") + "-" + lab_nr
  end
  
#  def self.find_all_by_name(search_name)
#    temps = Sample.all
#    temps.find_all {|temp| logger.debug temp.name.to_yaml
#                            temp.name.include? search_name}
#  end
  
end
