defmodule ElixirRootsWeb.CompressionController do
  use ElixirRootsWeb, :controller

  def convert(image, format \\ "avif") do
    Mogrify.format(image, format)
    |> Mogrify.save(in_place: true)
  end

  def compress(image, max_size, max_try \\ 10) do
    file_size = File.stat!(image.path()).size
    shrink_delta = min(max_size * 1000 / file_size, 1)
    # Shrink factor is variable to reduce the number of tries to attain the max_size needed
    shrink_factor = cond do
      shrink_delta >= 1 -> 1
      shrink_delta < 0.5 -> 0.65
      shrink_delta < 0.65 -> 0.75
      shrink_delta < 0.75 -> 0.85
      shrink_delta < 1 -> 0.95
    end

    cond do
      file_size <= max_size * 1000 -> image
      # We tried enough, no need
      max_try == 0 -> image
      true ->
        %{width: image_width, height: image_height} = Mogrify.identify(image.path())
        Mogrify.resize(image, "#{ceil(image_width * shrink_factor)}x#{ceil(image_height * shrink_factor)}")
        |> Mogrify.save(in_place: true)
        |> compress(max_size, max_try - 1)
    end
  end
end
