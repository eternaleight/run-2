## run-2 (Cloudflare R2, Google Cloud Run)

<p align="center">
  <img src="https://github.com/eternaleight/eva-r2/assets/96198088/cebf749f-7919-4b6e-8765-bfe1d8421b84" width="50%">
</p>

このTerraformプロジェクトは、Cloudflare R2バケットとGoogle Cloud Runサービス（最小コスト設定）のデプロイを自動化します。
#### Cloud Runの設定
```:Cloud Runの設定
コンテナPORT:8001

メモリ 128MiB # 最小の設定
vcpuの数 1

リクエストタイムアウト 300s
最大同時リクエスト数 80

リクエストの処理中にのみCPUを割り当てる

実行環境
デフォルト

自動スケーリング
インスタンスの最小数 0 # 最小の設定
インスタンスの最大数 1 # 最小の設定

起動時の CPU ブースト 無し
```

## プロジェクト構成

`run-2`プロジェクトは、以下の主要なファイルで構成されています。

- **`.gitignore`**: Gitリポジトリで無視するファイルやディレクトリのパターンを定義します。
- **`.terraform_example.tfvars`**: Terraform変数のサンプル値を定義したファイルで、ユーザーが自身の設定に基づいてカスタマイズするためのテンプレートとして機能します。**.terraform_example.tfvarsを参考に`.terraform.tfvars`ファイルを作成して下さい。**
- **`README.md`**: プロジェクトの概要、設定方法、使用方法についての説明が記載されています。
- **`cloud_run.tf`**: Google Cloud Runの設定を定義するTerraform設定ファイルです。
- **`cloudbuild.yaml`**: Google Cloud Buildで使用されるビルド構成を定義するYAMLファイルです。Dockerイメージのビルドとプッシュ、そしてGoogle Cloud Runへのデプロイが自動化されます。
- **`cloudflare_r2.tf`**: Cloudflare R2のバケットリソースを管理するためのTerraform設定ファイルです。
- **`sh.sh`**: シェルスクリプトファイルで、環境設定やデプロイプロセスの自動化をサポートするスクリプトを含みます。

## 前提条件
- Terraformがインストールされている
- Google Cloud SDKがインストールされている
- Google Cloud Platformのアカウントがある
- GitHubのアカウント（リポジトリ）がある
- Cloudflareのアカウントがある

## セットアップ
**Terraform変数の設定**: `.terraform.tfvars` ファイルを作成し、必要な変数を設定します。例として、`.terraform_example.tfvars` ファイルを参考にしてください。

```hcl
# Cloudflare R2
api_token = "<your_api_token>"
zone_id = "<your_zone_id>"
account_id = "<your_account_id>"
bucket_name = "terraform-test-bucket"

# Cloud Run
project_id = "<YOUR_GCP_PROJECT_ID>"
region = "asia-northeast1"
service_name = "terraform-test-cloudrun"
github_owner = "<YOUR_GITHUB_USERNAME_OR_ORG_NAME>"
github_repo = "<YOUR_GITHUB_REPO_NAME>"

# BACKEND_ENV 
env_vars = {
  BACKEND_ENV_NAME = "<BACKEND_ENV_VALUE>"
  BACKEND_ENV_NAME2 = "<BACKEND_ENV_VALUE2>"
# ... 他の環境変数
}
```

## 使用方法
Google Cloud RunサービスとCloudflare R2バケットをデプロイするには、以下のTerraformコマンドを実行します：
```sh
terraform init
terraform apply -var-file=".terraform.tfvars"
```

## リソースの削除
デプロイしたリソースを削除するには、以下のコマンドを実行します：
```sh
terraform destroy -var-file=".terraform.tfvars"
```
