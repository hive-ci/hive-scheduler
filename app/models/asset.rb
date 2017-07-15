class Asset < ActiveRecord::Base
  belongs_to :project

  has_attached_file :asset,
                    path: "#{Chamber.env.attachment.path_base}/builds/batches/:id/:filename",
                    url: '/builds/batches/:id/:filename'
  validates_attachment_content_type :asset,
                                    content_type: ['application/octet-stream', 'application/vnd.android.package-archive']

  def self.find_or_register(opts = {})
    asset = Asset.where(project_id: opts[:project_id],
                        name: opts[:name],
                        file: opts[:file],
                        version: opts[:version])
    if asset.empty?
      Asset.new(project_id: opts[:project_id],
                name: opts[:name],
                file: opts[:file],
                version: opts[:version])
    else
      asset[0]
    end
  end
end
