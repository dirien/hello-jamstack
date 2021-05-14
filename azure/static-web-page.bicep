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
