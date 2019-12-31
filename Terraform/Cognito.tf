resource "aws_cognito_user_pool" "pool" {
  name = "mypool"
  auto_verified_attributes = "email"
}
resource "aws_cognito_identity_provider" "pool_provider" {
  user_pool_id  = "${aws_cognito_user_pool.pool.id}"
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "email"
    client_id        = "your client_id"
    client_secret    = "your client_secret"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}
resource "aws_cognito_user_pool_client" "client" {
  name = "client"

  user_pool_id = "${aws_cognito_user_pool.pool.id}"
}