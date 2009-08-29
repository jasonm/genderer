require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'redgreen'
require 'genderer'

class GendererTest < Test::Unit::TestCase
  should "return M for male name" do
    assert_equal "M", Genderer.gender_for("Jason")
  end

  should "return F for female name" do
    assert_equal "F", Genderer.gender_for("Lindsay")
  end

  should "be case insensitive" do
    assert_equal "M", Genderer.gender_for("jason")
    assert_equal "M", Genderer.gender_for("JASON")
  end

  should "give best match for misspelled names" do
    assert_equal "F", Genderer.gender_for("Susanna")
    assert_equal "F", Genderer.gender_for("Susssana")
  end
end
