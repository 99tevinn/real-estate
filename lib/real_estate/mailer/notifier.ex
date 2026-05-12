# lib/real_estate/mailer/notifier.ex
defmodule RealEstate.Mailer.Notifier do
  import Swoosh.Email
  alias RealEstate.Mailer

  def send_enquiry_notification(
        recipient_email,
        recipient_name,
        buyer_name,
        property_title,
        message
      ) do
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

  # lib/real_estate/mailer/notifier.ex — add this function
  def send_password_reset(email, reset_url) do
    new()
    |> to(email)
    |> from({"RealEstate App", "noreply@realestate.com"})
    |> subject("Reset Your Password")
    |> html_body("""
      <div style="font-family: sans-serif; max-width: 600px; margin: 0 auto;">
        <h3>Password Reset Request</h3>
        <p>Click the link below to reset your password. This link expires in 2 hours.</p>
        <a href="#{reset_url}"
          style="background: #2563eb; color: white; padding: 12px 24px;
                 border-radius: 6px; text-decoration: none; display: inline-block;">
          Reset Password
        </a>
        <p style="margin-top: 16px; color: #666; font-size: 14px;">
          If you did not request this, ignore this email.
        </p>
      </div>
    """)
    |> text_body("""
      Reset your password by visiting: #{reset_url}
      This link expires in 2 hours.
      If you did not request this, ignore this email.
    """)
    |> Mailer.deliver()
  end
end
