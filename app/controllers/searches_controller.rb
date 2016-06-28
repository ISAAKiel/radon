class SearchesController < ApplicationController
#require 'will_paginate/array'
  def index

    do_search
    if (params[:show_all]=='true') then @end_result = @end_result_all end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  #{ render :xml => @gefaesseinheits_all }
#      format.csv  { render :csv => @end_result }      
      format.csv  { download_csv}
      format.oxcal
    end
  end


  # GET /searches/1
  # GET /searches/1.xml
  def show

    redirect_to params.merge!(:action => :index, :specified_fields=>{"lab.name".to_sym =>"lab.name", :bp => "bp", :lab_nr => "lab_nr", :std => "std"})

#    do_search
#    
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @end_result }
#    end
  end

  # GET /searches/new
  # GET /searches/new.xml
  def new
    @search = Search.new
    session[:search_hist]=""

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @search }
    end
  end

  def update_subfields

    chain = params[:id].split(".") #Ausgangs-Kette einlesen
    chain_new=[]
    chain_new.push(chain[0]) #Ziel-Kette mit Starttabelle bestücken
    level = 0 #Suchtiefe auf null setzen

    chain[0..-2].each do |link| #Für jedes Glied der Kette
      level=level+1 #Such-Level erhöhen
      assocs=chain_new[level-1].classify.constantize.reflect_on_all_associations #alle Assoziationen für die Tabelle auswerfen
      this_assoc=assocs.detect {|assoc| assoc.primary_key_name==chain[level]} #testen, ob das nächste glied der Kette einer Assoziation entspricht

      this_assoc=this_assoc || assocs.detect {|assoc| assoc.table_name==chain[level]} #FIXME testen, ob das nächste glied der Kette einer hm_Assoziation entspricht
      if this_assoc # Wenn ja
        chain_new.push(this_assoc.association_foreign_key[0..-4]) #wird dieses der neuen Kette hinzugefügt
      else # Sonst
        break # verlasse die Schleife
      end
    end
    table=chain_new.last # Die Tabelle, für die das Auswahlfeld bevölkert werden soll, ist das letzte Glied der neuen Kette
    unless table.blank?
      @update_subfields = table.classify.constantize.column_names.sort #Holt die Spaltennamen der aktuellen Tabelle
      @update_associations = table.classify.constantize.reflect_on_all_associations #holt die Assoziationen der aktuellen Tabelle
      @hm_assocs = table.classify.constantize.reflect_on_all_associations(:has_many)
      @ho_assocs = table.classify.constantize.reflect_on_all_associations(:has_one)
#      @hm_assocs.push(table.classify.constantize.reflect_on_all_associations(:has_one))
      if chain_new.length!=chain.length #Wenn beiden Ketten in Länge differieren (also ein Glied als Nicht-Assoziation erkannt wurde)
        if table==chain.last || chain.last =="name"
          @update_subfields=table.classify.constantize.all #Hole den Inhalt der Tabelle
        else
          @update_subfields=nil
        end
        @column_type = table.classify.constantize.columns.detect{|column| column.name == chain.last}.type.to_s
        @field_type="input" #Setze Feldtyp als Input-Feld
      end      
    else
      render :nothing => true
    end
  end

=begin #FIXME Edit multiple not activated
  def edit_multiple
    if params[:edit_multiple] == "Markierte Löschen"
      delete_multiple
    else
      @objects = params[:haupttabelle_id].classify.constantize.find(params[:object_ids])
      object_controller = eval(params[:haupttabelle_id].camelize + "Controller").new
      object_controller.send('collect_instances')

      instance_variables = object_controller.instance_variable_names

      instance_variables.each do |instance_variable|
        instance_variable_set(instance_variable, object_controller.instance_variable_get(instance_variable))
      end
    end
  end
  
  def update_multiple
    @objects = params[:haupttabelle_id].classify.constantize.find(params[:object_ids])
    param_prefix = (params[:haupttabelle_id].classify.underscore)

    @objects.each do |object|
      object.update_attributes(params[param_prefix.to_sym].reject { |k,v| v.blank? })
    end
    flash[:notice] = params[:haupttabelle_id].classify.humanize + ": Datensätze mit den ID " + params[:object_ids].join(", ") + " wurden ver&auml;ndert!"
    redirect_to params[:referrer]
  end
=end
  
  protected
  
    def download_csv
    @performed_render = false
    
    do_search
    
