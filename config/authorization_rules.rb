authorization do
  role :admin do
    includes :guest
    has_permission_on :sites, :to => [:index, :show, :new, :create, :edit, :update, :destroy, :without_geolocalisation, :with_geolocalisation]
    has_permission_on :roles, :to => :manage
    has_permission_on :users, :to => :manage
    has_permission_on :samples, :to => [:index, :show, :new, :create, :edit, :update, :destroy, :calibrate, :export_chart, :calibrate_multi]
    has_permission_on :cultures, :to => :manage
    has_permission_on :countries, :to => :manage
    has_permission_on :country_subdivisions, :to => :manage
    has_permission_on :dating_methods, :to => :manage
    has_permission_on :phases, :to => [:index, :show, :new, :create, :edit, :update, :destroy, :get_phases_by_culture]
    has_permission_on :feature_types, :to => :manage
    has_permission_on :labs, :to => :manage
    has_permission_on :prmats, :to => :manage
    has_permission_on :literatures, :to => [:index, :show, :new, :create, :edit, :update, :destroy, :autocomplete, :without_bibtex]
    has_permission_on :rights, :to => :manage
    has_permission_on :searches, :to => :manage
    has_permission_on :comments, :to => :manage
    has_permission_on :literatures_samples, :to => :manage
    has_permission_on :pages, :to => :manage
    has_permission_on :announcements, :to => :manage
    has_permission_on :authorization_rules, :to => :read
  end

  role :hiwi do
    has_permission_on :cultures, :to => :manage
    has_permission_on :countries, :to => :manage
    has_permission_on :country_subdivisions, :to => :manage
    has_permission_on :phases, :to => [:index, :show, :new, :create, :edit, :update, :destroy, :get_phases_by_culture]
    has_permission_on :sites, :to => [:new, :create, :edit, :update, :without_geolocalisation, :with_geolocalisation]
    has_permission_on :samples, :to => [:index, :show, :calibrate, :export_chart, :calibrate_multi]
    has_permission_on :samples, :to => [:new, :create, :edit, :update]
    has_permission_on :literatures_samples, :to => [:new, :create, :edit, :update, :destroy]
    has_permission_on :literatures, :to => [:new, :create, :edit, :update, :autocomplete, :without_bibtex]
    has_permission_on :users, :to => [:show, :edit, :update] do
      if_attribute :id => is { user.id }
    end
    has_permission_on :announcements, :to => [:manage]
    includes :guest
  end
  
  role :guest do
    has_permission_on :sites, :to => :read
    has_permission_on :samples, :to => [:index, :calibrate_multi, :export_chart, :calibrate_sum]#, :create, :new]
    has_permission_on :samples, :to => [:show, :calibrate] do
      if_attribute :right_id => is {1}
    end
    has_permission_on :cultures, :to => :read
    has_permission_on :countries, :to => :read
    has_permission_on :country_subdivisions, :to => :read
    has_permission_on :dating_methods, :to => [:show]
    has_permission_on :phases, :to => [:show]#, :new, :create]
    has_permission_on :feature_types, :to => :read
    has_permission_on :labs, :to => :read
    has_permission_on :prmats, :to => :read
    has_permission_on :literatures, :to => [:read, :un_api]
    has_permission_on :rights, :to => [:show]
    has_permission_on :searches, :to => [:index, :show, :new]
    has_permission_on :literatures_samples, :to => [:show]#, :new, :create, :edit, :update, :destroy]
    has_permission_on :comments, :to => [:show, :new, :create]
    has_permission_on :pages, :to => [:show]
    has_permission_on :announcements, :to => [:read]
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
