# Terraform-Cloudrun


以下は、指定された条件に基づいてCloud RunのTerraform設定を示したものです。

### `cloud_run.tf`
```hcl
resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image
        ports {
          container_port = 8001
        }
        resources {
          limits = {
            memory = "128Mi"
            cpu    = "1"
          }
        }
      }

      container_concurrency = 80
      timeout_seconds       = 300
    }
  }

  autogenerate_revision_name = true
  traffic {
    percent         = 100
    latest_revision = true
  }

  metadata {
    annotations = {
      "autoscaling.knative.dev/minScale" = "0"
      "autoscaling.knative.dev/maxScale" = "1"
    }
  }
}
```

### `variables.tf`
```hcl
variable "project_id" {
  description = "The GCP project ID"
}

variable "region" {
  description = "The GCP region"
  default     = "asia-northeast1"
}

variable "service_name" {
  description = "The name of the Cloud Run service"
  default     = "my-cloud-run-service"
}

variable "image" {
  description = "The image URL of the Cloud Run service"
}
```

### `provider.tf`
```hcl
provider "google" {
  credentials = file("<PATH_TO_YOUR_SERVICE_ACCOUNT_KEY_JSON>")
  project     = var.project_id
  region      = var.region
}
```

上記のコードでは、環境変数やコンテナの引数などは設定されていません。これらの設定が必要な場合は、`containers`ブロック内に`env`や`args`を追加してください。

また、`<PATH_TO_YOUR_SERVICE_ACCOUNT_KEY_JSON>`をサービスアカウントのキーファイルのパスに、`<YOUR_DOCKER_IMAGE_URL>`をDockerイメージのURLに置き換えて使用してください。

Cloud Runの設定を適用するには、以下のコマンドを実行します。

```sh
terraform init
terraform apply -var="project_id=<YOUR_GCP_PROJECT_ID>" -var="image=<YOUR_DOCKER_IMAGE_URL>"
```

指定された条件に基づいてCloud Runのサービスが作成されます。

### tfvarsで作成
tfvarsで変数を管理すると以下の様に実行できます。
```sh
terraform init
terraform apply -var-file="terraform.tfvars"
```

`terraform.tfvars` ファイルには以下のように変数を設定します。

```hcl
project_id = "<YOUR_GCP_PROJECT_ID>"
region = "asia-northeast1"
service_name = "<YOUR_CLOUD_RUN_SERVICE_NAME>"
github_owner = "<YOUR_GITHUB_USERNAME_OR_ORG_NAME>"
github_repo = "<YOUR_GITHUB_REPO_NAME>"
```



<br>


## githubからデプロイ設定 

GitHubから直接Cloud Runにデプロイするには、Cloud BuildとGitHubの連携が必要です。以下はそのための一連の手順です。

### 1. Terraformファイルの準備

まず、Cloud RunサービスとCloud Buildトリガーを作成するTerraformファイルを準備します。

```hcl
variable "project_id" {}
variable "region" {}
variable "service_name" {}
variable "github_owner" {}
variable "github_repo" {}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }

    spec {
      containers {
        image = "gcr.io/${var.project_id}/${var.service_name}"
        
        ports {
          container_port = 8001
        }

        resources {
          limits = {
            memory = "128Mi"
            cpu    = "1"
          }
        }
      }
      service_account_name = google_service_account.cloud_run_service_account.email
      container_concurrency = 80
      timeout_seconds = 300
    }
  }

  autogenerate_revision_name = true
  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_service_account" "cloud_run_service_account" {
  account_id   = "cloud-run-service-account"
  display_name = "Cloud Run Service Account"
}

resource "google_cloudbuild_trigger" "github_trigger" {
  name = "github-trigger"
  description = "Trigger for GitHub commits"
  
  github {
    owner = var.github_owner
    name = var.github_repo
    push {
      branch = "^main$"
    }
  }

  filename = "cloudbuild.yaml"
}

```

### 2. `cloudbuild.yaml` ファイルの作成

次に、Cloud Buildの設定ファイル `cloudbuild.yaml` を作成します。このファイルはGitHubリポジトリのルートに配置し、ビルドとデプロイの手順を定義します。

```yaml
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: ['build', '-t', 'gcr.io/$PROJECT_ID/$REPO_NAME:$COMMIT_SHA', '.']
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'gcr.io/$PROJECT_ID/$REPO_NAME:$COMMIT_SHA']
- name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  args: ['run', 'deploy', '$REPO_NAME', '--image', 'gcr.io/$PROJECT_ID/$REPO_NAME:$COMMIT_SHA', '--region', 'asia-northeast1']
  env:
  - 'CLOUDSDK_COMPUTE_REGION=asia-northeast1'
  - 'CLOUDSDK_CORE_DISABLE_PROMPTS=1'
```

このファイルは、Dockerイメージをビルドし、それをGoogle Container Registryにプッシュし、最後にCloud Runにデプロイします。

### 3. Terraformの実行

最後に、Terraformを実行してリソースを作成します。

```sh
terraform init
terraform apply -var-file="terraform.tfvars"
```

`terraform.tfvars` ファイルには以下のように変数を設定します。

```hcl
project_id = "<YOUR_GCP_PROJECT_ID>"
region = "asia-northeast1"
service_name = "<YOUR_CLOUD_RUN_SERVICE_NAME>"
github_owner = "<YOUR_GITHUB_USERNAME_OR_ORG_NAME>"
github_repo = "<YOUR_GITHUB_REPO_NAME>"
```

これで、GitHubリポジトリへのプッシュがトリガーとなり、Cloud Buildが動作してCloud Runにアプリケーションがデプロイされるようになります。
