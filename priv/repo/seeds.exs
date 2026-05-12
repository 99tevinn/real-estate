# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RealEstate.Repo.insert!(%RealEstate.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# priv/repo/seeds.exs
alias RealEstate.Repo
alias RealEstate.Accounts.User
alias RealEstate.Accounts
alias RealEstate.Properties
alias RealEstate.Properties.Enquiry

# # password_hash = "$2b$12$K7N.mF1.0RR3.Y7O3U3O.Ou1O1O1O1O1O1O1O1O1O1O1O1O1O1O1O"

# Repo.insert!(%User{
#   email: "tevinodiwuor@gmail.com",
#   password_hash: password_hash,
#   role: "admin",
#   full_name: "Tevin Odiwuor"
# })

{:ok, admin} = Accounts.register_user(%{
  "full_name" => "System Admin",
  "email"     => "admin@realestate.com",
  "password"  => "Admin1234!",
  "role"      => "admin"
})
IO.puts("✅ Admin created: #{admin.email}")

# ── Agent ────────────────────────────────────────────
{:ok, agent} = Accounts.register_user(%{
  "full_name" => "Jane Agent",
  "email"     => "agent@realestate.com",
  "password"  => "Agent1234!",
  "role"      => "agent"
})
IO.puts("✅ Agent created: #{agent.email}")

# ── Owner ────────────────────────────────────────────
{:ok, owner} = Accounts.register_user(%{
  "full_name" => "John Owner",
  "email"     => "owner@realestate.com",
  "password"  => "Owner1234!",
  "role"      => "owner"
})
IO.puts("✅ Owner created: #{owner.email}")

# ── Buyer ────────────────────────────────────────────
{:ok, buyer} = Accounts.register_user(%{
  "full_name" => "Mary Buyer",
  "email"     => "buyer@realestate.com",
  "password"  => "Buyer1234!",
  "role"      => "buyer"
})
IO.puts("✅ Buyer created: #{buyer.email}")

# ── Properties ───────────────────────────────────────
{:ok, prop1} = Properties.create_property(%{
  "title"       => "3 Bedroom Apartment in Westlands",
  "description" => "Spacious apartment with parking and gym access.",
  "location"    => "Westlands, Nairobi",
  "price"       => 8500000,
  "type"        => "sale",
  "status"      => "available",
  "owner_id"    => owner.id
})
IO.puts("✅ Property created: #{prop1.title}")

{:ok, prop2} = Properties.create_property(%{
  "title"       => "2 Bedroom Apartment in Kilimani",
  "description" => "Modern apartment close to schools and malls.",
  "location"    => "Kilimani, Nairobi",
  "price"       => 45000,
  "type"        => "rent",
  "status"      => "available",
  "owner_id"    => owner.id
})
IO.puts("✅ Property created: #{prop2.title}")

{:ok, prop3} = Properties.create_property(%{
  "title"       => "Commercial Space in CBD",
  "description" => "Prime commercial space in Nairobi CBD.",
  "location"    => "CBD, Nairobi",
  "price"       => 120000,
  "type"        => "rent",
  "status"      => "available",
  "owner_id"    => owner.id,
  "agent_id"    => agent.id
})
IO.puts("✅ Property created: #{prop3.title}")

# ── Enquiry ──────────────────────────────────────────
{:ok, _enq} =
  Properties.create_enquiry(%{
    "message" => "Hi, I am interested in this property. Is it still available?",
    "property_id" => prop1.id,
    "buyer_id" => buyer.id
  })

IO.puts("✅ Enquiry created")

IO.puts("\n🎉 Seeding complete!")
IO.puts("Admin:  admin@realestate.com / Admin1234!")
IO.puts("Agent:  agent@realestate.com / Agent1234!")
IO.puts("Owner:  owner@realestate.com / Owner1234!")
IO.puts("Buyer:  buyer@realestate.com / Buyer1234!")
