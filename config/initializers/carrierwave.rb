if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
        provider: 'AWS',
        aws_access_key_id: ENV['fog_api_key'],        # AWSアクセスキー
        aws_secret_access_key: ENV['fog_api_secret'], # AWSシークレットキー
        region: ENV['fog_region'],                    # S3リージョン
        host: ENV['fog_host']                     # S3エンドポイント名(例: s3-us-west-2.amazonaws.com)
    }

    # キャッシュもS3に置くようにする
    config.cache_storage = :fog
    config.cache_dir = 'tmp/image-cache'

    # S3バケット名
    config.fog_directory = ENV['fog_directory']

    # CloudFrontのDomainName or CNAME(例: http://xxx.cloudfront.net)
    # CDNを使わない場合は、S3バケットの絶対パス(例: https://s3-us-west-2.amazonaws.com/<backet>)
    config.asset_host = ENV['fog_asset_host']
  end
end