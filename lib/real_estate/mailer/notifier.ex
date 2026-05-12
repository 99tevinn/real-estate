# lib/real_estate/mailer/notifier.ex
defmodule RealEstate.Mailer.Notifier do
  import Swoosh.Email
  alias RealEstate.Mailer

  def send_enquiry_notification(recipient_email, recipient_name, buyer_name, property_title, message) do
    new()
    |> to({recipient_name, recipient_email})
    |> from({"RealEstate App", "noreply@realestate.com"})
    |> subject("New Enquiry for #{property_title}")
    |> html_body("""
      <div style="font-family: sans-serif; max-width: 600px; margin: 0 auto;">
        <h3>Hello #{recipient_name},</h3>
        <p><strong>#{buyer_name}</strong> just sent an enquiry about <strong>#{property_title}</strong>.</p>
        <div style="background: #f5f5f5; padding: 16px; border-radius: 8px; margin: 16px 0;">
          <p><strong>Message:</strong></p>
          <p>#{message}</p>
        </div>
        <p>Log in to your dashboard to respond.</p>
      </div>
    """)
    |> text_body("""
      Hello #{recipient_name},

      #{buyer_name} sent an enquiry about #{property_title}.

      Message: #{message}

      Log in to respond.
    """)
    |> Mailer.deliver()
  end
end