#    require 'fastercsv' 
    require 'iconv'
    fields_to_show = [
    "id",
    ]
    
    if params[:haupttabelle_id] == "samples"
      out='Options(){RawData=TRUE};Plot(){'
      @end_result_all.each do |sample|
        out<<"R_Date('#{sample.id}',#{sample.bp},#{sample.std});"
      end
      out<<'};'
      File.open('tmp/radon_calib.oxcal', 'w') {|f| f.write(out) }
      `vendor/oxcal/OxCalLinux tmp/radon_calib.oxcal`
      oxcal_out = File.read('tmp/radon_calib.txt')
      oxcal_out = oxcal_out.split("\n")
      one_sigma=Array.new
      one_sigma[0]='One Sigma'
      two_sigma=Array.new
      two_sigma[0]='Two Sigma'
      oxcal_out.each do |calib_result|
        unless calib_result.blank?
          calib_result = calib_result.split(' ')
          if (calib_result.length < 5)
            calib_result = ['na','na','na','na','na']
          end
          one_sigma.push(calib_result[1]+" (68.2%) "+calib_result[2])
          two_sigma.push(calib_result[3]+" (95.4%) "+calib_result[4])
        end
      end
      user_files_mask = File.join("#{Rails.root}/tmp/radon_calib*")

      user_files = Dir.glob(user_files_mask)

      user_files.each do |file_location|
        File.delete(file_location)
      end
    end


    temp_file = Tempfile.new(Digest::MD5.hexdigest(rand(12).to_s))
    temp_path = temp_file.path()
    content_columns = []
    params[:haupttabelle_id].classify.constantize.content_columns.each do |column|
      if column.type.to_s=="float"
        content_columns << "replace(to_char(#{params[:haupttabelle_id]}.#{column.name},'9999D999'),'.',',') AS #{column.name}"
      else
        content_columns << "#{params[:haupttabelle_id]}.#{column.name}"
      end
    end

    sql_select = "COPY (SELECT #{params[:haupttabelle_id]}.id, " + content_columns.join(", ") + " "

    sql_from = "FROM #{params[:haupttabelle_id]} "
    sql_where = "WHERE #{params[:haupttabelle_id]}.id IN ('" + @end_result_all.map(&:id).join("', '") + "')"
    sql_end = ")TO STDOUT DELIMITER ';' CSV HEADER;"

    assocs=params[:haupttabelle_id].classify.constantize.reflect_on_all_associations(:belongs_to)
    assocs_join =[]
    assocs_select = []
    assocs.each do |assoc|
      assoc_colums = assoc.class_name.classify.constantize.column_names
      assoc_field = nil
      if assoc_colums.detect{|e| e=="name"}
        assoc_field = "name"
      elsif assoc_colums.detect{|e| e==assoc.class_name.tableize.singularize}
        assoc_field = assoc.class_name.tableize.singularize
      else
        next
      end
      unless assoc_field.blank?
        assoc_select = assoc.name.to_s.tableize + "." + assoc_field + " AS " + assoc.name.to_s
        assoc_join = "LEFT JOIN " + assoc.class_name.tableize.to_s + " AS " + assoc.name.to_s.tableize + " ON " + params[:haupttabelle_id] + "." + assoc.primary_key_name + " =" + assoc.name.to_s.tableize + ".id"
        assocs_select << assoc_select
        assocs_join << assoc_join
      end

    end
    
    if params[:haupttabelle_id] == "samples"
      assocs_select.push("cultures.name AS culture")
      assocs_select.push("labs.lab_code AS lab_code")
      assocs_select.push("sites.lat AS lat")
      assocs_select.push("sites.lng AS lng")
      assocs_join.push("LEFT JOIN cultures on phases.culture_id=cultures.id")
    end


    
    sql = sql_select + ", " + assocs_select.join(", ") + " " + sql_from + " " + assocs_join.join(" ") + " "  + sql_where + sql_end
    
    conn = ActiveRecord::Base.connection_pool.checkout
    pg_conn = conn.raw_connection
    pg_conn.exec("#{sql}")

    csv = String.new()
    index=-1
    begin
      while line = pg_conn.get_copy_data
        index = index + 1
        logger.debug line
        if params[:haupttabelle_id] == "samples"
          line = line.strip + ';' + one_sigma[index] + ';' + two_sigma[index]
        end
        temp_file.write Iconv.conv('ISO-8859-15//TRANSLIT//IGNORE', 'utf-8', line) + "\n"
      end
    rescue
      ActiveRecord::Base.connection_pool.checkin(conn)
    ensure
      ActiveRecord::Base.connection_pool.checkin(conn)
    end

  temp_file.close

  send_file temp_file.path, :type => 'text/csv; charset=ISO-8859-1; header=present', :filename => "#{params[:haupttabelle_id]}.csv"   
  end

=begin function delete_multiple not activated
  def delete_multiple
    @objects = params[:haupttabelle_id].classify.constantize.find(params[:object_ids])
    @objects.each do |object|
      object.destroy
    end
  flash[:notice] = "Markierte gel&ouml;scht!"
  redirect_to :back
  end
