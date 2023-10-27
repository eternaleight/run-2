# Terraform-Merged-Project (R2, Cloud Run)


1. **初期化**:
最初に、Terraformの初期化を行う必要があります。これにより、必要なプロバイダプラグインがダウンロードされ、Terraformの環境が初期化されます。

```zsh
terraform init
```

2. **実行計画の生成**:
次に、`terraform plan` コマンドを使って実行計画を生成します。このコマンドは、実際に変更を適用する前に、どのような変更が行われるかを示すものです。`-var-file` オプションを使用して `.terraform_example.tfvars` ファイルを指定します。

```zsh
terraform plan -var-file=".terraform_example.tfvars"
```

3. **変更の適用**:
`terraform apply` コマンドを使って、実際に変更を適用します。再度、`-var-file` オプションを使用して `.terraform_example.tfvars` ファイルを指定します。

```zsh
terraform apply -var-file=".terraform_example.tfvars"
```

このコマンドを実行すると、Terraformは変更を確認するプロンプトを表示します。変更内容を確認し、問題がなければ `yes` を入力して変更を適用します。

これで、Terraformのコードが実行され、インフラストラクチャが作成または更新されます。`.terraform_example.tfvars` ファイルは、センシティブな情報（APIトークンなど）を提供するために使用されます。
<br>
<br>

## Terraformで管理しているリソースを削除するには、`terraform destroy` コマンドを使用します。


1. **`terraform destroy`の実行**: 
    まず、コマンドラインから以下のコマンドを実行してください。

```zsh
terraform destroy -var-file=".terraform_example.tfvars"
```

このコマンドは、Terraformが管理しているリソースを削除するための計画を表示します。計画を確認した後、実際にリソースを削除するかどうかを確認されます。

2. **確認**:
`terraform destroy` コマンドを実行すると、削除されるリソースの一覧が表示され、確認プロンプトが表示されます。この確認プロンプトで `yes` と入力すると、リソースの削除が開始されます。

3. **注意事項**:
`terraform destroy` はTerraformで管理しているすべてのリソースを削除する強力なコマンドです。このコマンドを実行する前に、削除されるリソースを十分に確認してください。特に、データベースやストレージのようなデータを持つリソースに関しては、データのバックアップを取得しておくことを強くおすすめします。

上記の手順を完了すると、Terraformが管理しているリソースがすべて削除されます。
