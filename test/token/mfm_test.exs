defmodule MfmParser.MFMTest do
  use ExUnit.Case

  alias MfmParser.Token.MFM

  test "it returns speed in the list of parameters" do
    assert %{speed: "5s"} = MFM.to_props("$[blabla.speed=5s")
  end

  test "it returns v and h in the list of parameters" do
    assert %{v: true} = MFM.to_props("$[blabla.v")
    assert %{v: true, h: true} = MFM.to_props("$[blabla.h,v")
  end

  test "it returns fonts" do
    assert %{font: "some_font"} = MFM.to_props("$[font.some_font")
  end

  test "it returns a size for an x element" do
    assert %{size: "200%"} = MFM.to_props("$[x2")
    assert %{size: "400%"} = MFM.to_props("$[x3")
    assert %{size: "600%"} = MFM.to_props("$[x4")
    assert %{size: "100%"} = MFM.to_props("$[xqsdfqsf")
  end

  test "it returns an empty list when there are no parameters" do
    assert %{} = MFM.to_props("$[blabla")
  end

  test "it ignores unknown parameters" do
    assert %{} = MFM.to_props("$[blabla.idk")
  end
end
