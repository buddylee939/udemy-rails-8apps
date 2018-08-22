<link rel="stylesheet" href="style.css">

# Udemy Rails 8 Apps - INSTAGRAM

## 49. launch app with pics model and controller

- rails new instagramm
- install haml, simple form, bootstrap sass, 
- bundle
- rails g model Pic title:string description:text
- rails db:migrate
- rails g controller Pics
- in pics controller create the def index action
- create pics/index.html.haml
- in routes

```
  resources :pics
  root 'pics#index'
```

## 50. ability to create posts

- in pics controller

```
  def new
    @pic = Pic.new
  end

  def create
    @pic = Pic.new(pic_params)
  end

  private

    def pic_params
      params.require(:pic).permit(:title, :description)
    end
```

- create the pics/new

```
%h1 Post Pic

= render 'form'

= link_to 'Back', root_path
```

- rails g simple_form:install --bootstrap
- create the form partial

```
= simple_form_for @pic, html: { multipart: true } do |f|
  - if @pic.errors.any?
    #errors
      %h2
      = pluralize(@pic.errors.count, 'error')
      prevented this Pic from saving
      %ul
        - @pic.errors.full_message.each do |msg|
          %li= msg
          
  .form-group
    = f.input :title, input_html: { class: 'form-control' }
  .form-group
    = f.input :description, input_html: { class: 'form-control' }

  = f.button :submit, class: 'btn btn-info'
```

## 51. displaying posts

- update the create action

```
  def create
    @pic = Pic.new(pic_params)

    if @pic.save
      redirect_to @pic, notice: 'Yess! It was posted!'
    else
      render 'new'
    end
  end
```

- update the layout/app to haml

```
!!!
%html
%head
  %title Instagramm
  = stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true 
  = javascript_include_tag 'application', 'data-turbolinks-track' => true 
  = csrf_meta_tags
%body
  -flash.each do |name, msg|
    =content_tag :div, msg, class: 'alert alert-info'
  = yield

```

- in pics controller add show, find_pic, before action

```
before_action :find_pic, only: [:show, :edit, :update, :destroy]
  def show
  end
    def find_pic
      @pic = Pic.find(params[:id])
    end
```

- create the pics/show

```
%h1= @pic.title
%p= @pic.description

= link_to 'Back', root_path
```

- in pics controller, update index action

```
  def index
    @pics = Pic.all.order('created_at DESC')
  end
```

- update index.html code to be

```
- @pics.each do |pic|
  %h2= link_to pic.title, pic
```

## 52. edit and deleting posts

- in pics controller create edit, update

```
  def edit
  end

  def update
    if @pic.update(pic_params)
      redirect_to @pic, notice: 'Congrats! Pic was updated!'
    else
      render 'edit'
    end
  end
```

- create the pics/edit file

```
%h1 Fix Pic!

= render 'form'

= link_to 'Cancel', pic_path
```

- add the edit and delete links in show page

```
%h1= @pic.title
%p= @pic.description

= link_to 'Back', root_path
= link_to 'Edit', edit_pic_path(@pic)
= link_to 'Delete', pic_path(@pic), method: :delete, data: { confirm: 'Are you sure?' }
```

- in pics controller, create destroy action

```
  def destroy
    @pic.destroy
    redirect_to root_path
  end
```

- in index add the new pic link

```
= link_to 'Gram It', new_pic_path
```

## 53. add user model and association with pics model

- add devise, bundle, restart server
- rails g devise:install
- do the todos
- rails g devise:views
- rails g devise User
- rails db:migrate
- create a new user
- in pic.rb model

```
belongs_to :user
```

- in user.rb

```
has_many :pics
```

- rails g migration add_user_id_to_pics user_id:integer:index
- rails db:migrate
- in rails console link pics with user
- in the show add the user email

```
%h1= @pic.title
%p= @pic.description
%p
Pic by
= @pic.user.email
%br/
= link_to 'Back', root_path
= link_to 'Edit', edit_pic_path(@pic)
= link_to 'Delete', pic_path(@pic), method: :delete, data: { confirm: 'Are you sure?' }
```

- in pics controller, update new and create to link current user

```
  def new
    @pic = current_user.pics.build
  end

  def create
    @pic = current_user.pics.build(pic_params)

    if @pic.save
      redirect_to @pic, notice: 'Yess! It was posted!'
    else
      render 'new'
    end
  end
```

## 54. styling and navigation to app

- rename app.css to scss
- add styling from https://github.com/CrashLearner/instagramreplica2
- add the jquery rails gem
- add to the app.js

