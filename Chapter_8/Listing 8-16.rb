
lane :testflight do
  api_key = app_store_connect_api_key(
    key_id: ENV["KEY_ID"],
    issuer_id: ENV["APP_STORE_CONNECT_ISSUER_ID"],
    key_content: ENV["API_KEY"],
    duration: 1200,
    in_house: false,
    is_key_content_base64: true, 
  )

  pilot(
    api_key: api_key,
 )
  end
