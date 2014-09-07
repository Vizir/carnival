## Install and configure Devise
Following the [Devise Getting Started Guide](https://github.com/plataformatec/devise#getting-started).

## Protect Carnival Routes in a Devise Authenticated scope

```ruby 

devise_for :users

...

authenticate :user do
  mount_carnival_at '/'
  resources :people
end
```
  
## Customize Header to add CurrentUser info and SignOut link

Create a partial "carnival/_extra_header.html.haml(erb)" in you views folder

Ex.
![Extra Header Partial](https://dl.dropboxusercontent.com/u/2134454/cdn/carnival/carnival-extra-header-sample-file.png)

Sample content:
```ruby

%div.sign_out= link_to t('logout'), destroy_user_session_path, :method => :delete
%div.salute
  = link_to "#" do
    .email
      = current_user.email
    %figure
      = image_tag "", :class => "default"
``` 

Rendered Header:
![Extra Header Rendered](https://dl.dropboxusercontent.com/u/2134454/cdn/carnival/carnival-extra-header-rendered.png)

