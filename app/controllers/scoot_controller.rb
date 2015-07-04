class ScootController < ApplicationController

  def index
  end

  def new 
  end

  def create

    @framework = params[:framework]
    @precompiler = params[:precompiler]
    @asset_pipeline = params[:asset_pipeline]

    def setup_bower
    
      if @framework == 'foundation' 
        # Bower RC
        # Asset Config
        # Copy HTML assets
      end
      if @framework == 'bootstrap' 
        # Bower RC
        # Asset Config
        # Copy HTML assets
      end
      
      if @precompiler == 'vanilla' 
      end
      if @precompiler == 'sass'
      end


    end

    def setup_assets
      if @asset_pipepline == 'vanilla'
        # Gemfile include jekyl-assets
        # plugins/ext.rb
      end
      if @asset_pipepline == 'yes'
      end
    end

    def setup_package
      if @framework == 'foundation' 
        # Copy assets from folder
      end
      if @framework == 'bootstrap'
        # Copy assets from folder
      end
    end

    def render_files
    index = render_to_string( :partial => 'master', :formats => [:html] )
    File.open("#{@dir.to_s}/index.html", "w+"){|f| f << index }
    end

    def zip_assets
      zip_param = params[:zip_name]
      zip_name = "#{Rails.root.to_s}/tmp/cache/#{zip_param}.zip"
      zipfile = ZipFileGenerator.new(@dir, zip_name)
      zipfile.write
      send_file zip_name, type: 'application/zip', disposition: 'attachment'

      export_file = ExportSuccess.new()
      export_file.send
    end


  end


end
