<link rel="stylesheet" href="style.css">

# Udemy Rails 8 Apps

## practice round 1 - videos 18 and 19
- in terminal, in the directory
- rails new Blog
- cd Blog
- rails s
- rails g model Post title:string body:text (always singular and capital)
- rails db:migrate
- rails g controller Posts(plural) index new show destroy

## Section 9 - filecabinet app (like evernote)
- rails new Cabinet
- cd Cabinet, git init
- git add ., git commit -m "Initial commit"
- rails g controller welcome index
- in routes: root 'welcome#index'

## doc controller, model and more routes
- add the gems haml, simple_form, devise
- bundle
- rename welcome/index.html.erb to index.html.haml
- replace the code: 

```
%h1 Voila this is the place holder
```

- rails g model Doc title:string content:text
- bundle
- rails db:migrate
- rails g controller Docs
- in routes: resources :docs
- in docs controller add:

```
class DocsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def find_doc
    end

    def doc_params
    end
end

```

## 24. first view file for doc model

- create the file docs/new.html.haml
- create file docs/_form.html.haml
- in new file add

```
%h1 New Doc
```

- setting up simple form
- in terminal: rails g simple_form:install
- restart server
- in form partial add

```
= simple_form_for @doc do |f|
  = f.input :title
  = f.input :content
  = f.button :submit
```

- in docs/new add code

```
%h1 New Doc

= render 'form'
```

- in docs controller, update new, create and doc_params

```
  def new
    @doc = Doc.new
  end

  def create
    @doc = Doc.new(doc_params)

    if @doc.save
      redirect_to @doc
    else
      render 'new'
    end
  end
  def doc_params
    params.require(:doc).permit(:title, :content)
  end  
```

## 25. display single and all documents

- create the file docs/show.html.haml and add the code

```
%h1= @doc.title
%p= @doc.content
```

- in doc controller, update the find_doc and add before action up top

```
before_action :find_doc, only: [:show, :edit, :update, :destroy]
def find_doc
  @doc = Doc.find(params[:id])
end
```

- go to localhost docs/new create a new doc
- create the file docs/index.html.haml add the code

```
- @docs.each do |doc|
  %h2= link_to doc.title, doc
  %p= time_ago_in_words(doc.created_at)
  %p= truncate(doc.content, length: 50)
```

- update new action in docs controller

```
  def index
    @docs = Doc.all.order("created_at DESC")
  end
```

## 26. edit/update and destroy docs

- in docs controller, update the update and destroy

```
  def update
    if @doc.update(doc_params)
      redirect_to @doc
    else
      render 'edit'
    end
  end
  def destroy
    @doc.destroy
    redirect_to docs_path
  end  
```

- update the show page with the links

```
= link_to 'All Docs', docs_path
= link_to 'Fix Doc', edit_doc_path(@doc)
= link_to 'Trash It', doc_path(@doc), method: :delete, data: { confirm: 'Are you sure?' }

```

- create the docs/edit and add the code

```
%h1 Edit Doc 

= render 'form'

= link_to 'Cancel', doc_path
```

- in the index add the create new doc link

```
= link_to 'Create Doc', new_doc_path
```

## 27. user model w/ associations

- using devise: rails g devise:install
- do the devise to dos, mailer, flash messages, views
- rails g devise:views
- rails g devise User
- rails db:migrate
- create a user in browser
- linking user with docs
- in terminal: rails g migration add_user_id_to_docs user_id:integer
- rails db:migrate
- update doc.rb model

```
belongs_to :user
```

- update user.rb

```
has_many :docs
```

- in doc controller, update the new action

```
  def new
    @doc = current_user.docs.build
  end

  def create
    @doc =  current_user.docs.build(doc_params)

    if @doc.save
      redirect_to @doc
    else
      render 'new'
    end
  end
```

- go to browser and create a doc
- in rails console check last doc and it should have user

## 28. document restrictions (visible only to creator) & stylesheets

- displaying only the docs created by the current user on the index page
- update the code in doc controller, the index action to be

```
  def index
    @docs = Doc.where(user_id: current_user)
  end
```

- create a second user and test

### once user logged in their homepage should be their docs index page not the general welcome index sales page

- in the routes file we need 2 root directories one for authenticated and one for non-logged in users
- update the routes to be:

```
Rails.application.routes.draw do
  devise_for :users
  resources :docs

  authenticated :user do
    root "docs#index", as: "authenticated_root"
  end
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
```

- styling the site
- in app.css rename to .scss and add the code

```
@import 'normalize';
@import 'global';
@import 'docs';
@import 'welcome';
```

- create the files normalize and global
- get normalize from the net

## 29. styling and navigation

- 
