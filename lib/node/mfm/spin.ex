defmodule MfmParser.Node.MFM.Spin do
  # keyframes_name:
  # x -> mfm-spinX
  # y -> mfm-spinY
  # _ -> mfm-spin
  #
  # direction:
  # left -> reverse
  # alternate -> alternate
  # _ -> normal
  #
  defstruct props: %{keyframes_name: "mfm-spin", direction: "normal", speed: "1.5s"}, children: []
end
