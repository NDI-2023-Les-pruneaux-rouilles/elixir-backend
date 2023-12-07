defmodule ElixirRootsWeb.ImagesController do
  use ElixirRootsWeb, :controller

  def create(conn, params) do
    render(conn, :show, test: "test")
  end

  def show(conn, %{"id" => id}) do
    render(conn, :show, id: id)
  end
end
