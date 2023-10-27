# Terraform-Merged-Project (R2, Cloud Run)


このTerraformプロジェクトは、Google Cloud Runsサービス（コスト削減設定）とCloudflare R2バケットのデプロイを自動化します。

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

# Cloud Run
project_id = "<YOUR_GCP_PROJECT_ID>"
region = "asia-northeast1"
service_name = "<YOUR_CLOUD_RUN_SERVICE_NAME>"
github_owner = "<YOUR_GITHUB_USERNAME_OR_ORG_NAME>"
github_repo = "<YOUR_GITHUB_REPO_NAME>"

# BACKEND_ENV 
env_vars = {
  BACKEND_ENV_NAME = "<BACKEND_ENV_VALUE>"
  BACKEND_ENV_NAME2 = "<BACKEND_ENV_VALUE2>"
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
