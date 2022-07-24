defmodule MfmParserTest do
  use ExUnit.Case
  doctest MfmParser

  alias MfmParser.Node

  describe "to_html" do
    test "it handles text" do
      input_tree = [%Node.Text{props: %{text: "chocolatine"}}]

      expected = "chocolatine"

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles newlines" do
      input_tree = [%Node.Newline{props: %{text: "\n"}}]

      expected = "\n"

      assert MfmParser.to_html(input_tree) == expected
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
        ~s[<span style="display: inline-block; transform: scaleX(-1);">Misskey expands the world of the Fediverse</span>]

      expected_v =
        ~s[<span style="display: inline-block; transform: scaleY(-1);">Misskey expands the world of the Fediverse</span>]

      expected_h_v =
        ~s[<span style="display: inline-block; transform: scale(-1);">Misskey expands the world of the Fediverse</span>]

      assert MfmParser.to_html(input_tree) == expected
      assert MfmParser.to_html(input_tree_v) == expected_v
      assert MfmParser.to_html(input_tree_h_v) == expected_h_v
    end

    test "it handles font" do
      input_tree = [
        %Node.MFM.Font{
          children: [%Node.Text{props: %{text: "Misskey expands the world of the Fediverse"}}],
          props: %{font: "fantasy"}
        }
      ]

      expected =
        ~s[<span style="display: inline-block; font-family: fantasy;">Misskey expands the world of the Fediverse</span>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles x" do
      input_tree = [
        %Node.MFM.X{
          children: [%Node.Text{props: %{text: "🍮"}}],
          props: %{size: "400%"}
        }
      ]

      expected = ~s[<span font-size: "400%">🍮</span>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles blur" do
      input_tree = [
        %Node.MFM.Blur{
          children: [%Node.Text{props: %{text: "Misskey expands the world of the Fediverse"}}]
        }
      ]

      expected =
        ~s[<span class="_mfm_blur_">Misskey expands the world of the Fediverse</span><style>._mfm_blur_ { filter: blur(6px); transition: filter .3s; } ._mfm_blur_:hover { filter: blur(0px); }</style>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles jelly" do
      input_tree = [
        %Node.MFM.Jelly{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span style="display: inline-block; animation: 1s linear 0s infinite normal both running mfm-rubberBand;">🍮</span><style>@keyframes mfm-rubberBand { 0% { transform:scaleZ(1) } 30% { transform:scale3d(1.25,.75,1) } 40% { transform:scale3d(.75,1.25,1) } 50% { transform:scale3d(1.15,.85,1) } 65% { transform:scale3d(.95,1.05,1) } 75% { transform:scale3d(1.05,.95,1) } to { transform:scaleZ(1) }}</style>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles tada" do
      input_tree = [
        %Node.MFM.Tada{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span style="display: inline-block; font-size: 150%; animation: 1s linear 0s infinite normal both running tada;">🍮</span><style>@keyframes tada { 0% { transform: scaleZ(1); } 10%, 20% { transform: scale3d(.9,.9,.9) rotate3d(0,0,1,-3deg); } 30%, 50%, 70%, 90% { transform: scale3d(1.1,1.1,1.1) rotate3d(0,0,1,3deg); } 40%, 60%, 80% { transform: scale3d(1.1,1.1,1.1) rotate3d(0,0,1,-3deg); } 100% { transform: scaleZ(1); }}</style>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles jump" do
      input_tree = [
        %Node.MFM.Jump{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span style="display: inline-block; animation: 0.75s linear 0s infinite normal none running mfm-jump;">🍮</span><style>@keyframes mfm-jump { 0% { transform:translateY(0) } 25% { transform:translateY(-16px) } 50% { transform:translateY(0) } 75% { transform:translateY(-8px) } to { transform:translateY(0) }}</style>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles bounce" do
      input_tree = [
        %Node.MFM.Bounce{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span style="display: inline-block; animation: 0.75s linear 0s infinite normal none running mfm-bounce; transform-origin: center bottom 0px;">🍮</span><style>@keyframes mfm-bounce { 0% { transform:translateY(0) scale(1) } 25% { transform:translateY(-16px) scale(1) }  50% { transform:translateY(0) scale(1) } 75% { transform:translateY(0) scale(1.5,.75) } to { transform:translateY(0) scale(1) }}</style>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles spin" do
      input_tree_spin_reverse = [
        %Node.MFM.Spin{
          props: %{keyframes_name: "mfm-spin", direction: "reverse", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_spinx_reverse = [
        %Node.MFM.Spin{
          props: %{keyframes_name: "mfm-spinX", direction: "reverse", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_spiny_reverse = [
        %Node.MFM.Spin{
          props: %{keyframes_name: "mfm-spinY", direction: "reverse", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_spin_alternate = [
        %Node.MFM.Spin{
          props: %{keyframes_name: "mfm-spin", direction: "alternate", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_spinx_alternate = [
        %Node.MFM.Spin{
          props: %{keyframes_name: "mfm-spinX", direction: "alternate", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_spiny_alternate = [
        %Node.MFM.Spin{
          props: %{keyframes_name: "mfm-spinY", direction: "alternate", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_spin_normal = [
        %Node.MFM.Spin{
          props: %{keyframes_name: "mfm-spin", direction: "normal", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_spinx_normal = [
        %Node.MFM.Spin{
          props: %{keyframes_name: "mfm-spinX", direction: "normal", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      input_tree_spiny_normal = [
        %Node.MFM.Spin{
          props: %{keyframes_name: "mfm-spinY", direction: "normal", speed: "1.5s"},
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected_tree_spin_reverse =
        ~s[<span style="display: inline-block; animation: 1.5s linear 0s infinite reverse none running mfm-spin;">🍮</span><style>@keyframes mfm-spin { 0% { transform:rotate(0) } to { transform:rotate(360deg) }}</style>]

      expected_tree_spinx_reverse =
        ~s[<span style="display: inline-block; animation: 1.5s linear 0s infinite reverse none running mfm-spinX;">🍮</span><style>@keyframes mfm-spinX { 0% { transform:perspective(128px) rotateX(0) } to { transform:perspective(128px) rotateX(360deg) }}</style>]

      expected_tree_spiny_reverse =
        ~s[<span style="display: inline-block; animation: 1.5s linear 0s infinite reverse none running mfm-spinY;">🍮</span><style>@keyframes mfm-spinY { 0% { transform:perspective(128px) rotateY(0) } to { transform:perspective(128px) rotateY(360deg) }}</style>]

      expected_tree_spin_alternate =
        ~s[<span style="display: inline-block; animation: 1.5s linear 0s infinite alternate none running mfm-spin;">🍮</span><style>@keyframes mfm-spin { 0% { transform:rotate(0) } to { transform:rotate(360deg) }}</style>]

      expected_tree_spinx_alternate =
        ~s[<span style="display: inline-block; animation: 1.5s linear 0s infinite alternate none running mfm-spinX;">🍮</span><style>@keyframes mfm-spinX { 0% { transform:perspective(128px) rotateX(0) } to { transform:perspective(128px) rotateX(360deg) }}</style>]

      expected_tree_spiny_alternate =
        ~s[<span style="display: inline-block; animation: 1.5s linear 0s infinite alternate none running mfm-spinY;">🍮</span><style>@keyframes mfm-spinY { 0% { transform:perspective(128px) rotateY(0) } to { transform:perspective(128px) rotateY(360deg) }}</style>]

      expected_tree_spin_normal =
        ~s[<span style="display: inline-block; animation: 1.5s linear 0s infinite normal none running mfm-spin;">🍮</span><style>@keyframes mfm-spin { 0% { transform:rotate(0) } to { transform:rotate(360deg) }}</style>]

      expected_tree_spinx_normal =
        ~s[<span style="display: inline-block; animation: 1.5s linear 0s infinite normal none running mfm-spinX;">🍮</span><style>@keyframes mfm-spinX { 0% { transform:perspective(128px) rotateX(0) } to { transform:perspective(128px) rotateX(360deg) }}</style>]

      expected_tree_spiny_normal =
        ~s[<span style="display: inline-block; animation: 1.5s linear 0s infinite normal none running mfm-spinY;">🍮</span><style>@keyframes mfm-spinY { 0% { transform:perspective(128px) rotateY(0) } to { transform:perspective(128px) rotateY(360deg) }}</style>]

      assert MfmParser.to_html(input_tree_spin_reverse) == expected_tree_spin_reverse
      assert MfmParser.to_html(input_tree_spinx_reverse) == expected_tree_spinx_reverse
      assert MfmParser.to_html(input_tree_spiny_reverse) == expected_tree_spiny_reverse

      assert MfmParser.to_html(input_tree_spin_alternate) == expected_tree_spin_alternate
      assert MfmParser.to_html(input_tree_spinx_alternate) == expected_tree_spinx_alternate
      assert MfmParser.to_html(input_tree_spiny_alternate) == expected_tree_spiny_alternate

      assert MfmParser.to_html(input_tree_spin_normal) == expected_tree_spin_normal
      assert MfmParser.to_html(input_tree_spinx_normal) == expected_tree_spinx_normal
      assert MfmParser.to_html(input_tree_spiny_normal) == expected_tree_spiny_normal
    end

    test "it handles shake" do
      input_tree = [
        %Node.MFM.Shake{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span style="display: inline-block; animation: 0.5s ease 0s infinite normal none running mfm-shake;">🍮</span><style>@keyframes mfm-shake { 0% { transform:translate(-3px,-1px) rotate(-8deg) } 5% { transform:translateY(-1px) rotate(-10deg) } 10% { transform:translate(1px,-3px) rotate(0) } 15% { transform:translate(1px,1px) rotate(11deg) } 20% { transform:translate(-2px,1px) rotate(1deg) } 25% { transform:translate(-1px,-2px) rotate(-2deg) } 30% { transform:translate(-1px,2px) rotate(-3deg) } 35% { transform:translate(2px,1px) rotate(6deg) } 40% { transform:translate(-2px,-3px) rotate(-9deg) } 45% { transform:translateY(-1px) rotate(-12deg) } 50% { transform:translate(1px,2px) rotate(10deg) } 55% { transform:translateY(-3px) rotate(8deg) } 60% { transform:translate(1px,-1px) rotate(8deg) } 65% { transform:translateY(-1px) rotate(-7deg) } 70% { transform:translate(-1px,-3px) rotate(6deg) } 75% { transform:translateY(-2px) rotate(4deg) } 80% { transform:translate(-2px,-1px) rotate(3deg) } 85% { transform:translate(1px,-3px) rotate(-10deg) } 90% { transform:translate(1px) rotate(3deg) } 95% { transform:translate(-2px) rotate(-3deg) } to { transform:translate(2px,1px) rotate(2deg) }}</style>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles twitch" do
      input_tree = [
        %Node.MFM.Twitch{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span style="display: inline-block; animation: 0.5s ease 0s infinite normal none running mfm-twitch;">🍮</span><style>@keyframes mfm-twitch { 0% { transform:translate(7px,-2px) } 5% { transform:translate(-3px,1px) } 10% { transform:translate(-7px,-1px) } 15% { transform:translateY(-1px) } 20% { transform:translate(-8px,6px) } 25% { transform:translate(-4px,-3px) } 30% { transform:translate(-4px,-6px) } 35% { transform:translate(-8px,-8px) } 40% { transform:translate(4px,6px) } 45% { transform:translate(-3px,1px) } 50% { transform:translate(2px,-10px) } 55% { transform:translate(-7px) } 60% { transform:translate(-2px,4px) } 65% { transform:translate(3px,-8px) } 70% { transform:translate(6px,7px) } 75% { transform:translate(-7px,-2px) } 80% { transform:translate(-7px,-8px) } 85% { transform:translate(9px,3px) } 90% { transform:translate(-3px,-2px) } 95% { transform:translate(-10px,2px) } to { transform:translate(-2px,-6px) }}</style>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles rainbow" do
      input_tree = [
        %Node.MFM.Rainbow{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span style="display: inline-block; animation: 1s linear 0s infinite normal none running mfm-rainbow;">🍮</span><style>@keyframes mfm-rainbow { 0% { filter:hue-rotate(0deg) contrast(150%) saturate(150%) } to { filter:hue-rotate(360deg) contrast(150%) saturate(150%) }}</style>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles sparkle" do
      # TODO: This is not how Misskey does it and should be changed to make it work like Misskey.
      input_tree = [
        %Node.MFM.Sparkle{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span style="display: inline-block; animation: 1s linear 0s infinite normal none running mfm-sparkle;">🍮</span><style>@keyframes mfm-sparkle { 0% { filter: brightness(100%) } to { filter: brightness(300%) }}</style>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles rotate" do
      input_tree = [
        %Node.MFM.Rotate{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected =
        ~s[<span style="display: inline-block; transform: rotate(90deg); transform-origin: center center 0px;">🍮</span>]

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it handles unsuported formats" do
      input_tree = [
        %Node.MFM.Undefined{
          children: [%Node.Text{props: %{text: "🍮"}}]
        }
      ]

      expected = ~s[<span>🍮</span>]

      assert MfmParser.to_html(input_tree) == expected
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
        ~s[<span style="display: inline-block; transform: rotate(90deg); transform-origin: center center 0px;">🍮</span>pain au chocolat<span style="display: inline-block; font-family: fantasy;">Misskey expands the world of the Fediverse</span>]

      assert MfmParser.to_html(input_tree) == expected
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
        ~s[<span style="display: inline-block; transform: rotate(90deg); transform-origin: center center 0px;"><span style="display: inline-block; font-family: fantasy;">🍮</span></span>]

      assert MfmParser.to_html(input_tree) == expected
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
        ~s[<span style="display: inline-block; animation: 1s linear 0s infinite normal none running mfm-sparkle;">🍮</span><span style="display: inline-block; animation: 1s linear 0s infinite normal none running mfm-sparkle;">🍮</span><style>@keyframes mfm-sparkle { 0% { filter: brightness(100%) } to { filter: brightness(300%) }}</style>]

      assert MfmParser.to_html(input_tree) == expected
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
              props: %{direction: "normal", keyframes_name: "mfm-spin", speed: "1s"}
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
        "It's not <span style=\"display: inline-block; animation: 0.2s ease 0s infinite normal none running mfm-twitch;\">chocolatine</span>\nit's <span font-size: \"600%\"><span style=\"display: inline-block; animation: 1s linear 0s infinite normal none running mfm-spin;\">pain</span> <span style=\"display: inline-block; animation: 2s linear 0s infinite normal none running mfm-rainbow;\">au</span> <span style=\"display: inline-block; animation: 0.5s linear 0s infinite normal none running mfm-jump;\">chocolat</span></span><style>@keyframes mfm-jump { 0% { transform:translateY(0) } 25% { transform:translateY(-16px) } 50% { transform:translateY(0) } 75% { transform:translateY(-8px) } to { transform:translateY(0) }}@keyframes mfm-rainbow { 0% { filter:hue-rotate(0deg) contrast(150%) saturate(150%) } to { filter:hue-rotate(360deg) contrast(150%) saturate(150%) }}@keyframes mfm-spin { 0% { transform:rotate(0) } to { transform:rotate(360deg) }}@keyframes mfm-twitch { 0% { transform:translate(7px,-2px) } 5% { transform:translate(-3px,1px) } 10% { transform:translate(-7px,-1px) } 15% { transform:translateY(-1px) } 20% { transform:translate(-8px,6px) } 25% { transform:translate(-4px,-3px) } 30% { transform:translate(-4px,-6px) } 35% { transform:translate(-8px,-8px) } 40% { transform:translate(4px,6px) } 45% { transform:translate(-3px,1px) } 50% { transform:translate(2px,-10px) } 55% { transform:translate(-7px) } 60% { transform:translate(-2px,4px) } 65% { transform:translate(3px,-8px) } 70% { transform:translate(6px,7px) } 75% { transform:translate(-7px,-2px) } 80% { transform:translate(-7px,-8px) } 85% { transform:translate(9px,3px) } 90% { transform:translate(-3px,-2px) } 95% { transform:translate(-10px,2px) } to { transform:translate(-2px,-6px) }}</style>"

      assert MfmParser.to_html(input_tree) == expected
    end

    test "it should be able to go from mfm-text input to html output" do
      input =
        "It's not $[twitch.speed=0.2s chocolatine]\nit's $[x4 $[spin.speed=1s pain] $[rainbow.speed=2s au] $[jump.speed=0.5s chocolat]]"

      expected =
        "It's not <span style=\"display: inline-block; animation: 0.2s ease 0s infinite normal none running mfm-twitch;\">chocolatine</span>\nit's <span font-size: \"600%\"><span style=\"display: inline-block; animation: 1s linear 0s infinite normal none running mfm-spin;\">pain</span> <span style=\"display: inline-block; animation: 2s linear 0s infinite normal none running mfm-rainbow;\">au</span> <span style=\"display: inline-block; animation: 0.5s linear 0s infinite normal none running mfm-jump;\">chocolat</span></span><style>@keyframes mfm-jump { 0% { transform:translateY(0) } 25% { transform:translateY(-16px) } 50% { transform:translateY(0) } 75% { transform:translateY(-8px) } to { transform:translateY(0) }}@keyframes mfm-rainbow { 0% { filter:hue-rotate(0deg) contrast(150%) saturate(150%) } to { filter:hue-rotate(360deg) contrast(150%) saturate(150%) }}@keyframes mfm-spin { 0% { transform:rotate(0) } to { transform:rotate(360deg) }}@keyframes mfm-twitch { 0% { transform:translate(7px,-2px) } 5% { transform:translate(-3px,1px) } 10% { transform:translate(-7px,-1px) } 15% { transform:translateY(-1px) } 20% { transform:translate(-8px,6px) } 25% { transform:translate(-4px,-3px) } 30% { transform:translate(-4px,-6px) } 35% { transform:translate(-8px,-8px) } 40% { transform:translate(4px,6px) } 45% { transform:translate(-3px,1px) } 50% { transform:translate(2px,-10px) } 55% { transform:translate(-7px) } 60% { transform:translate(-2px,4px) } 65% { transform:translate(3px,-8px) } 70% { transform:translate(6px,7px) } 75% { transform:translate(-7px,-2px) } 80% { transform:translate(-7px,-8px) } 85% { transform:translate(9px,3px) } 90% { transform:translate(-3px,-2px) } 95% { transform:translate(-10px,2px) } to { transform:translate(-2px,-6px) }}</style>"

      assert MfmParser.to_html(input) == expected
    end

    # I would like to have options
    #     * as much as possible in the span vs only a class and everything in style
    #     * with or without style
    # 
  end
end
