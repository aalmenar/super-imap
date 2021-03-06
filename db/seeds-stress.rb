AdminUser.new(:email => "admin@example.com", :password => "password").save

imap_provider = Plain::ImapProvider.create!(
  :code         => 'PLAIN',
  :title        => "Fake IMAP",
  :imap_host    => "127.0.0.1",
  :imap_port    => 10143,
  :imap_use_ssl => false)

def create_user(connection, n)
  connection.users.create!(
    :tag            => "User #{n}",
    :email          => "user#{n}@localhost",
    :login_username => "user#{n}@localhost",
    :login_password => "password",
    :connected_at   => Time.now)
end

def create_partner_connection(partner, imap_provider)
  partner.connections.create!(:imap_provider_id => imap_provider.id).tap do |connection|
    1000.times.each do |n|
      create_user(connection, n)
    end
  end
end

Partner.create!(
  :name            => "Partner",
  :new_mail_webhook => "ignored",
  :success_url     => "ignored",
  :failure_url     => "ignored").tap do |partner|
  create_partner_connection(partner, imap_provider)
end
