<link rel="stylesheet" href="style.css">

# Udemy Rails 8 Apps - TUMBLR

## 35. create post model, controller

- rails new tumblr
- cd tumblr
- rails generate controller posts
- in posts controller add the index action and new action
- in routes add: resources :posts, root "posts#index"
- create the file posts/index.html.erb
- create the posts/new file and add the form code:

```
<h1>Make Something</h1>

<%= form_for :post, url: posts_path do |f| %>
  <p>
    <%= f.label :title %> <br>
    <%= f.text_field :title %>
  </p>
  <p>
    <%= f.label :body %> <br>
    <%= f.text_area :body %>
  </p>
  <p>
    <%= f.submit %>
  </p>
<% end %>
```

- rails g model Post title:string body:text
- rails db:migrate

## 36. ability to create and show posts

- in post controller, add the new, create and private actions, and before action

```
before_action :find_post, only: [:show, :edit, :update, :destroy]
  def new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  private

    def find_doc
      @doc = Doc.find(params[:id])
    end

    def doc_params
      params.require(:doc).permit(:title, :content)
    end
```

- create the posts/show page with the code

```
<h1 class="title">
  <%= @post.title %>
</h1>

<p class="date">
  Submitted <%= time_ago_in_words(@post.created_at) %> ago
</p>

<p class="body">
  <%= @post.body %>
</p>
```

- refresh and test it out

## 37. display all posts in sequence

- in posts controller, update the index action

```
  def index
    @posts = Post.all.order('created_at DESC')
  end
```

- in the posts/index add the code

```
<% @posts.each do |post| %>
  <div class="post_wrapper">
    <h2 class="title"><%= link_to post.title, post %></h2>
    <p class="date"><%= time_ago_in_words(post.created_at) %> ago</p>
  </div>
<% end %>
```

## 38. navigation, styling, and structure of application

- rename app.css to scss
- import styling from https://github.com/CrashLearner/TumblrSourceCode
- add the normalize.css
- in the layouts/app add the google font

```
<%= stylesheet_link_tag 'application', 'http://fonts.googleapis.com/css?family=Raleway:400,700' %>
```

- add the favicon

```
<%= favicon_link_tag 'favicon.ico' %>
```

- add the favicon.ico in assets/images
- update the layout/app to be

```
<!DOCTYPE html>
<html>
  <head>
    <title>Tumblr</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    <%= stylesheet_link_tag 'application', 'http://fonts.googleapis.com/css?family=Raleway:400,700' %>
    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
    <%= favicon_link_tag 'favicon.ico' %>
  </head>

  <body>
    <div id="sidebar">
      <ul>
        <li class="category"><%= link_to 'Tumblr', root_path %></li>
        <li><%= link_to 'Posts', root_path %></li>
        <li>About</li>
      </ul>
      <p class="sign_in">User Login</p>
    </div>

    <div id="main_content">
      <div id="header">
        <p>Post Feed</p>
        <div class="buttons">
          <button class="button"><%= link_to 'Make Post', new_post_path %></button>
          <button class="button">Log Out</button>
        </div>
      </div>

      <% flash.each do |name, msg| %>
        <%= content_tag(:div, msg, class: 'alert') %>
      <% end %>
      <%= yield %>
    </div>

  </body>
</html>
```

- update the posts/new

```
<div id="page_wrapper">
  <h1>Make Something</h1>

  <%= form_for :post, url: posts_path do |f| %>
    <p>
      <%= f.label :title %> <br>
      <%= f.text_field :title %>
    </p>
    <p>
      <%= f.label :body %> <br>
      <%= f.text_area :body %>
    </p>
    <p>
      <%= f.submit %>
    </p>
  <% end %>  
</div>

```

- update the show

```
<div id="post_content">
  <h1 class="title">
    <%= @post.title %>
  </h1>

  <p class="date">
    Submitted <%= time_ago_in_words(@post.created_at) %> ago
  </p>

  <p class="body">
    <%= @post.body %>
  </p>  
</div>
```

