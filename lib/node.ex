defmodule MfmParser.Node.Text do
  defstruct props: %{text: ""}
end

defmodule MfmParser.Node.Newline do
  defstruct props: %{text: "\n"}
end

defmodule MfmParser.Node.MFM.Blur do
  defstruct props: %{}, children: []
end

defmodule MfmParser.Node.MFM.Bounce do
  defstruct props: %{speed: "0.75s"}, children: []
end

defmodule MfmParser.Node.MFM.Flip do
  defstruct props: %{v: false, h: false}, children: []
end

defmodule MfmParser.Node.MFM.Font do
  defstruct props: %{font: nil}, children: []
end

defmodule MfmParser.Node.MFM.Jelly do
  defstruct props: %{speed: "1s"}, children: []
end

defmodule MfmParser.Node.MFM.Jump do
  defstruct props: %{speed: "0.75s"}, children: []
end

defmodule MfmParser.Node.MFM.Rainbow do
  defstruct props: %{speed: "1s"}, children: []
end

defmodule MfmParser.Node.MFM.Rotate do
  defstruct props: %{}, children: []
end

defmodule MfmParser.Node.MFM.Shake do
  defstruct props: %{speed: "0.5s"}, children: []
end

defmodule MfmParser.Node.MFM.Sparkle do
  defstruct props: %{}, children: []
end

defmodule MfmParser.Node.MFM.Spin do
  defstruct props: %{axis: "z", direction: "normal", speed: "1.5s"}, children: []
end

defmodule MfmParser.Node.MFM.Tada do
  defstruct props: %{speed: "1s"}, children: []
end

defmodule MfmParser.Node.MFM.Twitch do
  defstruct props: %{speed: "0.5s"}, children: []
end

defmodule MfmParser.Node.MFM.Undefined do
  defstruct props: %{}, children: []
end

defmodule MfmParser.Node.MFM.X do
  defstruct props: %{size: nil}, children: []
end
