# Publish a Hugo site to Azure Static Web Apps with bicep

##Create a Hugo App

Create a Hugo app using the Hugo Command Line Interface (CLI):

Follow the installation guide for Hugo on your OS.

Open a terminal

Run the Hugo CLI to create a new app.

    hugo new site hello-hugo
Navigate to the newly created app.


    cd hello-hugo
Initialize a Git repo.


    git init
Next, add a theme to the site by installing a theme as go module

    go get github.com/vaga/hugo-theme-m10c

Add following snippet to the `config.yaml`

    module:
      imports:
        path: "github.com/vaga/hugo-theme-m10c"
Commit the changes.

    git add -A
    git commit -m "initial commit"

## Push your application to GitHub
You need a repository on GitHub to connect to Azure Static Web Apps. The following steps show you how to create a repository for your site.

Create a blank GitHub repo (don't create a README) from https://github.com/new named hello-jamstack.

Add the GitHub repository as a remote to your local repo. Make sure to add your GitHub username in place of the <YOUR_USER_NAME> placeholder in the following command.

    git remote add origin https://github.com/<YOUR_USER_NAME>/hello-jamstack

Push your local repo up to GitHub.

    git push --set-upstream origin main

## Deploy

* [Azure](docs/azure.md)
* [Digital Ocean](docs/do.md)