## 39. add validation to posts (i.e. set post parameters)

- update post.rb model

```
class Post < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true
end
```

- update new action in post controller

```
  def new
    @post = Post.new
  end
```

- adding the error messages to the new form

```
    <% if @post.errors.any? %>
      <div id="errors">
        <h2><%= pluralize(@post.errors.count, "error") %> stopped this post from saving</h2>
        <ul>
          <% @post.errors.full_messages.each do |msg| %>
            <li><%= msg %></li>
          <% end %>
        </ul>
      </div>
    <% end %>
```

- refresh and test it out

## 40. edit and delete post functionality (complete CRUD)

- create the form partial

```
  <%= form_for @post do |f| %>
    <% if @post.errors.any? %>
      <div id="errors">
        <h2><%= pluralize(@post.errors.count, "error") %> stopped this post from saving</h2>
        <ul>
          <% @post.errors.full_messages.each do |msg| %>
            <li><%= msg %></li>
          <% end %>
        </ul>
      </div>
    <% end %>
    <p>
      <%= f.label :title %> <br>
      <%= f.text_field :title %>
    </p>
    <p>
      <%= f.label :body %> <br>
      <%= f.text_area :body %>
    </p>
    <p>
      <%= f.submit %>
    </p>
  <% end %>  
```

- update the new file

```
<div id="page_wrapper">
  <h1>Make Something</h1>

  <%= render 'form' %>
</div>

```

- create the edit file

```
<div id="page_wrapper">
  <h1>Fix Post</h1>

  <%= render 'form' %>
</div>

```

- in the show page add the edit link

```
  <p class="date">
    Submitted <%= time_ago_in_words(@post.created_at) %> ago |
    <%= link_to 'Edit', edit_post_path(@post) %>
  </p>
```

- update the update cation

```
  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end
```

- in posts controller, update the destroy

```
  def destroy
    @post.destroy
    redirect_to root_path
  end
```

- in show add the delete link

```
  <p class="date">
    Submitted <%= time_ago_in_words(@post.created_at) %> ago |
    <%= link_to 'Edit', edit_post_path(@post) %> |
    <%= link_to 'Delete', post_path(@post), method: :delete, data: { confirm: 'Are you sure?'} %>
  </p>
```

## 41. add comments to posts page

- rails g model Comment name:string body:text post_id:integer
- rails db:migrate
- in comment.rb

```
belongs_to :post
```

- in post.rb

```
has_many :comments
```

- in routes nest the comments with posts

```
  resources :posts do
    resources :comments
  end
```

- rails g controller Comments
- in comments controller

```
class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    redirect_to post_path(@post)
  end

  private

    def comment_params
      params.require(:comment).permit(:name, :body)
    end
end
```

- create the comments/_comment.html.erb partial

```
<div class="comment clearfix">
  <div class="comment_content">
    <p class="comment_name"><strong><%= comment.name %></strong></p>
    <p class="comment_body"><%= comment.body %></p>
    <p class="comment_title"><%= time_ago_in_words(comment.created_at) %> Ago</p>
  </div>
</div>
```

- create the comments/_form.html.erb

```
<%= form_for([@post, @post.comments.build]) do |f| %>
  <p>
    <%= f.label :name %> <br>
    <%= f.text_field :name %>
  </p>
  <p>
    <%= f.label :body %> <br>
    <%= f.text_area :body %>
  </p>
  <br>
  <p>
    <%= f.submit %>
  </p>
<% end %>
```

- in the show page, under the body add the comments

```
  <div id="comments">
    <h2><%= @post.comments.count %> Comments</h2>
    <%= render @post.comments %>
    <h3>Join Discussion: </h3>
    <%= render "comments/form" %>
  </div>
```

## 42. delete function for comments and 43. comments and post dependency

