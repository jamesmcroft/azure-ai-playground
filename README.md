# Testing Playground for Azure AI Services

This repository is primarily used to test and evaluate techniques with Azure AI services for the purposes of learning and experimentation. The repository is organized into different directories, each of which contains a different set of experiments and tests.

This repository is not intended for production use, and the code contained within is not guaranteed to be secure or optimized. It is intended for educational purposes only.

> [!NOTE]
> The playgrounds are primarily built with various languages including .NET, Python, and TypeScript. However, not every playground has an environment for each language. Libraries to interface with Azure services are available in each of these languages, and the code can be easily translated to them with studying the API surface layer and utilizing AI.

## Pre-requisites

- Install the latest [**.NET SDK**](https://dotnet.microsoft.com/download).
- Install [**PowerShell Core**](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1).
- Install the [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
- Install [**Visual Studio Code**](https://code.visualstudio.com/) with the [**Polyglot Notebooks extension**](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.dotnet-interactive-vscode).

## Setting up the Azure AI Services

To setup an environment in Azure, simply run the [Setup-Environment.ps1](./Setup-Environment.ps1) script from the root of the project:

```powershell
.\Setup-Environment.ps1 -DeploymentName <DeploymentName> -Location <Location> -SkipInfrastructure $false
```

This script will deploy the necessary Azure services using the Azure Bicep template in the [infra](./infra/main.bicep) folder.

Once deployed, the script will create a `.env` file in the root of the project with the necessary environment variables to connect to the Azure services.

## Playgrounds

### Azure AI Document Intelligence

- [Markdown to Structured Object Extraction with GPT](./playgrounds/DocumentIntelligence/MarkdownDataExtraction.ipynb)
  - **Note**: This playground has been matured into a sample - [Using Azure AI Document Intelligence and Azure OpenAI GPT-3.5 Turbo to extract structured data from documents](https://github.com/jamesmcroft/azure-document-intelligence-markdown-to-openai-data-extraction-sample)
- [Pre-built Invoice Extraction with Custom Fields](./playgrounds/DocumentIntelligence/PrebuiltInvoiceExtraction.ipynb)
  - Demonstrate how to use the Azure AI Document Intelligence service's pre-built invoice extraction model to extract fields from any invoice, including custom fields.
