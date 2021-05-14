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

##Create Azure Bicep File

Create a folder called `azure` and inside a file called `static-web-page.bicep` with following content

    param location string = 'westeurope'

    @secure()
    param repositoryToken string
    
    resource staticWebPage 'Microsoft.Web/staticSites@2020-12-01' = {
        location: location
        name: 'hello-jamstack'
        properties: {
            repositoryUrl: 'https://github.com/dirien/hello-jamstack'
            branch: 'main'
            buildProperties: {
            apiLocation: 'api'
            appLocation: '/hello-hugo'
            appArtifactLocation: 'public'
        }
        repositoryToken: repositoryToken
        }
        sku: {
            name: 'Free'
        }
        tags: {
            Environment: 'Development'
        }
    }

    output staticWebPage string = staticWebPage.properties.defaultHostname

To not have the GH_TOKEN in the codebase, we create secure param `repositoryToken`

##Sign in to Azure
To deploy the bicep file sign in to using the Azure CLI.

    az login
If you have multiple Azure subscriptions, select the subscription you want to use. Replace <SUBSCRIPTION-ID-OR-SUBSCRIPTION-NAME> with your subscription information:

    az account set --subscription <SUBSCRIPTION-ID-OR-SUBSCRIPTION-NAME>

When you deploy a bicep file, you specify a resource group that contains related resources. Before running the deployment command, create the resource group with the Azure CLI.

    resourceGroupName="aswa-dev-rg"

    az group create --name $resourceGroupName  -l westeurope -o table

Use one of these deployment options to deploy the template.

    az deployment group create -f static-web-page.bicep -g aswa-dev-rg  -p repositoryToken=<GH_TOKEN>

To show the hostname use following command
    
    outputs=$(az deployment group show --name static-web-page \                                                                    
    --resource-group aswa-dev-rg \
    --query properties.outputs)

    staticWebPage=https://$(jq -r .staticWebPage.value <<< $outputs)

    echo $staticWebPage