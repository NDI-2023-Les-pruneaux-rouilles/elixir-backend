defmodule ElixirRootsWeb.ImagesController do
  alias ElixirRootsWeb.CompressionController
  require Logger
  use ElixirRootsWeb, :controller

  def create(conn, %{"file" => upload}) do
    file = File.read!(upload.path)
    hash = Blake3.hash(file)
      |> Base.url_encode64

    if Cachex.exists?(:cdn_cache, {hash, nil}) |> elem(1) do
      Logger.info("#{hash} already stored in :cdn_cache")
    else
      Cachex.put!(:cdn_cache, {hash, nil}, {upload.filename, file})
    end
    Cachex.put!(:cdn_index, upload.filename, hash)

    conn
    |> put_status(200)
    |> json(%{filename: upload.filename, hash: hash, url: "#{conn.scheme}://#{conn.host}:#{conn.port}/cdn/images/by-hash/#{hash}"})
  end

  def show(conn, params) do
    if params["name"] == nil do
      conn
      |> put_status(400)
      |> put_view(json: ElixirRootsWeb.ErrorJSON)
      |> render(:"400")
    end

    hash = Cachex.get!(:cdn_index, params["name"])
    if hash == nil do
      conn
      |> put_status(404)
      |> put_view(json: ElixirRootsWeb.ErrorJSON)
      |> render(:"404")
    end

    if compressed_result = Cachex.get!(:cdn_cache, {hash, params["max_size"]}) do
      {compressed_filename, _file} = compressed_result
      if compressed_filename != params["name"] do
        redirect(conn, to: "/cdn/images/#{compressed_filename}?max_size=#{params["max_size"]}")
      else
        show_by_hash(conn, %{"hash" => hash, "max_size" => params["max_size"]})
      end
    else
      show_by_hash(conn, %{"hash" => hash, "max_size" => params["max_size"]})
    end
  end

  def show_by_hash(conn, params) do
    if params["hash"] == nil do
      conn
      |> put_status(400)
      |> put_view(json: ElixirRootsWeb.ErrorJSON)
      |> render(:"400")
    else
      compressed_result = Cachex.get!(:cdn_cache, {params["hash"], params["max_size"]})
      if compressed_result == nil and not (Cachex.exists?(:cdn_cache, {params["hash"], nil}) |> elem(1)) do
        conn
          |> put_status(404)
          |> put_view(json: ElixirRootsWeb.ErrorJSON)
          |> render(:"404")
      else
        if cached_compressed_result = Cachex.get!(:cdn_cache, {params["hash"], params["max_size"]}) do
          {filename, file} = cached_compressed_result
          Logger.info("#{filename} with #{params["hash"]} (max_size #{params["max_size"]}) already stored in :cdn_cache")
          send_download(conn, {:binary, file}, filename: filename, disposition: :inline)
        else
          {filename, file} = Cachex.get!(:cdn_cache, {params["hash"], nil})
          {_pid, temp_path} = Temp.open!()
          File.write!(temp_path, file)

          extension = "avif"
          new_filename = "#{Path.basename(filename, Path.extname(filename))}.#{extension}"
          new_image = Mogrify.open(temp_path)
          |> CompressionController.convert(extension)
          |> CompressionController.compress(Integer.parse(params["max_size"]) |> elem(0))
          |> Mogrify.save(in_place: true)
          Cachex.put!(:cdn_cache, {params["hash"], params["max_size"]}, {new_filename, File.read!(new_image.path())})
          Cachex.put!(:cdn_index, new_filename, params["hash"])

          redirect(conn, to: "/cdn/images/#{new_filename}?max_size=#{params["max_size"]}")
        end
      end
    end
  end
end
