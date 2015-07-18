require 'zip_file_generator'
require 'export_file'

class ScootController < ApplicationController

  def create
    Rails.cache.clear

    Dir.mktmpdir do |dir| 
      @dir = dir

      def configure_scoot
        @package = params[:package]
        @framework = params[:framework]
        @compilers = params[:compilers]
        @asset_pipeline = params[:asset_pipeline]
      end

      def configure_deploy
      end

      def configure_business
        package = params[:package]
        framework = params[:framework]
        compilers = params[:compilers]
        asset_pipeline = params[:asset_pipeline]
      end
      def render_scoot
        project_meta = { 'scoot' => 
                       { 
                         'package' => "#{@package}",  
                         'framework' => "#{@framework}",  
                         'compilers' => "#{@compilers}", 
                         'asset_pipeline' => "#{@asset_pipeline}" }
                      }
        business_meta = { 'business' => 
                       { 
                         'name' => "",  
                         'phone' => "",  
                         'email' => "", 
                         'fax' => "" }
                      }
        deploy_meta = { 'deploy' => 
                       { 
                         'ftp_host' => "yourdomain.com",  
                         'ftp_dir' => "/public_html/",  
                         'ftp_passive' => "false", 
                         'ftp_port' => "21", 
                         'ftp_username' => "username", 
                         'ftp_password' => "password", 
                         'ftp_secure' => "false" }
                      }

        scoot_meta = [project_meta, deploy_meta, business_meta].reduce({}, :merge)

        scoot = File.open("#{@dir.to_s}/.scoot", 'w+') { |f| YAML.dump(scoot_meta, f) }
      end

      def export_zip
        # Zip the files
        zip_param = params[:file_name]
        zip_name = "#{Rails.root.to_s}/tmp/cache/#{zip_param}.zip"
        zipfile = ZipFileGenerator.new(@dir, zip_name)
        zipfile.write
        send_file zip_name, type: 'application/zip', disposition: 'attachment'
        export_file = ExportSuccess.new()
        export_file.send
      end

      configure_scoot
      render_scoot
      export_zip
    end
  end
end
