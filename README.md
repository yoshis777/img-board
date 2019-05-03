## 概要
投稿された画像に対してgoogle vision apiによる文字解析を行い、画像内の文字を検索できるようにした掲示板Webアプリです。  
bulmaを使用してPC上で動作する際にもモバイルアプリケーションのような操作感のあるデザインを目指しました。

## 使用技術
#### インフラ（Webサーバ含む）
* Amazon EC2 (AMAZON LINUX 2)
* Amazon RDS (postgresql)
* Amazon S3 + CloudFront
* nginx
* unicorn

#### CSS
* sass
* bulma：CSSフレームワーク

#### Javascript
* jquery
* jquery-lazyload：画像の遅延読み込み
* blue-imp：投稿画像のカルーセル表示

#### Rails Gem
* carrierwave：画像アップロード
* mini_magick(ImageMagick)：サムネイル作成
* gretel：ぱんくずリスト
* kaminari：ページネーション
* ransack：投稿の文字検索
* bcrypt：パスワード暗号化
* fog：S3への画像アップロード
* minitest：railsテスト
* capistrano：デプロイ自動化
* unicorn：アプリケーションサーバー（操作用）

#### Google API
* google-analytics：利用者の動向解析
* google-cloud-vision：画像の文字解析

## 注意
S3、CloudFront、Google Vision APIについては認証IDを外した状態です。
そのため、そのままでは画像はローカル保存、画像解析は行わない状態となります。
利用する場合は以下の[利用情報]が必要になります。

## 利用情報
#### ファイルに記載
```
# config/environments/production.rb
GA.tracker = "UA-xxxxxx-x" # google analyticsの認証キー

# config/deploy.rb
set :repo_url, "your-git-address" #gitのSSHかHTTPSのURL
set :deploy_to, "your-directory-path-for-deploy" #デプロイしたいディレクトリへの絶対パス

# config/unicorn.conf.rb
$app_dir = "~/rails/img-board" #自分のアプリケーションへのディレクトリパス
```
#### 環境変数に記載
```
SECRET_KEY_BASE={本番環境で動かす場合、任意の値で必要}

database.ymlを参考にDBサーバ情報の設定

GOOGLE_APPLICATION_CREDENTIALS={Google APIの認証に用いるjsonファイルのパス}
fog_api_key={AWSのID}
fog_api_secret={AWSのシークレットキー}
fog_region={AWSのリージョン情報}
fog_host={AWSのホスト情報}
fog_directory={画像を保存するS3バケット名}
fog_asset_host={S3あるいはCloudFrontのURL}
```
