param prefix string
param hostnamered string
param hostnameblue string
param hostname string
param domain string

resource afd 'Microsoft.Network/frontdoors@2020-05-01' = {
  name: prefix
  location: 'Global'
  properties: {
    routingRules: [
      {
        name: '${prefix}routing'
        properties: {
          routeConfiguration: {
            forwardingProtocol: 'MatchRequest'
            // cacheConfiguration: {
            //   queryParameterStripDirective: 'StripNone'
            //   dynamicCompression: 'Enabled'
            //   cacheDuration: 'PT5M'
            // }
            backendPool: {
              id: resourceId('Microsoft.Network/frontdoors/BackendPools', prefix,'${prefix}backpool')
            }
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
          }
          frontendEndpoints: [
            {
              id: resourceId('Microsoft.Network/frontdoors/FrontendEndpoints',prefix,'${prefix}fep')
            }
          ]
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          patternsToMatch: [
            '/*'
          ]
          enabledState: 'Enabled'
          // rulesEngine: {
          //   id: resourceId('Microsoft.Network/frontdoors/rulesengines',prefix,'${prefix}')
          // }
        }
      }
      {
        name: '${prefix}routingred'
        properties: {
          routeConfiguration: {
            forwardingProtocol: 'MatchRequest'
            // cacheConfiguration: {
            //   queryParameterStripDirective: 'StripNone'
            //   dynamicCompression: 'Enabled'
            //   cacheDuration: 'PT5M'
            // }
            backendPool: {
              id: resourceId('Microsoft.Network/frontdoors/BackendPools', prefix,'${prefix}backpoolred')
            }
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
          }
          frontendEndpoints: [
            {
              id: resourceId('Microsoft.Network/frontdoors/FrontendEndpoints',prefix,'${prefix}fepred')
            }
          ]
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          patternsToMatch: [
            '/*'
          ]
          enabledState: 'Enabled'
          // rulesEngine: {
          //   id: resourceId('Microsoft.Network/frontdoors/rulesengines',prefix,'${prefix}r')
          // }
        }
      }
      {
        name: '${prefix}routingblue'
        properties: {
          routeConfiguration: {
            forwardingProtocol: 'MatchRequest'
            // cacheConfiguration: {
            //   queryParameterStripDirective: 'StripNone'
            //   dynamicCompression: 'Enabled'
            //   cacheDuration: 'PT5M'
            // }
            backendPool: {
              id: resourceId('Microsoft.Network/frontdoors/BackendPools', prefix,'${prefix}backpoolblue')
            }
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
          }
          frontendEndpoints: [
            {
              id: resourceId('Microsoft.Network/frontdoors/FrontendEndpoints',prefix,'${prefix}fepblue')
            }
          ]
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          patternsToMatch: [
            '/*'
          ]
          enabledState: 'Enabled'
          // rulesEngine: {
          //   id: resourceId('Microsoft.Network/frontdoors/rulesengines',prefix,'${prefix}r')
          // }
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: '${prefix}lbs'
        properties: {
          sampleSize: 4
          successfulSamplesRequired: 2
          additionalLatencyMilliseconds: 0
        }
      }
    ]
    healthProbeSettings: [
      {
        name: '${prefix}hprobe'
        properties: {
          path: '/'
          protocol: 'Http'
          intervalInSeconds: 30
          enabledState: 'Enabled'
          healthProbeMethod: 'HEAD'
        }
      }
    ]
    backendPools: [
      {
        name: '${prefix}backpool'
        properties: {
          backends: [
            {
              address: hostname
              //address: 'cptdafdred.eastus.cloudapp.azure.com'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              enabledState: 'Enabled'
            }
          ]
          loadBalancingSettings: {
            id: resourceId('Microsoft.Network/frontdoors/LoadBalancingSettings',prefix,'${prefix}lbs')
          }
          healthProbeSettings: {
            id: resourceId('Microsoft.Network/frontdoors/HealthProbeSettings',prefix,'${prefix}hprobe')
          }
        }
      }
      {
        name: '${prefix}backpoolred'
        properties: {
          backends: [
            {
              address: hostnamered
              //address: 'cptdafdred.eastus.cloudapp.azure.com'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              enabledState: 'Enabled'
            }
          ]
          loadBalancingSettings: {
            id: resourceId('Microsoft.Network/frontdoors/LoadBalancingSettings',prefix,'${prefix}lbs')
          }
          healthProbeSettings: {
            id: resourceId('Microsoft.Network/frontdoors/HealthProbeSettings',prefix,'${prefix}hprobe')
          }
        }
      }
      {
        name: '${prefix}backpoolblue'
        properties: {
          backends: [
            {
              address: hostnameblue
              //address: 'cptdafdblue.eastus.cloudapp.azure.com'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              enabledState: 'Enabled'
            }
          ]
          loadBalancingSettings: {
            id: resourceId('Microsoft.Network/frontdoors/LoadBalancingSettings',prefix,'${prefix}lbs')
          }
          healthProbeSettings: {
            id: resourceId('Microsoft.Network/frontdoors/HealthProbeSettings',prefix,'${prefix}hprobe')
          }
        }
      }
    ]
    frontendEndpoints: [
      {
        name: '${prefix}fep'
        properties: {
          hostName: '${prefix}.azurefd.net'
          sessionAffinityEnabledState: 'Enabled'
          sessionAffinityTtlSeconds: 0
          webApplicationFirewallPolicyLink: {
            id: fwp.id
          }
        }
      }
      {
        name: '${prefix}fepred'
        properties: {
          hostName: '${prefix}red.${domain}'
          sessionAffinityEnabledState: 'Enabled'
          sessionAffinityTtlSeconds: 0
          webApplicationFirewallPolicyLink: {
            id: fwp.id
          }
        }
      }
      {
        name: '${prefix}fepblue'
        properties: {
          hostName: '${prefix}blue.${domain}'
          sessionAffinityEnabledState: 'Enabled'
          sessionAffinityTtlSeconds: 0
          webApplicationFirewallPolicyLink: {
            id: fwp.id
          }
        }
      }
    ]
    backendPoolsSettings: {
      enforceCertificateNameCheck: 'Disabled'
      sendRecvTimeoutSeconds: 30
    }
    friendlyName: prefix
  }
}

// resource afdrules 'Microsoft.Network/frontdoors/rulesengines@2020-05-01' = {
//   name: '${prefix}/${prefix}rulesengine'
//   properties: {
//     rules: [
//       {
//         name: '${prefix}rule1'
//         priority: 0
//         action: {
//           routeConfigurationOverride: {
//             forwardingProtocol: 'MatchRequest'
//             backendPool: {
//               id: resourceId('Microsoft.Network/frontdoors/BackendPools',prefix,'${prefix}backpoolred')
//             }
//             '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
//           }
//           requestHeaderActions: []
//           responseHeaderActions: []
//         }
//         matchConditions: [
//           {
//             rulesEngineMatchValue: [
//               'usa'
//             ]
//             negateCondition: false
//             rulesEngineMatchVariable: 'RequestPath'
//             rulesEngineOperator: 'Contains'
//             transforms: [
//               'Lowercase'
//             ]
//           }
//         ]
//         matchProcessingBehavior: 'Continue'
//       }
//     ]
//   }
// }

resource fwp 'Microsoft.Network/frontdoorwebapplicationfirewallpolicies@2020-11-01' = {
  name: prefix
  location: 'Global'
  sku: {
    name: 'Classic_AzureFrontDoor'
  }
  properties: {
    policySettings: {
      enabledState: 'Enabled'
      mode: 'Detection'
      redirectUrl: 'https://paint2help.org/autsch'
      customBlockResponseStatusCode: 200
      customBlockResponseBody: 'QXV0c2No'
      requestBodyCheck: 'Disabled'
    }
    customRules: {
      rules: [
        {
          name: 'detectcpt'
          enabledState: 'Enabled'
          priority: 1
          ruleType: 'MatchRule'
          rateLimitDurationInMinutes: 1
          rateLimitThreshold: 100
          matchConditions: [
            {
              matchVariable: 'RequestHeader'
              selector: 'x-attack'
              operator: 'BeginsWith'
              negateCondition: false
              matchValue: [
                'turn-off'
              ]
              transforms: [
                'Lowercase'
              ]
            }
          ]
          action: 'Block'
        }
      ]
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'DefaultRuleSet'
          ruleSetVersion: '1.0'
          ruleGroupOverrides: []
          exclusions: []
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '1.0'
          ruleGroupOverrides: []
          exclusions: []
        }
      ]
    }
  }
}
