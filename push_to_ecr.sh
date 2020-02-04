#!/usr/bin/env bash

# [ECRプッシュ対象のイメージ名]
image_name=mlops_env_sample_ml_base


# [docker-compose buildする．]
docker-compose -f docker-compose.yml build --no-cache


# [引数の設定]
# プロファイルの指定
profile_to_push=$1
if [ "$profile_to_push" == "" ]
then
    profile_to_push="default"
fi

# 使用するソースimage（ai_environment_jupyter）のタグ名を引数から受け取る．（何もなければlatest）
tag=$2
if [ "$tag" == "" ]
then
    tag="latest"
fi


# [ECR操作用関数の定義]
# TODO: 関数の引数番号の与え方が正しいかチェック
function get_account () {
    account=$(aws sts get-caller-identity --profile $1 --query Account --output text)
    if [ $? -ne 0 ]
    then
        exit 255
    fi
    echo "$account"
}
function get_region () {
    region=$(aws configure --profile $1 get region)
    region=${region:-ap-northeast-1}
    echo "$region"
}


# [Push先に関する設定]
# Push先アカウント取得
account=$(get_account ${profile_to_push}) 

# Push先のRegion取得
region=$(get_region ${profile_to_push})

# ログイン
$(aws ecr get-login --profile ${profile_to_push} --region ${region} --no-include-email)

# Push先にリポジトリが存在してなかったら作成
aws ecr describe-repositories --profile ${profile_to_push} --repository-names "${image_name}" > /dev/null 2>&1
if [ $? -ne 0 ]
then
    aws ecr create-repository --profile ${profile_to_push} --repository-name "${image_name}" > /dev/null
fi


# [SageMaker用imageをECRへpush]
fullname="${account}.dkr.ecr.${region}.amazonaws.com/${image_name}:${tag}"
docker tag ${image_name} ${fullname}
docker push ${fullname}