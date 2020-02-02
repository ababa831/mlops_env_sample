# mlops_env_sample
MLOps等で利用するML環境サンプル

## 準備

### AWS CLI 環境設定

`mlops_env_sample`ディレクトリ配下に`/env_settings/.env`を作成し，以下の通り環境変数を設定する

```.env
# develop環境
AWS_ACCESS_KEY_ID_DEV={devlop環境のアクセスキーID}
AWS_SECRET_ACCESS_KEY_DEV={devlop環境のシークレットキーID}

# staging環境
AWS_ACCESS_KEY_ID_STG
AWS_SECRET_ACCESS_KEY_STG

# production環境
AWS_ACCESS_KEY_ID_PRD
AWS_SECRET_ACCESS_KEY_PRD

REGION
```

### （Optional）ECRにbuildしたコンテナイメージをUpload

SageMakerやCircleCIのベースイメージ等をECRに登録しておきたい場合．

`mlops_env_sample`ディレクトリ配下の`push_to_ecr.sh`を実行

```
$ chmod +x push_to_ecr.sh
$ ./push_to_ecr.sh {profile名(指定しない場合は'default')} {コンテナイメージのtag名}
```