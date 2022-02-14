param prefix string

resource afd 'Microsoft.Network/frontDoors@2020-05-01' existing = {
  name: prefix
}

var actionred = {
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

var actionblue = {
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

resource afdrules 'Microsoft.Network/frontdoors/rulesengines@2020-05-01' = {
  name: '${prefix}/${prefix}'
  properties: {
    rules: [
      {
        name: '${prefix}ruleredcookie'
        priority: 0
        matchConditions: [
          {
            rulesEngineMatchValue: [
              'red'
            ]
            selector: 'cookie'
            negateCondition: false
            rulesEngineMatchVariable: 'RequestHeader'
            rulesEngineOperator: 'Contains'
            transforms: [
              'Lowercase'
            ]
          }
        ]
        action: actionred
        matchProcessingBehavior: 'Stop'
      }
      {
        name: '${prefix}rulered'
        priority: 1
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
        action: actionred
        matchProcessingBehavior: 'Stop'
      }
      {
        name: '${prefix}rulebluecookie'
        priority: 2
        matchConditions: [
          {
            rulesEngineMatchValue: [
              'blue'
            ]
            selector: 'cookie'
            negateCondition: false
            rulesEngineMatchVariable: 'RequestHeader'
            rulesEngineOperator: 'Contains'
            transforms: [
              'Lowercase'
            ]
          }
        ]
        action: actionblue
        matchProcessingBehavior: 'Stop'
      }
      {
        name: '${prefix}ruleblue'
        priority: 3
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
        action: actionblue
        matchProcessingBehavior: 'Stop'
      }

    ]
  }
}