=end


  def do_search

    @end_result = []
    if params[:simple_search] == "1"
      temp_results=[]
      search_op = []
      4.times do |index|
        search_value = params[("simple_value_"+index.to_s).to_sym]
        unless search_value.blank?
          search = params[("simple_search_"+index.to_s).to_sym]
          search_op.push(params[("simple_operator_"+(index).to_s).to_sym])

          search_field = case search
               when "country"  then "site.country_subdivision.countries.name"
               when "culture"   then "phase.culture.name"
               when "literatures" then "literatures.map(&:long_citation).join(' ')"
               when "rights"  then "rights.name"
               when "country_subdivisions"   then "site.country_subdivision.name"
               when "labs" then "lab.name"
               when "prmats" then "prmat.name"
               when "dating_methods" then "dating_method.name"
               when "sites" then "site.name"
               when "feature_types" then "feature_type.name"
               when "phases" then "phase.name"
          end
          

          
          temp_results.push(Sample.with_permissions_to(:show).all.find_all {|row| 
                                              field_value = row.method(:eval).call(search_field) rescue ""
                                              field_value.downcase.include? search_value.downcase})
        end

    end
    

      temp_results.each_with_index do |temp_result, index|

        case search_op[index]
          when "and"
            @end_result = @end_result & temp_result
          when "and_not"
            @end_result = @end_result - temp_result
          else
        @end_result = @end_result | temp_result
        end
      
      end
      
      @end_result.uniq!
          
  else

    temp_result=[]
    @search=[]
    @end_result = []
    @searches = params.select {|k,v| k[0..6] == "search_"}
    @operators = params.select {|k,v| k[0..8] == "operator_"}
    searches_counter=-1
    @searches.each do |search|
    searches_counter=searches_counter+1
      @temp_result=[]
      @search << search[0].to_s[7..-1]
      @search_params = search[0].to_s[7..-1].split(".")
    chain = @search_params
    chain.shift
    base_search=@searches.to_a[searches_counter][1]


#TODO unchain in eine eigene Methode?!
#start unchain
    chain_new=[]
    chain_new.push(chain[0]) #Ziel-Kette mit Starttabelle bestücken
    level = 0 #Suchtiefe auf null setzen

    chain[0..-2].each do |link| #Für jedes Glied der Kette
      level=level+1 #Such-Level erhöhen
      assocs=chain_new[level-1].classify.constantize.reflect_on_all_associations #alle Assoziationen für die Tabelle auswerfen
      this_assoc=assocs.detect {|assoc| assoc.primary_key_name==chain[level]} #testen, ob das nächste glied der Kette einer Assoziation entspricht
      this_assoc=this_assoc || assocs.detect {|assoc| assoc.table_name==chain[level]} #FIXME testen, ob das nächste glied der Kette einer hm_Assoziation entspricht
      if this_assoc # Wenn ja
        chain_new.push(this_assoc.association_foreign_key[0..-4]) #wird dieses der neuen Kette hinzugefügt
      else # Sonst
        break # verlasse die Schleife
      end
    end
    table=chain_new.last # Die Tabelle, für die das Auswahlfeld bevölkert werden soll, ist das letzte Glied der neuen Kette
#end unchain

    base_field=chain[-1]
    operator=@operators.to_a[searches_counter][1] #TODO support multipler suchen hier Operator anpassen

#    if ["=",">","<","LIKE"].detect{|e| e=operator} && table.classify.constantize.first.attributes.keys.include?(base_field) FIXME wenn Tabelle leer, wirft exception
    if ["=",">","<","LIKE"].detect{|e| e=operator} && table.classify.constantize.columns.map(&:name).include?(base_field)

      conditions = []

      if operator=="LIKE"
        conditions=["lower(CAST(#{base_field} AS text)) #{operator} ?", "%" + base_search.downcase  + "%" ]
      else
        conditions=["#{base_field} #{operator} ?", base_search ]
      end

      @base_result=table.classify.constantize.with_permissions_to(:show).all(:conditions=>conditions)
    end

    if chain.length>2
    
      count=chain.length-2

      chain_result=@base_result

      chain[1..-2].reverse.each do |link|
        count=count-1

        new_assocs = chain_new[count+1].classify.constantize.reflect_on_all_associations(:belongs_to) #FIXME new_assocs name ungünstig

        hm_assocs = chain_new[count+1].classify.constantize.reflect_on_all_associations(:has_many) #FIXME new_assocs name ungünstig

        through = hm_assocs.detect {|assoc| (assoc.class_name==chain_new[count].classify) && (assoc.through_reflection)}

        if through

          through_result = []
          chain_result.each do |item|

            through_result.push(item.send(through.name).map(&:id))
          end

          conditions = "id IN (?)", through_result.flatten

        else

          uplink = new_assocs.detect {|assoc| assoc.class_name==chain_new[count].classify}
          if uplink
            conditions = "id IN (?)", chain_result.map(&uplink.primary_key_name.to_sym)
          else
            conditions = "#{link} IN (?)", chain_result
          end
        end
        
        chain_result=chain_new[count].classify.constantize.with_permissions_to(:show).all(:conditions=>conditions)

      end
      temp_result.push(chain_result)
    else
    temp_result.push(@base_result)
    end
    end

    @end_result=temp_result[0]
    if temp_result.length > 1
      temp_result[1..-1].each do |inbetween|
        if params[:combine_option] =="or"
         @end_result = @end_result | inbetween
        else
         @end_result = @end_result & inbetween
        end
      end
    end
  end
    @end_result_all=@end_result
    if @end_result && @end_result.size > 0
    	#@end_result = @end_result.paginate :page => params[:page], :per_page => 20    
    	@end_result = Kaminari.paginate_array(@end_result).page(params[:page]).per(20)
    end
  end
end