```
//= require jquery
//= require rails-ujs
//= require bootstrap-sprockets
//= require activestorage
// require turbolinks
//= require_tree .
```

- I took out the = sign from turbolinks cuz it was causing a flicker
- update the layouts/app with the navbar

```
!!!
%html
%head
  %title Instagramm
  = stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true 
  = javascript_include_tag 'application', 'data-turbolinks-track' => true 
  = csrf_meta_tags
%body
  %nav.navbar.navbar-inverse
    .container
      .navbar-brand= link_to 'Instagramm', root_path
      
      - if user_signed_in?
        %ul.nav.navbar-nav.navbar-left
          %li= link_to 'Gram It', new_pic_path
          %li= link_to 'Settings', edit_user_registration_path
          %li= link_to 'Sign Out', destroy_user_session_path, method: :delete
      - else
        %ul.nav.navbar-nav.navbar-left
          %li= link_to 'Join', new_user_registration_path
          %li= link_to 'Log In', new_user_session_path

  .container
    -flash.each do |name, msg|
      =content_tag :div, msg, class: 'alert alert-info'
    = yield
```

## 55. style new and edit forms

- update the new page

```
.col-md-8.col-md-offset-2
  .row
    .panel.panel-default
      .panel-heading
        %h1 Post Pic
      .panel-body
        = render 'form'
```

- update the edit page

```
#edit_page.col-md-8.col-md-offset-2
  .row
    .panel.panel-default
      .panel-heading
        %h1 Fix Pic!
      .panel-body
        = render 'form'

```

## 56. image uploading - paperclip has been deprecated, we need to use activestorage

- I used active storage and credentials
- add the image as a link to the index page

```
- @pics.each do |pic|
  - if pic.featured_image.attached?
    .index-image= link_to image_tag(pic.featured_image), pic  
  %h2= link_to pic.title, pic
```

- in the edit add the photo to the form to see current image

```
.panel-body
  .current_image
    %strong.center Right now
    = image_tag @pic.featured_image
  = render 'form'
```

## 57. layout changes and styling

- add the masonry-rails gem
- bundle
- in pics.coffee

```
$ ->
  $('#pics').imagesLoaded ->
    $('#pics').masonry
      itemSelector: '.box'
      isFitWidth: true
```

- update the index page

```
.col-md-6.col-md-offset-3
  #pics.transitions-enabled
    - @pics.each do |pic|
      - if pic.featured_image.attached?
        .box.panel.panel-default
          = link_to image_tag(pic.featured_image), pic  
          %h2= link_to pic.title, pic
```

- update the show page

```
#pic_show.row
  .col-md-6.col-md-offset-3
    .panel.panel-default
      .panel.heading.pic_image    
        - if @pic.featured_image.attached?
          .image
            = image_tag @pic.featured_image
      .panel-body
        %h1= @pic.title
        %p= simple_format(@pic.description)
      .panel-footer
        .row
          .col-md-6
            %p.user
              by
              = @pic.user.email
          .col-md-6
            .btn-group.pull-right
              - if user_signed_in?              
                = link_to 'Edit', edit_pic_path(@pic), class: 'btn btn-info'
                = link_to 'Delete', pic_path(@pic), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger'
```

- add masonry require to app.js

```
//= require jquery
//= require rails-ujs
//= require bootstrap-sprockets
//= require masonry/jquery.masonry
//= require activestorage
// require turbolinks
//= require_tree .
```

## 58. upvoting/liking/thumbs up

- add the acts as votable gem
- bundle
- in terminal: rails generate acts_as_votable:migration
- rails db:migrate
- update pic.rb

```
class Pic < ApplicationRecord
  acts_as_votable
  belongs_to :user
  has_one_attached :featured_image
end
```

- update the pics in routes

```
  resources :pics do
    member do
      put 'like', to: 'pics#upvote'
    end
  end
```

- in pics controller, add authenticate and update before action

```
  before_action :find_pic, only: [:show, :edit, :update, :destroy, :upvote]
  before_action :authenticate_user!, except: [:index, :show]
```

- add the upvote action

```
  def upvote
    @pic.upvote_by current_user
    redirect_back(fallback_location: @pic)
  end
```

- add the glyphicon button to the button group in the show page

```
  .col-md-6
    .btn-group.pull-right
      = link_to like_pic_path(@pic), method: :put, class: 'btn btn-default' do
        %span.glyphicon.glyphicon-thumbs-up
        = @pic.get_upvotes.size

      - if user_signed_in?              
        = link_to 'Fix Pic', edit_pic_path(@pic), class: 'btn btn-info'
        = link_to 'Delete', pic_path(@pic), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger'
```

