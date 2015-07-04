require 'zip_file_generator'
require 'export_file'

class ScootController < ApplicationController

  def index
  end

  def new 
  end

  def create
       Rails.cache.clear

       Dir.mktmpdir do |dir| 
         @dir = dir

         #Define Link to app/package_templates
         assets = "#{Rails.root.to_s}/app/views/scoot/assets"
         @assets_link = assets

         @framework
         @compiler
         @asset_pipeline

           if params[:framework] == "bootstrap"
           end
           if params[:framework] == "foundation"
           end
           if params[:preprocessor] == "sass"
           end


         def setup_gemfile
         end

         def setup_assets
         end

         def setup_package
         end

         def render_files
           bowerrc = render_to_string( :partial => 'bowerrc', :formats => [:html] )
           gemfile = render_to_string( :partial => 'bowerrc', :formats => [:html] )
           bowerjson = render_to_string( :partial => 'bowerrc', :formats => [:html] )

           File.open("#{@dir.to_s}/.bowerrc", "w+"){|f| f << bowerrc }
           File.open("#{@dir.to_s}/bower.json", "w+"){|f| f << bowerjson }
           File.open("#{@dir.to_s}/Gemfile", "w+"){|f| f << gemfile }

         end


         def export_zip_files
           # Zip the files
           zip_param = params[:zip_name]
           zip_name = "#{Rails.root.to_s}/tmp/cache/#{zip_param}.zip"
           zipfile = ZipFileGenerator.new(@dir, zip_name)
           zipfile.write
           send_file zip_name, type: 'application/zip', disposition: 'attachment'
           export_file = ExportSuccess.new()
           export_file.send
         end

         render_files
         export_zip_files


       end


end
end

