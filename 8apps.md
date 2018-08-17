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

- 