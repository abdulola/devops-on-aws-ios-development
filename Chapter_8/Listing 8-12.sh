set +x
echo "Set fastlane variables..."
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

echo "Retrieving Secrets from AWS Secret Manager..."
ACCESS_KEY_ID=`aws secretsmanager get-secret-value --secret-id fastlane-secrets --query SecretString --output text | jq -r .AWS_ACCESS_KEY_ID`
SECRET_ACCESS_KEY=`aws secretsmanager get-secret-value --secret-id fastlane-secrets --query SecretString --output text | jq -r .AWS_SECRET_ACCESS_KEY`
MATCH_PASSWORD=`aws secretsmanager get-secret-value --secret-id fastlane-secrets --query SecretString --output text | jq -r .MATCH_PASSWORD`
S3_BUCKET=`aws secretsmanager get-secret-value --secret-id fastlane-secrets --query SecretString --output text | jq -r .S3_BUCKET`
APP_IDENTIFIER=`aws secretsmanager get-secret-value --secret-id fastlane-secrets --query SecretString --output text | jq -r .APP_IDENTIFIER`
APPLE_DEVELOPER_USERNAME=`aws secretsmanager get-secret-value --secret-id fastlane-secrets --query SecretString --output text | jq -r .APPLE_DEVELOPER_USERNAME`
TEAM_ID=`aws secretsmanager get-secret-value --secret-id fastlane-secrets --query SecretString --output text | jq -r .TEAM_ID`

echo "Setting fastlane match environment variables..."
export AWS_ACCESS_KEY_ID=$ACCESS_KEY_ID && export AWS_SECRET_ACCESS_KEY=$SECRET_ACCESS_KEY && export MATCH_PASSWORD=$MATCH_PASSWORD && export S3_BUCKET=$S3_BUCKET && export APP_IDENTIFIER=$APP_IDENTIFIER && export APPLE_DEVELOPER_USERNAME=$APPLE_DEVELOPER_USERNAME && export TEAM_ID=$TEAM_ID

echo "Starting Fastlane..."
fastlane test
fastlane build