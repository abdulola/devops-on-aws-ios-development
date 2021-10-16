lane :build do
    match(
      type: "appstore",
      storage_mode: "s3",
      s3_bucket: ENV["S3_BUCKET"],
      s3_access_key: ENV["AWS_ACCESS_KEY_ID"],
      s3_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      app_identifier: ENV["APP_IDENTIFIER"],
      username: ENV["APPLE_DEVELOPER_USERNAME"],
      team_id: ENV["TEAM_ID"]
    )
    increment_build_number(build_number: ENV["BUILD_ID"])
    gym(project: "SampleApp.xcodeproj")
  end

lane :test do
    scan(project: "SampleApp.xcodeproj",
              devices: ["iPhone Xs"])
  end