## 59. settings page, 60. sign up page styling, 61. log in page

- update the devise/registraions/edit page with bootstrap

```
<div class="col-md-8 col-md-offset-2">
  <div class="row">
    <div class="panel panel-default">
      <div class="panel-heading">          
        <h2>Edit <%= resource_name.to_s.humanize %></h2>      
      </div>

      <div class="panel-body">
        <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), html: { method: :put }) do |f| %>
          <%= f.error_notification %>

          <div class="form-group">
            <%= f.input :email, required: true, autofocus: true, class: 'form-control' %>

            <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
              <p>Currently waiting confirmation for: <%= resource.unconfirmed_email %></p>
            <% end %>
          </div>
          <div class="form-group">
            <%= f.input :password,
                        hint: "leave it blank if you don't want to change it",
                        required: false,
                        input_html: { autocomplete: "new-password" }, class: 'form-control' %>
          </div>                        
          <div class="form-group">              
            <%= f.input :password_confirmation,
                        required: false,
                        input_html: { autocomplete: "new-password" }, class: 'form-control' %>
          </div>                        
          <div class="form-group">              
            <%= f.input :current_password,
                        hint: "we need your current password to confirm your changes",
                        required: true,
                        input_html: { autocomplete: "current-password" }, class: 'form-control' %>
          </div>

          <div class="form-group">
            <%= f.button :submit, "Update", class: 'btn btn-info' %>
          </div>
        <% end %>
      </div>      

      <div class="panel-footer">        
        <h3>Cancel my account</h3>

        <p>Unhappy? <%= link_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete, class: 'btn btn-danger' %></p>

        <%= link_to "Back", :back, class: 'btn btn-default' %>  
      </div>    
    </div>
  </div>
</div>
```

- update devise/registrations/new

```
<div class="col-md-8 col-md-offset-2">
  <div class="row">
    <div class="panel panel-default">
      <div class="panel-heading">  
        <h2>Sign up</h2>
      </div>
      <div class="panel-body">        
        <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>
          <%= f.error_notification %>

          <div class="form-group">
            <%= f.input :email,
                        required: true,
                        autofocus: true ,
                        input_html: { autocomplete: "email" }, class: 'form-control'%>
          </div>
          <div class="form-group">
            <%= f.input :password,
                        required: true,
                        hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                        input_html: { autocomplete: "new-password" }, class: 'form-control' %>
          </div>
          <div class="form-group">                        
            <%= f.input :password_confirmation,
                        required: true,
                        input_html: { autocomplete: "new-password" }, class: 'form-control' %>                        
          </div>

          <div class="form-group">
            <%= f.button :submit, "Sign up", class: 'btn btn-info' %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  </div>
</div>          
```

- update devise/sessions/new

```
<div class="col-md-8 col-md-offset-2">
  <div class="row">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h2>Log in</h2>
      </div>
      <div class="panel-body">

        <%= simple_form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>
          <div class="form-group">
            <%= f.input :email,
                        required: false,
                        autofocus: true,
                        input_html: { autocomplete: "email" }, class: 'form-control' %>
            </div>            
          <div class="form-group">                        
            <%= f.input :password,
                        required: false,
                        input_html: { autocomplete: "current-password" }, class: 'form-control' %>
          </div>              
          <div class="form-group">                        
            <%= f.label :remember_me %>
            <%= f.check_box :remember_me, as: :boolean if devise_mapping.rememberable? %>
          </div>

          <div class="form-group">
            <%= f.button :submit, "Log in", class: 'btn btn-info' %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  </div>
</div>      
```

## 62. how to change web app layout index page with masonry

- in the index, make it a 12 column grid instead

```
.col-md-12
  #pics.transitions-enabled
    - @pics.each do |pic|
      - if pic.featured_image.attached?
        .box.panel.panel-default
          = link_to image_tag(pic.featured_image), pic  
          %h2= link_to pic.title, pic
      - else
        .box.panel.panel-default
          %h2= link_to pic.title, pic
```

## How I seeded the pics with images

```
Pic.destroy_all
num = 0

10.times do |pic|
  temp = Pic.create!(
    title: Faker::Hipster.sentence, 
    description: Faker::Hipster.paragraph(20), 
    user_id: rand(1..2)
  )
  num = pic.to_s
  temp.featured_image.attach(
    io: File.open('/Users/mac/Documents/Sites/allRailsTuts/udemy-rails-8apps/instagramm/app/assets/images/image'+num+'.png'),
    filename: 'image'+num+'.png'
  )
end
puts '10 pics have been created'
```

# The End
 
