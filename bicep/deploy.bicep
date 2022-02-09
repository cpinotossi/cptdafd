targetScope='resourceGroup'

var parameters = json(loadTextContent('parameters.json'))
var location = resourceGroup().location
param myobjectid string
param myip string

module nsgModule 'nsg.bicep' = {
  name: 'nsgDeploy'
  params: {
    prefix: parameters.prefix
    location: location
  }
}

module vnetModule 'vnet.bicep' = {
  name: 'vnetDeploy'
  params: {
    prefix: parameters.prefix
    location: location
  }
  dependsOn:[
    nsgModule
  ]
}

module vmRedModule 'vm.bicep' = {
  name: '${parameters.prefix}red'
  params: {
    prefix: parameters.prefix
    location: location
    username: parameters.username
    password: parameters.password
    myObjectId: myobjectid
    postfix: 'red'
    privateip: '10.0.0.4'
    customdataBase64:loadFileAsBase64('vmred.yaml')
  }
  dependsOn:[
    vnetModule
  ]
}

module vmBlueModule 'vm.bicep' = {
  name: '${parameters.prefix}blue'
  params: {
    prefix: parameters.prefix
    location: location
    username: parameters.username
    password: parameters.password
    myObjectId: myobjectid
    postfix: 'blue'
    privateip: '10.0.0.5'
    customdataBase64:loadFileAsBase64('vmblue.yaml')
  }
  dependsOn:[
    vnetModule
  ]
}

module vmWhiteModule 'vm.bicep' = {
  name: '${parameters.prefix}white'
  params: {
    prefix: parameters.prefix
    location: location
    username: parameters.username
    password: parameters.password
    myObjectId: myobjectid
    postfix: 'white'
    privateip: '10.0.0.6'
    customdataBase64:loadFileAsBase64('vm.yaml')
  }
  dependsOn:[
    vnetModule
  ]
}

module sabModule 'sab.bicep' = {
  name: 'sabDeploy'
  params: {
    prefix: parameters.prefix
    location: location
    myip: myip
    myObjectId: myobjectid
  }
  // dependsOn:[
  //   vnetModule
  // ]
}

module dnsModule 'dns.bicep' = {
  name: 'dnsDeploy'
  scope: resourceGroup('ga-rg')
  params: {
    domain: parameters.domain
  }
}

module afdModule 'afd.bicep' = {
  name: 'afdDeploy'
  params: {
    prefix: parameters.prefix
    hostnamered: vmRedModule.outputs.hostname
    hostnameblue: vmBlueModule.outputs.hostname
    hostname: vmWhiteModule.outputs.hostname
    domain: parameters.domain
  }
  dependsOn:[
    dnsModule
  ]
}

module afdreModule 'afdre.bicep' = {
  name: 'afdreDeploy'
  params: {
    prefix: parameters.prefix
  }
  dependsOn:[
    afdModule
  ]
}

module lawModule 'law.bicep' = {
  name: 'lawDeploy'
  params:{
    prefix: parameters.prefix
    location: location
  }
  dependsOn:[
    afdModule
  ]
}
