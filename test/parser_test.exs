defmodule MfmParser.ParserTest do
  use ExUnit.Case
  alias MfmParser.Parser

  describe "single element input" do
    test "it can handle an empty string as input" do
      input = ""

      assert Parser.parse(input) == []
    end

    test "it can handle text as input" do
      input = "pain au chocolat"

      output = [%MfmParser.Node.Text{props: %{text: "pain au chocolat"}}]

      assert Parser.parse(input) == output
    end

    test "it can handle a newline as input" do
      input = "\n"

      output = [%MfmParser.Node.Newline{props: %{text: "\n"}}]

      assert Parser.parse(input) == output
    end

    test "it can handle a flip element" do
      input_default = "$[flip ]"
      input_v = "$[flip.v ]"
      input_hv = "$[flip.h,v ]"

      output_default = [
        %MfmParser.Node.MFM.Flip{
          props: %{
            v: false,
            h: false
          },
          children: []
        }
      ]

      output_v = [
        %MfmParser.Node.MFM.Flip{
          props: %{
            v: true,
            h: false
          },
          children: []
        }
      ]

      output_hv = [
        %MfmParser.Node.MFM.Flip{
          props: %{
            v: true,
            h: true
          },
          children: []
        }
      ]

      assert Parser.parse(input_default) == output_default
      assert Parser.parse(input_v) == output_v
      assert Parser.parse(input_hv) == output_hv
    end

    test "it can handle a font element" do
      input = "$[font.serif ]"

      output = [
        %MfmParser.Node.MFM.Font{
          props: %{
            font: "serif"
          },
          children: []
        }
      ]

      assert Parser.parse(input) == output
    end

    test "it can handle an x element" do
      input2 = "$[x2 ]"
      input3 = "$[x3 ]"
      input4 = "$[x4 ]"

      output2 = [
        %MfmParser.Node.MFM.X{
          props: %{
            size: "200%"
          },
          children: []
        }
      ]

      output3 = [
        %MfmParser.Node.MFM.X{
          props: %{
            size: "400%"
          },
          children: []
        }
      ]

      output4 = [
        %MfmParser.Node.MFM.X{
          props: %{
            size: "600%"
          },
          children: []
        }
      ]

      assert Parser.parse(input2) == output2
      assert Parser.parse(input3) == output3
      assert Parser.parse(input4) == output4
    end

    test "it can handle a blur element" do
      input = "$[blur ]"

      output = [
        %MfmParser.Node.MFM.Blur{
          props: %{},
          children: []
        }
      ]

      assert Parser.parse(input) == output
    end

    test "it can handle a jelly element" do
      input_default = "$[jelly ]"

      output_default = [
        %MfmParser.Node.MFM.Jelly{
          props: %{
            speed: "1s"
          },
          children: []
        }
      ]

      input_speed = "$[jelly.speed=20s ]"

      output_speed = [
        %MfmParser.Node.MFM.Jelly{
          props: %{
            speed: "20s"
          },
          children: []
        }
      ]

      assert Parser.parse(input_default) == output_default
      assert Parser.parse(input_speed) == output_speed
    end

    test "it can handle a tada element" do
      input_default = "$[tada ]"

      output_default = [
        %MfmParser.Node.MFM.Tada{
          props: %{
            speed: "1s"
          },
          children: []
        }
      ]

      input_speed = "$[tada.speed=20s ]"

      output_speed = [
        %MfmParser.Node.MFM.Tada{
          props: %{
            speed: "20s"
          },
          children: []
        }
      ]

      assert Parser.parse(input_default) == output_default
      assert Parser.parse(input_speed) == output_speed
    end

    test "it can handle a jump element" do
      input_default = "$[jump ]"

      output_default = [
        %MfmParser.Node.MFM.Jump{
          props: %{
            speed: "0.75s"
          },
          children: []
        }
      ]

      input_speed = "$[jump.speed=20s ]"

      output_speed = [
        %MfmParser.Node.MFM.Jump{
          props: %{
            speed: "20s"
          },
          children: []
        }
      ]

      assert Parser.parse(input_default) == output_default
      assert Parser.parse(input_speed) == output_speed
    end

    test "it can handle a bounce element" do
      input_default = "$[bounce ]"

      output_default = [
        %MfmParser.Node.MFM.Bounce{
          props: %{
            speed: "0.75s"
          },
          children: []
        }
      ]

      input_speed = "$[bounce.speed=20s ]"

      output_speed = [
        %MfmParser.Node.MFM.Bounce{
          props: %{
            speed: "20s"
          },
          children: []
        }
      ]

      assert Parser.parse(input_default) == output_default
      assert Parser.parse(input_speed) == output_speed
    end

    test "it can handle a spin element" do
      input_default = "$[spin ]"

      output_default = [
        %MfmParser.Node.MFM.Spin{
          props: %{
            keyframes_name: "mfm-spin",
            direction: "normal",
            speed: "1.5s"
          },
          children: []
        }
      ]

      input_left = "$[spin.left ]"

      output_left = [
        %MfmParser.Node.MFM.Spin{
          props: %{
            keyframes_name: "mfm-spin",
            direction: "reverse",
            speed: "1.5s"
          },
          children: []
        }
      ]

      input_alternate = "$[spin.alternate ]"

      output_alternate = [
        %MfmParser.Node.MFM.Spin{
          props: %{
            keyframes_name: "mfm-spin",
            direction: "alternate",
            speed: "1.5s"
          },
          children: []
        }
      ]

      input_x = "$[spin.x ]"

      output_x = [
        %MfmParser.Node.MFM.Spin{
          props: %{
            keyframes_name: "mfm-spinX",
            direction: "normal",
            speed: "1.5s"
          },
          children: []
        }
      ]

      input_x_left = "$[spin.x,left ]"

      output_x_left = [
        %MfmParser.Node.MFM.Spin{
          props: %{
            keyframes_name: "mfm-spinX",
            direction: "reverse",
            speed: "1.5s"
          },
          children: []
        }
      ]

      input_x_alternate = "$[spin.x,alternate ]"

      output_x_alternate = [
        %MfmParser.Node.MFM.Spin{
          props: %{
            keyframes_name: "mfm-spinX",
            direction: "alternate",
            speed: "1.5s"
          },
          children: []
        }
      ]

      input_y = "$[spin.y ]"

      output_y = [
        %MfmParser.Node.MFM.Spin{
          props: %{
            keyframes_name: "mfm-spinY",
            direction: "normal",
            speed: "1.5s"
          },
          children: []
        }
      ]

      input_y_left = "$[spin.y,left ]"

      output_y_left = [
        %MfmParser.Node.MFM.Spin{
          props: %{
            keyframes_name: "mfm-spinY",
            direction: "reverse",
            speed: "1.5s"
          },
          children: []
        }
      ]

      input_y_alternate = "$[spin.y,alternate ]"

      output_y_alternate = [
        %MfmParser.Node.MFM.Spin{
          props: %{
            keyframes_name: "mfm-spinY",
            direction: "alternate",
            speed: "1.5s"
          },
          children: []
        }
      ]

      input_speed = "$[spin.speed=20s ]"

      output_speed = [
        %MfmParser.Node.MFM.Spin{
          props: %{
            keyframes_name: "mfm-spin",
            direction: "normal",
            speed: "20s"
          },
          children: []
        }
      ]

      assert Parser.parse(input_default) == output_default
      assert Parser.parse(input_left) == output_left
      assert Parser.parse(input_alternate) == output_alternate
      assert Parser.parse(input_x) == output_x
      assert Parser.parse(input_x_left) == output_x_left
      assert Parser.parse(input_x_alternate) == output_x_alternate
      assert Parser.parse(input_y) == output_y
      assert Parser.parse(input_y_left) == output_y_left
      assert Parser.parse(input_y_alternate) == output_y_alternate
      assert Parser.parse(input_speed) == output_speed
    end

    test "it can handle a shake element" do
      input_default = "$[shake ]"

      output_default = [
        %MfmParser.Node.MFM.Shake{
          props: %{
            speed: "0.5s"
          },
          children: []
        }
      ]

      input_speed = "$[shake.speed=20s ]"

      output_speed = [
        %MfmParser.Node.MFM.Shake{
          props: %{
            speed: "20s"
          },
          children: []
        }
      ]

      assert Parser.parse(input_default) == output_default
      assert Parser.parse(input_speed) == output_speed
    end

    test "it can handle a twitch element" do
      input_default = "$[twitch ]"

      output_default = [
        %MfmParser.Node.MFM.Twitch{
          props: %{
            speed: "0.5s"
          },
          children: []
        }
      ]

      input_speed = "$[twitch.speed=20s ]"

      output_speed = [
        %MfmParser.Node.MFM.Twitch{
          props: %{
            speed: "20s"
          },
          children: []
        }
      ]

      assert Parser.parse(input_default) == output_default
      assert Parser.parse(input_speed) == output_speed
    end

    test "it can handle a rainbow element" do
      input_default = "$[rainbow ]"

      output_default = [
        %MfmParser.Node.MFM.Rainbow{
          props: %{
            speed: "1s"
          },
          children: []
        }
      ]

      input_speed = "$[rainbow.speed=20s ]"

      output_speed = [
        %MfmParser.Node.MFM.Rainbow{
          props: %{
            speed: "20s"
          },
          children: []
        }
      ]

      assert Parser.parse(input_default) == output_default
      assert Parser.parse(input_speed) == output_speed
    end

    test "it can handle a sparkle element" do
      input = "$[sparkle ]"

      output = [
        %MfmParser.Node.MFM.Sparkle{
          props: %{},
          children: []
        }
      ]

      assert Parser.parse(input) == output
    end

    test "it can handle a rotate element" do
      input = "$[rotate ]"

      output = [
        %MfmParser.Node.MFM.Rotate{
          props: %{},
          children: []
        }
      ]

      assert Parser.parse(input) == output
    end

    test "it can handle an undefined element" do
      input = "$[blabla ]"

      output = [
        %MfmParser.Node.MFM.Undefined{
          props: %{},
          children: []
        }
      ]

      assert Parser.parse(input) == output
    end
  end

  #   test "it returns a parse tree with content" do
  #     input = "$[twitch twitching text]"
  # 
  #     output = [
  #       %MfmParser.MFM.Twitch{
  #         props: %{
  #           speed: "20s"
  #         },
  #         children: [
  #           %MfmParser.Text{
  #             props: %{
  #               text: "twitching text"
  #             }
  #           }
  #         ]
  #       }
  #     ]
  # 
  #     assert Parser.parse(input) == {:ok, output}
  #   end
  # 
  #   test "it returns a parse tree with mutiple entries and contents" do
  #     input = "look at this $[twitch twitching text]"
  # 
  #     output = [
  #       %MfmParser.Text{
  #         props: %{
  #           text: "look at this "
  #         }
  #       },
  #       %MfmParser.MFM.Twitch{
  #         props: %{
  #           speed: "20s"
  #         },
  #         children: [
  #           %MfmParser.Text{
  #             props: %{
  #               text: "twitching text"
  #             }
  #           }
  #         ]
  #       }
  #     ]
  # 
  #     assert Parser.parse(input) == {:ok, output}
  #   end

  ######################
  #
  # OLD STUFF BELOW
  #
  ######################
  #

  #   test "it returns a parse tree with text" do
  #     input = "blablabla"
  # 
  #     output = [
  #       %{
  #         type: "text",
  #         content: "blablabla"
  #       }
  #     ]
  # 
  #     assert Parser.parse(input) == {:ok, output}
  #   end
  # 
  #   test "it returns a parse tree with mutiple entries and contents and text" do
  #     input = "<h1>My thought on Chocolatines</h1><div>Also known as <i>Pain au chocolat</i>.</div>"
  # 
  #     output = [
  #       %{
  #         type: "html",
  #         name: "h1",
  #         attributes: "",
  #         content: [%{type: "text", content: "My thought on Chocolatines"}]
  #       },
  #       %{
  #         type: "html",
  #         name: "div",
  #         attributes: "",
  #         content: [
  #           %{type: "text", content: "Also known as "},
  #           %{
  #             type: "html",
  #             name: "i",
  #             attributes: "",
  #             content: [%{type: "text", content: "Pain au chocolat"}]
  #           },
  #           %{type: "text", content: "."}
  #         ]
  #       }
  #     ]
  # 
  #     assert Parser.parse(input) == {:ok, output}
  #   end
  # 
  #   test "it returns a parse tree with mutiple entries and contents and text and newlines" do
  #     input =
  #       "<h1>My thought on Chocolatines</h1><div>Also \nknown as <br><i>Pain au chocolat</i>.</div>"
  # 
  #     output = [
  #       %{
  #         type: "html",
  #         name: "h1",
  #         attributes: "",
  #         content: [%{type: "text", content: "My thought on Chocolatines"}]
  #       },
  #       %{
  #         type: "html",
  #         name: "div",
  #         attributes: "",
  #         content: [
  #           %{type: "text", content: "Also "},
  #           %{type: "newline"},
  #           %{type: "text", content: "known as "},
  #           %{type: "newline"},
  #           %{
  #             type: "html",
  #             name: "i",
  #             attributes: "",
  #             content: [%{type: "text", content: "Pain au chocolat"}]
  #           },
  #           %{type: "text", content: "."}
  #         ]
  #       }
  #     ]
  # 
  #     assert Parser.parse(input) == {:ok, output}
  #   end
  # 
  #   test "it returns a parse tree with mfm format $[<name_and_values> <content>]" do
  #     input = "<div>blabla$[flip $[x2 :blobcatwitch:]]bla$[twitch.speed=20s yadayada]</div>"
  # 
  #     output = [
  #       %{
  #         type: "html",
  #         attributes: "",
  #         name: "div",
  #         content: [
  #           %{type: "text", content: "blabla"},
  #           %{
  #             type: "mfm",
  #             name: "flip",
  #             content: [
  #               %{
  #                 type: "mfm",
  #                 name: "x2",
  #                 content: [
  #                   %{type: "text", content: ":blobcatwitch:"}
  #                 ]
  #               }
  #             ]
  #           },
  #           %{type: "text", content: "bla"},
  #           %{
  #             type: "mfm",
  #             name: "twitch.speed=20s",
  #             content: [%{type: "text", content: "yadayada"}]
  #           }
  #         ]
  #       }
  #     ]
  # 
  #     assert Parser.parse(input) == {:ok, output}
  #   end
  # 
  #   test "it understands html attributes" do
  #     input = "<some_tag some_attribute=./something.jpeg other_atr></some_tag>"
  # 
  #     output = [
  #       %{
  #         type: "html",
  #         name: "some_tag",
  #         attributes: "some_attribute=./something.jpeg other_atr",
  #         content: []
  #       }
  #     ]
  # 
  #     assert Parser.parse(input) == {:ok, output}
  #   end
end
