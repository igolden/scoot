require 'zip_file_generator'
require 'export_file'

class ScootController < ApplicationController

  def create
    Rails.cache.clear

    Dir.mktmpdir do |dir| 
      @dir = dir
      @assets_link = "#{Rails.root.to_s}/app/views/scoot/packages"
      @framework = params[:framework]
      @compiler = params[:compiler]
      @asset_pipeline = params[:asset_pipeline]

      def setup_folders
        FileUtils.mkdir("#{@dir.to_s}/_plugins") 
        FileUtils.cp_r( "#{@assets_link}/#{@framework}/_assets", "#{@dir.to_s}/_assets") 
        FileUtils.cp_r( "#{@assets_link}/#{@framework}/_includes", "#{@dir.to_s}/_includes") 
        FileUtils.cp_r( "#{@assets_link}/#{@framework}/_layouts", "#{@dir.to_s}/_layouts") 
        FileUtils.cp( "#{@assets_link}/#{@framework}/_config.yml", "#{@dir.to_s}/_config.yml") 
        FileUtils.cp( "#{@assets_link}/#{@framework}/index.html", "#{@dir.to_s}/index.html") 
      end

      def setup_package
      end

      def render_files
        if @asset_pipeline == 'yes'
          bowerrc = render_to_string( :partial => 'bowerrc', :formats => [:html] )
          File.open("#{@dir.to_s}/.bowerrc", "w+"){|f| f << bowerrc }
        end
        bowerjson = render_to_string( :partial => 'bowerjson', :formats => [:html] )
        File.open("#{@dir.to_s}/bower.json", "w+"){|f| f << bowerjson }
        plugins_ext = render_to_string( :partial => 'plugins_ext', :formats => [:html] )
        File.open("#{@dir.to_s}/_plugins/ext.rb", "w+"){|f| f << plugins_ext }
        gemfile = render_to_string( :partial => 'gemfile', :formats => [:html] )
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

      setup_folders
      render_files
      export_zip_files
    end
  end
end

