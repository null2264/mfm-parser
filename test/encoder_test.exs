defmodule MfmParser.EncoderTest do
  use ExUnit.Case

  alias MfmParser.Encoder
  alias MfmParser.Node

  doctest MfmParser.Encoder

  describe "to_html" do
    test "it handles text" do
      input_tree = [%Node.Text{props: %{text: "chocolatine"}}]

      expected = "chocolatine"

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles newlines" do
      input_tree = [%Node.Newline{props: %{text: "\n"}}]

      expected = "\n"

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles flip" do
      input_tree = [
        %Node.MFM.Flip{
          children: [%Node.Text{props: %{text: "Misskey expands the world of the Fediverse"}}]
        }
      ]

      input_tree_v = [
        %Node.MFM.Flip{
          children: [%Node.Text{props: %{text: "Misskey expands the world of the Fediverse"}}],
          props: %{v: true}
        }
      ]

      input_tree_h_v = [
        %Node.MFM.Flip{
          children: [%Node.Text{props: %{text: "Misskey expands the world of the Fediverse"}}],
          props: %{v: true, h: true}
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; transform: scaleX(-1);">Misskey expands the world of the Fediverse</span>]

      expected_v =
        ~s[<span class="mfm" style="display: inline-block; transform: scaleY(-1);">Misskey expands the world of the Fediverse</span>]

      expected_h_v =
        ~s[<span class="mfm" style="display: inline-block; transform: scale(-1);">Misskey expands the world of the Fediverse</span>]

      assert Encoder.to_html(input_tree) == expected
      assert Encoder.to_html(input_tree_v) == expected_v
      assert Encoder.to_html(input_tree_h_v) == expected_h_v
    end

    test "it handles font" do
      input_tree = [
        %Node.MFM.Font{
          children: [%Node.Text{props: %{text: "Misskey expands the world of the Fediverse"}}],
          props: %{font: "fantasy"}
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; font-family: fantasy;">Misskey expands the world of the Fediverse</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles x" do
      input_tree = [
        %Node.MFM.X{
          children: [%Node.Text{props: %{text: "🍮"}}],
          props: %{size: "400%"}
        }
      ]

      expected = ~s[<span style="font-size: 400%">🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles blur" do
      input_tree = [
        %Node.MFM.Blur{
          children: [%Node.Text{props: %{text: "Misskey expands the world of the Fediverse"}}]
        }
      ]

      expected = ~s[<span class="mfm _mfm_blur_">Misskey expands the world of the Fediverse</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles jelly" do
      input_tree = [
        %Node.MFM.Jelly{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; animation: 1s linear 0s infinite normal both running mfm-rubberBand;">🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles tada" do
      input_tree = [
        %Node.MFM.Tada{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; font-size: 150%; animation: 1s linear 0s infinite normal both running mfm-tada;">🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles jump" do
      input_tree = [
        %Node.MFM.Jump{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; animation: 0.75s linear 0s infinite normal none running mfm-jump;">🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles bounce" do
      input_tree = [
        %Node.MFM.Bounce{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; animation: 0.75s linear 0s infinite normal none running mfm-bounce; transform-origin: center bottom 0px;">🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles spin" do
      input_tree_z_left = [
        %Node.MFM.Spin{
          props: %{axis: "z", direction: "left", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_x_left = [
        %Node.MFM.Spin{
          props: %{axis: "x", direction: "left", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_y_left = [
        %Node.MFM.Spin{
          props: %{axis: "y", direction: "left", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_z_alternate = [
        %Node.MFM.Spin{
          props: %{axis: "z", direction: "alternate", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_x_alternate = [
        %Node.MFM.Spin{
          props: %{axis: "x", direction: "alternate", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_y_alternate = [
        %Node.MFM.Spin{
          props: %{axis: "y", direction: "alternate", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_z_normal = [
        %Node.MFM.Spin{
          props: %{axis: "z", direction: "normal", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_x_normal = [
        %Node.MFM.Spin{
          props: %{axis: "x", direction: "normal", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_y_normal = [
        %Node.MFM.Spin{
          props: %{axis: "y", direction: "normal", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected_tree_z_left =
        ~s[<span class="mfm" style="display: inline-block; animation: 1.5s linear 0s infinite reverse none running mfm-spin;">🍮</span>]

      expected_tree_x_left =
        ~s[<span class="mfm" style="display: inline-block; animation: 1.5s linear 0s infinite reverse none running mfm-spinX;">🍮</span>]

      expected_tree_y_left =
        ~s[<span class="mfm" style="display: inline-block; animation: 1.5s linear 0s infinite reverse none running mfm-spinY;">🍮</span>]

      expected_tree_z_alternate =
        ~s[<span class="mfm" style="display: inline-block; animation: 1.5s linear 0s infinite alternate none running mfm-spin;">🍮</span>]

      expected_tree_x_alternate =
        ~s[<span class="mfm" style="display: inline-block; animation: 1.5s linear 0s infinite alternate none running mfm-spinX;">🍮</span>]

      expected_tree_y_alternate =
        ~s[<span class="mfm" style="display: inline-block; animation: 1.5s linear 0s infinite alternate none running mfm-spinY;">🍮</span>]

      expected_tree_z_normal =
        ~s[<span class="mfm" style="display: inline-block; animation: 1.5s linear 0s infinite normal none running mfm-spin;">🍮</span>]

      expected_tree_x_normal =
        ~s[<span class="mfm" style="display: inline-block; animation: 1.5s linear 0s infinite normal none running mfm-spinX;">🍮</span>]

      expected_tree_y_normal =
        ~s[<span class="mfm" style="display: inline-block; animation: 1.5s linear 0s infinite normal none running mfm-spinY;">🍮</span>]

      assert Encoder.to_html(input_tree_z_left) == expected_tree_z_left
      assert Encoder.to_html(input_tree_x_left) == expected_tree_x_left
      assert Encoder.to_html(input_tree_y_left) == expected_tree_y_left

      assert Encoder.to_html(input_tree_z_alternate) == expected_tree_z_alternate
      assert Encoder.to_html(input_tree_x_alternate) == expected_tree_x_alternate
      assert Encoder.to_html(input_tree_y_alternate) == expected_tree_y_alternate

      assert Encoder.to_html(input_tree_z_normal) == expected_tree_z_normal
      assert Encoder.to_html(input_tree_x_normal) == expected_tree_x_normal
      assert Encoder.to_html(input_tree_y_normal) == expected_tree_y_normal
    end

    test "it handles shake" do
      input_tree = [
        %Node.MFM.Shake{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; animation: 0.5s ease 0s infinite normal none running mfm-shake;">🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles twitch" do
      input_tree = [
        %Node.MFM.Twitch{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; animation: 0.5s ease 0s infinite normal none running mfm-twitch;">🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles rainbow" do
      input_tree = [
        %Node.MFM.Rainbow{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; animation: 1s linear 0s infinite normal none running mfm-rainbow;">🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles sparkle" do
      # TODO: This is not how Misskey does it and should be changed to make it work like Misskey.
      input_tree = [
        %Node.MFM.Sparkle{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; animation: 1s linear 0s infinite normal none running mfm-sparkle;">🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles rotate" do
      input_tree = [
        %Node.MFM.Rotate{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; transform: rotate(90deg); transform-origin: center center 0px;">🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles unsuported formats" do
      input_tree = [
        %Node.MFM.Undefined{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected = ~s[<span>🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles multpile nodes on the same level" do
      input_tree = [
        %Node.MFM.Rotate{
          children: [%Node.Text{props: %{text: "🍮"}}]
        },
        %Node.Text{props: %{text: "pain au chocolat"}},
        %Node.MFM.Font{
          children: [%Node.Text{props: %{text: "Misskey expands the world of the Fediverse"}}],
          props: %{font: "fantasy"}
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; transform: rotate(90deg); transform-origin: center center 0px;">🍮</span>pain au chocolat<span class="mfm" style="display: inline-block; font-family: fantasy;">Misskey expands the world of the Fediverse</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles nesting" do
      input_tree = [
        %Node.MFM.Rotate{
          children: [
            %Node.MFM.Font{
              children: [%Node.Text{props: %{text: "🍮"}}],
              props: %{font: "fantasy"}
            }
          ]
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; transform: rotate(90deg); transform-origin: center center 0px;"><span class="mfm" style="display: inline-block; font-family: fantasy;">🍮</span></span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it shouldn't have duplicate styles" do
      input_tree = [
        %Node.MFM.Sparkle{
          children: [%Node.Text{props: %{text: "🍮"}}]
        },
        %Node.MFM.Sparkle{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span class="mfm" style="display: inline-block; animation: 1s linear 0s infinite normal none running mfm-sparkle;">🍮</span><span class="mfm" style="display: inline-block; animation: 1s linear 0s infinite normal none running mfm-sparkle;">🍮</span>]

      assert Encoder.to_html(input_tree) == expected
    end

    test "it handles complex nesting of nodes" do
      input_tree = [
        %MfmParser.Node.Text{props: %{text: "It's not "}},
        %MfmParser.Node.MFM.Twitch{
          children: [%MfmParser.Node.Text{props: %{text: "chocolatine"}}],
          props: %{speed: "0.2s"}
        },
        %MfmParser.Node.Newline{props: %{text: "\n"}},
        %MfmParser.Node.Text{props: %{text: "it's "}},
        %MfmParser.Node.MFM.X{
          children: [
            %MfmParser.Node.MFM.Spin{
              children: [%MfmParser.Node.Text{props: %{text: "pain"}}],
              props: %{direction: "normal", axis: "z", speed: "1s"}
            },
            %MfmParser.Node.Text{props: %{text: " "}},
            %MfmParser.Node.MFM.Rainbow{
              children: [%MfmParser.Node.Text{props: %{text: "au"}}],
              props: %{speed: "2s"}
            },
            %MfmParser.Node.Text{props: %{text: " "}},
            %MfmParser.Node.MFM.Jump{
              children: [%MfmParser.Node.Text{props: %{text: "chocolat"}}],
              props: %{speed: "0.5s"}
            }
          ],
          props: %{size: "600%"}
        }
      ]

      expected =
        "It's not <span class=\"mfm\" style=\"display: inline-block; animation: 0.2s ease 0s infinite normal none running mfm-twitch;\">chocolatine</span>\nit's <span style=\"font-size: 600%\"><span class=\"mfm\" style=\"display: inline-block; animation: 1s linear 0s infinite normal none running mfm-spin;\">pain</span> <span class=\"mfm\" style=\"display: inline-block; animation: 2s linear 0s infinite normal none running mfm-rainbow;\">au</span> <span class=\"mfm\" style=\"display: inline-block; animation: 0.5s linear 0s infinite normal none running mfm-jump;\">chocolat</span></span>"

      assert Encoder.to_html(input_tree) == expected
    end

    test "it should be able to go from mfm-text input to html output" do
      input =
        "It's not $[twitch.speed=0.2s chocolatine]\nit's $[x4 $[spin.speed=1s pain] $[rainbow.speed=2s au] $[jump.speed=0.5s chocolat]]"

      expected =
        "It's not <span class=\"mfm\" style=\"display: inline-block; animation: 0.2s ease 0s infinite normal none running mfm-twitch;\">chocolatine</span>\nit's <span style=\"font-size: 600%\"><span class=\"mfm\" style=\"display: inline-block; animation: 1s linear 0s infinite normal none running mfm-spin;\">pain</span> <span class=\"mfm\" style=\"display: inline-block; animation: 2s linear 0s infinite normal none running mfm-rainbow;\">au</span> <span class=\"mfm\" style=\"display: inline-block; animation: 0.5s linear 0s infinite normal none running mfm-jump;\">chocolat</span></span>"

      assert Encoder.to_html(input) == expected
    end
  end
end
