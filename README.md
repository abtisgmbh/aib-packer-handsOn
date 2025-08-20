# Minimal Example Azure Image Builder and Packer

## Preparation: Start Dev Container

1. Open this project in vscode
2. Make sure docker is installed and ready.
3. Make sure the following vscode extension is installed: `ms-vscode-remote.remote-containers`
4. Run "Reopen in Container" to open the current project in a development container that has all required tools and dependencies preinstalled.


## Azure Image Builder

Azure Image Builder is based on Packer and uses a subset of Packer's capabilities for creating Virtual Machine Images on Azure.

An image build process an Azure can be initiatied by deploying a `'Microsoft.VirtualMachineImages/imageTemplates@2022-07-01'` resource on Azure, using a IaC tool like bicep.

See: [imageTemplate.bicep](deploy/infra/modules/imageTemplate.bicep)

> ☝️ Alternatively: There is also a relatively new integration of Azure Image Builder into Azure Portal: [New! Azure Image Builders Portal Integration - YouTube](https://www.youtube.com/watch?v=3MGCz8RY32M)

### Creating an Azure Image Builder Deployment
 
> 🚧 TODO: Integrate the following steps into a bicep deployment.

1. Create an Azure Compute Gallery
2. Create an User Assigned Managed Identity
3. Assign the Role "Compute Gallery Artefacts Publisher" to the managed identity. The scope should be the resource group thaat contains the compute gallery.
4. Use Azure CLI to connect to the subscription that you wish to deploy your resources to.

```bash
az login
```

5. Change the [azuredeploy.bicepparam](deploy/infra/azuredeploy.bicepparam) file according to your needs.
6. Run the bicep deployment.

```bash
az group create -n rg-imagebuilder-test -l westeurope
az deployment group create -f deploy/infra/azuredeploy.bicep -p deploy/infra/azuredeploy.bicepparam -g rg-imagebuilder-test
```

## Packer

1. Create an Azure Compute Gallery
2. Use Azure CLI to connect to the subscription that you wish to deploy your resources to.

```bash
az login
```

3. Packer requires access to Azure, which can be provided by using an App Registration. Execute the following Azure CLI command to create one:

```bash
az ad sp create-for-rbac --role Contributor --scopes /subscriptions/$(az account show --query id -o tsv) --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
```

> ☝️ This will assign the 'Contributor' role to the service principal at the subscription level. This allows Packer to create the ressources, necessary to build the image. Please be aware that this is a highly privileged role and Packer might just be fine with a custom role that grants only the necessary permissions: [Create or update Azure custom roles using Azure CLI - Azure RBAC | Microsoft Learn](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles-cli)

4. Update the [var-file.json](build/packer/var-file.json) with the output of the last command and all for the deployment required information (resource group, name of the compute gallery, etc.)

5. If you are using the Marketplace source from the minimal example you need to accept its terms and conditions:

```bash
az vm image terms accept --publisher 'resf' --offer  'rockylinux-x86_64' --plan '9-base'
```

6. Run the following commands to prepare packer:

```bash
packer init build/packer/myPackerExample.pkr.hcl
packer validate --var-file build/packer/var-file.json build/packer
```
7. Start the image build

```bash
packer build --force --var-file build/packer/var-file.json build/packer
```
