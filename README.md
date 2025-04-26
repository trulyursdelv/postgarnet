## Postgarnet :mailbox:

[![Postgarnet](https://img.shields.io/gem/v/postgarnet?label=Postgarnet&color=dc3519)](https://rubygems.org/gems/postgarnet)

Postgarnet is a lightweight SMTP client for sending emails through Gmail using Ruby. It allows full control over server connection and message headers, supports templates with dynamic payloads, and works out of the box with minimal setup.

```ruby
# Username will be converted to johndoe@gmail.com
mail = Postgarnet.new(username: "johndoe", password: "...")

mail.from("Postgarnet Team")
mail.to("janedoe@gmail.com")
mail.subject("Hello from Postgarnet")

# Or alternatively, {recipient}
# which automatically use mail.to
mail.content("Hello {name},<br>This is a test message from Postgarnet.", {
  name: mail.to
})

mail.connect
mail.send do
  puts "Email sent"
end
```

## Installation

Postgarnet is available on [rubygems](https://rubygems.org/gems/postgarnet). To install Postgarnet, install it on gem:

```
gem install postgarnet
```

## Documentation

Read the full documentation [here](https://clover-stallion-989.notion.site/Postgarnet-1e114c1327fb804d94bcf1306b2d3758?pvs=73).
