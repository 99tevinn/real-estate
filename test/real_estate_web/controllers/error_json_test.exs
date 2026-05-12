defmodule RealEstateWeb.ErrorJSONTest do
  use RealEstateWeb.ConnCase, async: true

  test "renders 404" do
    assert RealEstateWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert RealEstateWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
