require "test_helper"

class SiteAdminsControllerTest < ActionDispatch::IntegrationTest
  test "should get member_editor" do
    get site_admins_member_editor_url
    assert_response :success
  end
end
