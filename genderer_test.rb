require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'redgreen'
require 'genderer'

class GendererTest < Test::Unit::TestCase
  context "with a new Genderer" do
    setup do
      @genderer = Genderer.new({
        "male" => {
          "JAMES"   => 40.0,
          "JOHN"    => 35.0,
          "BOBBY"   => 15.0,
          "ROBERT"  => 10.0,
          "JO"      => 5.0
        },
        "female" => {
          "MARY"     => 40.0,
          "PATRICIA" => 35.0,
          "LINDA"    => 15.0,
          "BOBBY"    => 10.0,
          "JO"       => 5.0
        }
      })
    end

    should "return male for male name" do
      assert_equal "male", @genderer.gender_for("James")
    end

    should "return female for female name" do
      assert_equal "female", @genderer.gender_for("Mary")
    end

    should "be case insensitive" do
      assert_equal "male", @genderer.gender_for("james")
      assert_equal "male", @genderer.gender_for("JAMES")
    end

    should "give best match for misspelled names" do
      assert_equal "female", @genderer.gender_for("Linda")
      assert_equal "female", @genderer.gender_for("Linnad")

      assert_equal "male", @genderer.gender_for("James")
      assert_equal "male", @genderer.gender_for("Janes")
    end

    should "give most likely match for either-gender names" do
      assert_equal "male", @genderer.gender_for("Bobby")
    end

    should "return unknown for no match" do
      assert_equal "unknown", @genderer.gender_for("Zaphod")
    end

    should "return unknown for equal match" do
      assert_equal "unknown", @genderer.gender_for("Jo")
    end
  end


  should "take distance and frequency into account for misspelled names" do
    gender_hash = {
      "male" => {
        "JERRY" => 1.0
      },
      "female" => {
        "JORRI" => 1.1
      }
    }

    genderer = Genderer.new(gender_hash)
    assert_equal "male", genderer.gender_for("Jarry")
  end
end
