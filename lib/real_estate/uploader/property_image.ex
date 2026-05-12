defmodule RealEstate.Uploaders.PropertyImage do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]
  @allowed_extensions ~w(.jpg .jpeg .png .webp)

  def validate({file, _}) do
    ext = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@allowed_extensions, ext)
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 400x300^ -gravity center -extent 400x300"}
  end

  def storage_dir(_version, {_file, scope}) do
    "priv/static/uploads/properties/#{scope.id}"
  end
end
