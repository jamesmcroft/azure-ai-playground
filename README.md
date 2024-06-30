# Testing Playground for Azure AI Services

This repository is primarily used to test and evaluate techniques with Azure AI services for the purposes of learning and experimentation. The repository is organized into different directories, each of which contains a different set of experiments and tests.

This repository is not intended for production use, and the code contained within is not guaranteed to be secure or optimized. It is intended for educational purposes only.

> [!NOTE]
> The playgrounds are primarily built with various languages including .NET, Python, and TypeScript. However, not every playground has an environment for each language. Libraries to interface with Azure services are available in each of these languages, and the code can be easily translated to them with studying the API surface layer and utilizing AI.

## Pre-requisites

This repository contains a [devcontainer](./.devcontainer) configuration for Visual Studio Code. This configuration contains all the necessary tools and libraries to run the code in this repository. To use the devcontainer, you must have the following installed on your local machine:

- Install [**Visual Studio Code**](https://code.visualstudio.com/download)
- Install [**Docker Desktop**](https://www.docker.com/products/docker-desktop)
- Install [**Remote - Containers**](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension for Visual Studio Code

> [!NOTE]
> If you are not planning on using the Dev Container, you must also install [**PowerShell Core**](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell), [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli), [**.NET SDK**](https://dotnet.microsoft.com/download), [**Nodejs**](https://nodejs.org/en/download/), and [**Python**](https://www.python.org/) on your local machine, as well as the necessary Python packages from the [**requirements.txt**](./requirements.txt) file. 

## Setting up the Azure AI Services

To setup an environment in Azure, simply run the [Setup-Environment.ps1](./Setup-Environment.ps1) script from the root of the project:

> [!IMPORTANT]
> Ensure that you have run the `az login` command to authenticate with Azure before running the script, and selected your subscription using `az account set --subscription <SubscriptionId>`.

```powershell
.\Setup-Environment.ps1 -DeploymentName <DeploymentName> -Location <Location> -SkipInfrastructure $false
```

This script will deploy the necessary Azure services using the Azure Bicep template in the [infra](./infra/main.bicep) folder.

Once deployed, the script will create a `.env` file in the root of the project with the necessary environment variables to connect to the Azure services.

## Playgrounds

### Document Data Extraction

#### Azure AI Document Intelligence

- [Pre-built Layout Markdown to Structured Object Extraction with GPT](./playgrounds/DocumentIntelligence/Prebuilt-Layout-Markdown-GPT-Data-Extraction/Playground.ipynb)
  - **Note**: This playground has been matured into a sample - [Using Azure AI Document Intelligence and Azure OpenAI GPT-3.5 Turbo to extract structured data from documents](https://github.com/jamesmcroft/azure-document-intelligence-markdown-to-openai-data-extraction-sample)
- [Pre-built Invoice Extraction with Custom Fields](./playgrounds/DocumentIntelligence/Prebuilt-Invoice-Custom-Field-Extraction/Playground.ipynb)
  - Demonstrate how to use the Azure AI Document Intelligence service's pre-built invoice extraction model to extract fields from any invoice, including custom fields.

#### Azure OpenAI

- [Document Data Extraction with PyMuPDF and Azure OpenAI GPT models](./playgrounds/OpenAI/PyMuPDF-Data-Extraction/Playground.ipynb)
  - Demonstrate how to use [PyMuPDF](https://github.com/pymupdf/pymupdf) as an OCR tool in application code, and Azure OpenAI GPT models as the language model to extract structured data from documents.
- [Document Data Extraction with Marker and Azure OpenAI GPT models](./playgrounds/OpenAI/Marker-Data-Extraction/Playground.ipynb)
  - Demonstrate how to use [Marker](https://github.com/VikParuchuri/marker) as an OCR tool in application code, and Azure OpenAI GPT models as the language model to extract structured data from documents.
- [Document Data Extraction with Florence-2 and Azure OpenAI GPT models](./playgrounds/OpenAI/Florence-2-Data-Extraction/Playground.ipynb)
  - Demonstrate how to use [Florence-2](https://huggingface.co/microsoft/Florence-2-large) as an OCR tool in application code, and Azure OpenAI GPT models as the language model to extract structured data from documents.