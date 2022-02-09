param prefix string

resource afd 'Microsoft.Network/frontDoors@2020-05-01' existing = {
  name: prefix
}

resource afdrules 'Microsoft.Network/frontdoors/rulesengines@2020-05-01' = {
  name: '${prefix}/${prefix}'
  properties: {
    rules: [
      {
        name: '${prefix}rulered'
        priority: 0
        matchConditions: [
          {
            rulesEngineMatchValue: [
              'red/'
            ]
            negateCondition: false
            rulesEngineMatchVariable: 'RequestPath'
            rulesEngineOperator: 'Contains'
            transforms: [
              'Lowercase'
            ]
          }
        ]
        action: {
          routeConfigurationOverride: {
            forwardingProtocol: 'MatchRequest'
            backendPool: {
              id: resourceId('Microsoft.Network/frontdoors/BackendPools',prefix,'${prefix}backpoolred')
            }
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
          }
          requestHeaderActions: []
          responseHeaderActions: []
        }
        matchProcessingBehavior: 'Stop'
      }
      {
        name: '${prefix}ruleblue'
        priority: 1
        matchConditions: [
          {
            rulesEngineMatchValue: [
              'blue/'
            ]
            negateCondition: false
            rulesEngineMatchVariable: 'RequestPath'
            rulesEngineOperator: 'Contains'
            transforms: [
              'Lowercase'
            ]
          }
        ]
        action: {
          routeConfigurationOverride: {
            forwardingProtocol: 'MatchRequest'
            backendPool: {
              id: resourceId('Microsoft.Network/frontdoors/BackendPools',prefix,'${prefix}backpoolblue')
            }
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
          }
          requestHeaderActions: []
          responseHeaderActions: []
        }
        matchProcessingBehavior: 'Stop'
      }
    ]
  }
}
