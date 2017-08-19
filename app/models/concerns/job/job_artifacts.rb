class Job < ActiveRecord::Base
  module JobArtifacts
    extend ActiveSupport::Concern

    def stdout
      Paperclip.io_adapters.for(stdout_log.asset).read if stdout_log.present?
    rescue => e
      "Couldn't load stdout file #{e.message}"
    end

    def stderr
      Paperclip.io_adapters.for(stderr_log.asset).read if stderr_log.present?
    rescue => e
      "Couldn't load stderr output #{e.message}"
    end

    def command
      Paperclip.io_adapters.for(command_log.asset).read if command_log.present?
    rescue
      "Couldn't load command file"
    end

    def log_files
      all_logs.each_with_object({}) do |log_artifact, hash|
        hash[log_artifact.asset_file_name] = log_artifact.asset.expiring_url(10 * 60)
      end
    end

    # Returns a hash of filename/url pairs
    def images
      image_artifacts.each_with_object({}) do |image_artifact, hash|
        hash[image_artifact.asset_file_name] = image_artifact.asset.expiring_url(10 * 60)
      end
    end

    private

    def stdout_log
      find_asset('pretty.out') || find_asset('stdout.log')
    end

    def stderr_log
      find_asset('stderr.log')
    end

    def command_log
      find_asset('executed_script.sh') || find_asset('cmd.sh')
    end

    def all_logs
      artifacts.find_all do |artifact|
        artifact.asset_content_type !~ /^image\//
      end
    end

    def image_artifacts
      artifacts.find_all do |artifact|
        artifact.asset_content_type =~ /^image\// || artifact.asset_file_name.end_with?('.png', '.jpg', '.jpeg')
      end
    end

    def find_asset(file_name)
      artifacts.find do |artifact|
        artifact.asset_file_name == file_name
      end
    end
  end
end
