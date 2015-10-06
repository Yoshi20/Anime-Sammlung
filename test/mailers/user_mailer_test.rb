require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "anime_changed" do
    mail = UserMailer.anime_changed
    assert_equal "Anime changed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
