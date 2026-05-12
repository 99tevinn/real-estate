defmodule RealEstate.Properties do
  import Ecto.Query
  alias RealEstate.Repo
  alias RealEstate.Properties.Property
  alias RealEstate.Properties.Enquiry

  # ── Queries ──────────────────────────────────────────

  def list_owner_properties(owner_id, page \\ 1) do
    Property
    |> where([p], p.owner_id == ^owner_id)
    |> order_by([p], desc: p.inserted_at)
    |> Repo.paginate(page: page)
  end

  def list_all_properties(page \\ 1) do
    Property
    |> order_by([p], desc: p.inserted_at)
    |> preload(:owner)
    |> Repo.paginate(page: page)
  end

  def list_available_properties do
    Property
    |> where([p], p.status == "available")
    |> order_by([p], desc: p.inserted_at)
    |> Repo.all()
  end

  def list_agent_listings(agent_id, page \\ 1) do
    Property
    |> where([p], p.agent_id == ^agent_id)
    |> order_by([p], desc: p.inserted_at)
    |> Repo.paginate(page: page)
  end

  def get_property!(id) do
    Repo.get!(Property, id) |> Repo.preload(:owner)
  end

  def get_owner_property!(owner_id, id) do
    Property
    |> where([p], p.id == ^id and p.owner_id == ^owner_id)
    |> Repo.one!()
  end

  def count_properties, do: Repo.aggregate(Property, :count)

  # ── Changesets ───────────────────────────────────────

  def change_property(%Property{} = property, attrs \\ %{}) do
    Property.changeset(property, attrs)
  end

  # ── Mutations ────────────────────────────────────────

  def create_property(attrs) do
    %Property{}
    |> Property.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, property} ->
        Phoenix.PubSub.broadcast(
          RealEstate.PubSub,
          "properties",
          {:new_property, property}
        )

        {:ok, property}

      error ->
        error
    end
  end

  def update_property(%Property{} = property, attrs) do
    property
    |> Property.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, property} ->
        Phoenix.PubSub.broadcast(
          RealEstate.PubSub,
          "properties",
          {:updated_property, property}
        )

        {:ok, property}

      error ->
        error
    end
  end

  def delete_property(%Property{} = property) do
    Repo.delete(property)
  end

  alias RealEstate.Properties.Enquiry

  # ── Enquiry Queries ───────────────────────────────────

  def list_buyer_enquiries(buyer_id) do
    Enquiry
    |> where([e], e.buyer_id == ^buyer_id)
    |> order_by([e], desc: e.inserted_at)
    |> preload(:property)
    |> Repo.all()
  end

  def list_owner_enquiries(owner_id) do
    Enquiry
    |> join(:inner, [e], p in assoc(e, :property))
    |> where([e, p], p.owner_id == ^owner_id)
    |> order_by([e], desc: e.inserted_at)
    |> preload([:property, :buyer])
    |> Repo.all()
  end

  def list_pending_enquiries do
    Enquiry
    |> where([e], e.status == "pending")
    |> order_by([e], desc: e.inserted_at)
    |> preload([:property, :buyer])
    |> Repo.all()
  end

  def list_all_enquiries(page \\ 1) do
    Enquiry
    |> order_by([e], desc: e.inserted_at)
    |> preload([:property, :buyer])
    |> Repo.paginate(page: page)
  end

  def get_enquiry!(id) do
    Enquiry
    |> preload([:property, :buyer])
    |> Repo.get!(id)
  end

  def count_enquiries, do: Repo.aggregate(Enquiry, :count)

  def delete_enquiry(%Enquiry{} = enquiry) do
    Repo.delete(enquiry)
  end

  # ── Enquiry  Changesets ────────────────────────────────

  def change_enquiry(%Enquiry{} = enquiry, attrs \\ %{}) do
    Enquiry.changeset(enquiry, attrs)
  end

  # ── Enquiry Mutations ─────────────────────────────────

  def create_enquiry(attrs) do
    result =
      %Enquiry{}
      |> Enquiry.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, enquiry} ->
        enquiry = Repo.preload(enquiry, [:buyer, property: [:owner, :agent]])

        Phoenix.PubSub.broadcast(
          RealEstate.PubSub,
          "enquiries",
          {:new_enquiry, enquiry}
        )

        Task.start(fn ->
          RealEstate.Mailer.Notifier.send_enquiry_notification(
            enquiry.property.owner.email,
            enquiry.property.owner.full_name || enquiry.property.owner.email,
            enquiry.buyer.full_name || enquiry.buyer.email,
            enquiry.property.title,
            enquiry.message
          )
        end)

        if enquiry.property.agent do
          Task.start(fn ->
            RealEstate.Mailer.Notifier.send_enquiry_notification(
              enquiry.property.agent.email,
              enquiry.property.agent.full_name || enquiry.property.agent.email,
              enquiry.buyer.full_name || enquiry.buyer.email,
              enquiry.property.title,
              enquiry.message
            )
          end)
        end

        {:ok, enquiry}

      error ->
        error
    end
  end

  def update_enquiry(%Enquiry{} = enquiry, attrs) do
    enquiry
    |> Enquiry.changeset(attrs)
    |> Repo.update()
  end

  def list_public_listings(filters \\ %{}, page \\ 1) do
    Property
    |> where([p], p.status == "available")
    |> filter_by_type(filters["type"])
    |> filter_by_location(filters["location"])
    |> order_by([p], desc: p.inserted_at)
    |> preload(:owner)
    |> Repo.paginate(page: page)
  end

  def get_agent_listing!(agent_id, id) do
    Property
    |> where([p], p.id == ^id and p.agent_id == ^agent_id)
    |> Repo.one!()
  end

  alias RealEstate.Properties.SavedListing

  def list_saved_listings(buyer_id) do
    SavedListing
    |> where([s], s.buyer_id == ^buyer_id)
    |> preload(:property)
    |> Repo.all()
  end

  def save_listing(attrs) do
    %SavedListing{}
    |> SavedListing.changeset(attrs)
    |> Repo.insert()
  end

  def unsave_listing(buyer_id, property_id) do
    SavedListing
    |> where([s], s.buyer_id == ^buyer_id and s.property_id == ^property_id)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      saved -> Repo.delete(saved)
    end
  end

  def search_properties(params) do
    %Property{}
    |> Repo.preload(:owner)
    |> where_min_price(params["min_price"])
    |> where_max_price(params["max_price"])
    |> filter_by_type(params["type"])
    |> filter_by_location(params["location"])
    |> order_by([p], desc: p.inserted_at)
    |> Repo.paginate(params)
  end

  def get_property_stats(params) do
    base_query =
      Property
      |> where_min_price(params["min_price"])
      |> where_max_price(params["max_price"])
      |> filter_by_location(params["location"])

    %{
      total_count: Repo.aggregate(base_query, :count, :id),
      total_value: Repo.aggregate(base_query, :sum, :price) || 0,
      avg_price: Repo.aggregate(base_query, :avg, :price) || 0
    }
  end

  defp where_min_price(query, nil), do: query
  defp where_min_price(query, price), do: from(p in query, where: p.price >= ^price)

  defp where_max_price(query, nil), do: query
  defp where_max_price(query, price), do: from(p in query, where: p.price <= ^price)

  def saved?(buyer_id, property_id) do
    SavedListing
    |> where([s], s.buyer_id == ^buyer_id and s.property_id == ^property_id)
    |> Repo.exists?()
  end

  defp filter_by_type(query, nil), do: query
  defp filter_by_type(query, ""), do: query
  defp filter_by_type(query, type), do: where(query, [p], p.type == ^type)

  defp filter_by_location(query, nil), do: query
  defp filter_by_location(query, ""), do: query

  defp filter_by_location(query, location) do
  if location != "" and !is_nil(location) do
    where(query, [p], ilike(p.location, ^"%#{location}%"))
  else
    query
  end
end
end
