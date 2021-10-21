set +x

export TEAM_ID=`aws secretsmanager get-secret-value --secret-id fastlane-secrets --query SecretString --profile devops-ios --output text | jq -r .TEAM_ID`

/usr/bin/xcodebuild build-for-testing -scheme SampleApp -destination generic/platform=iOS DEVELOPMENT_TEAM=$TEAM_ID -allowProvisioningUpdates -derivedDataPath /Users/abdullahi/.jenkins/workspace/TestProject
mkdir Payload && cp -r /Users/abdullahi/.jenkins/workspace/TestProject/Build/Products/Debug-iphoneos/SampleApp.app Payload/
zip -r Payload.zip Payload && mv Payload.zip SampleApp.ipa