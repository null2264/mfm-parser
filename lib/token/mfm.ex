defmodule MfmParser.Token.MFM do
  def to_props(opts_string) when is_binary(opts_string) do
    if opts_string =~ "." do
      Regex.replace(~r/^.*\./u, opts_string, "")
      |> String.trim()
      |> String.split(",")
      |> Enum.reduce(%{}, fn opt, acc ->
        acc
        |> Map.merge(
          cond do
            opt =~ "speed" ->
              %{speed: String.replace(opt, "speed=", "")}

            opt =~ "v" ->
              %{v: true}

            opt =~ "h" ->
              %{h: true}

            opt =~ "x" ->
              %{keyframes_name: "mfm-spinX"}

            opt =~ "y" ->
              %{keyframes_name: "mfm-spinY"}

            opt =~ "left" ->
              %{direction: "reverse"}

            opt =~ "alternate" ->
              %{direction: "alternate"}

            true ->
              if Regex.match?(~r/^\$\[font/, opts_string) do
                %{font: opt}
              else
                %{}
              end
          end
        )
      end)
    else
      if opts_string =~ "$[x" do
        %{
          size:
            case opts_string |> String.replace("$[x", "") |> String.trim() do
              "2" -> "200%"
              "3" -> "400%"
              "4" -> "600%"
              _ -> "100%"
            end
        }
      else
        %{}
      end
    end
  end
end
