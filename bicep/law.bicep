targetScope='resourceGroup'

param prefix string = 'cptd'
param location string = 'eastus'


resource law 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: prefix
  location: location
}

resource sab 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: prefix
}

resource afd 'Microsoft.Network/frontDoors@2020-05-01' existing = {
  name: prefix
}

resource diaagw 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: prefix
  properties: {
    storageAccountId: sab.id
    workspaceId: law.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
  }
  scope: afd
}



