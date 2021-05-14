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