- in the comments/comment partial add the delete link

```
  <p><%= link_to 'Delete', [comment.post, comment], method: :delete, class: 'button', data: { confirm: 'Are you sure?'} %></p>
```

- update the comments controller with the destroy, find post and before action

```
class CommentsController < ApplicationController
  before_action :find_post, only: [:create, :destroy]
  def create
    @comment = @post.comments.create(comment_params)
    redirect_to post_path(@post)
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy

    redirect_to post_path(@post)
  end

  private

    def comment_params
      params.require(:comment).permit(:name, :body)
    end

    def find_post
      @post = Post.find(params[:post_id])
    end
end
```

- in post.rb update the has many comments

```
has_many :comments, dependent: :destroy
```

## 44. static page - about page

- rails g controller pages
- in routes

```
get '/about', to: 'pages#about'
```

- create the pages/about.html.erb
- in pages controller add the action

```
  def about
  end
```

- add the code in the about.html

```
<div id="page_wrapper">
  <div id="profile_image">
    <%= image_tag 'profile.jpeg' %>
  </div>

  <div id="content">
    <h1>It's Mr. Stick Figure</h1>
    <p>
      Lorem ipsum dolor amet artisan heirloom beard small batch craft beer leggings pop-up. Whatever hammock iPhone actually single-origin coffee selfies kogi man braid wolf asymmetrical health goth succulents four dollar toast food truck. Distillery gluten-free live-edge fanny pack crucifix, selfies bitters put a bird on it. Tote bag schlitz brooklyn vice, beard you probably haven't heard of them squid hoodie sriracha cray roof party. VHS migas banjo, 8-bit shabby chic single-origin coffee sartorial listicle blue bottle glossier pinterest pug.

      Vexillologist you probably haven't heard of them chambray polaroid schlitz. Kickstarter listicle readymade, literally kombucha glossier neutra skateboard copper mug authentic franzen fam venmo. Dreamcatcher etsy williamsburg truffaut, pop-up bushwick VHS subway tile organic. 90's sriracha typewriter air plant roof party banh mi.
    </p>
  </div>
</div>
```

- in the application layout add the about link

```
<li><%= link_to 'About', about_path %></li>
```

- in the layout/app add the if block under header

```
    <% if current_page?(root_path) %>
      <p>Post Feed</p>
    <% elsif current_page?(about_path) %>
      <p>My Site</p>
    <% else %>
      <%= link_to 'Back to Post Feed', root_path %>
    <% end %>
```

## 45. add users to app and 46. user restrictions

- add devise gem
- bundle
- rails g devise:install    
- do the devise todos
- rails g devise:views
- rails g devise User
- rails db:migrate
- create a new user
- add page wrapper to devise/sessions/new
- in posts controller add the authenticate before action

```
before_action :authenticate_user!, except: [:index, :show]
```

- add page wrapper to devise/registrations new and edit
- in layout/app update the log in and log out buttons

```
    <% if !user_signed_in? %>
        <p class="sign_in"><%= link_to 'User Login', new_user_session_path %></p>
    <% end %>   
    <% if user_signed_in? %>        
      <div class="buttons">
        <button class="button"><%= link_to 'Make Post', new_post_path %></button>
        <button class="button"><%= link_to 'Sign Out', destroy_user_session_path, method: :delete %></button>
      </div>
    <% end %>
```

- add if in the show for edit and delete links

```
    <% if user_signed_in? %>
      |
      <%= link_to 'Edit', edit_post_path(@post) %> |
      <%= link_to 'Delete', post_path(@post), method: :delete, data: { confirm: 'Are you sure?'} %>
    <% end %>
```

- in comments/comment partial update the delete link

```
  <% if user_signed_in? %>
    <p><%= link_to 'Delete', [comment.post, comment], method: :delete, class: 'button', data: { confirm: 'Are you sure?'} %></p>
  <% end %>
```

# The End
