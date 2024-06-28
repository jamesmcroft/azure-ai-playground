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

### Azure AI Document Intelligence

- [Pre-built Layout Markdown to Structured Object Extraction with GPT](./playgrounds/DocumentIntelligence/Prebuilt-Layout-Markdown-GPT-Data-Extraction/Playground.ipynb)
  - **Note**: This playground has been matured into a sample - [Using Azure AI Document Intelligence and Azure OpenAI GPT-3.5 Turbo to extract structured data from documents](https://github.com/jamesmcroft/azure-document-intelligence-markdown-to-openai-data-extraction-sample)
- [Pre-built Invoice Extraction with Custom Fields](./playgrounds/DocumentIntelligence/Prebuilt-Invoice-Custom-Field-Extraction/Playground.ipynb)
  - Demonstrate how to use the Azure AI Document Intelligence service's pre-built invoice extraction model to extract fields from any invoice, including custom fields.

### Azure OpenAI

- [Document Data Extraction with PyMuPDF and Azure OpenAI GPT models](./playgrounds/OpenAI/PyMuPDF-Data-Extraction/Playground.ipynb)
  - Demonstrate how to use [PyMuPDF](https://github.com/pymupdf/pymupdf) as the data extraction tool in application code, and Azure OpenAI GPT models as the language model to extract structured data from documents.
  - **Benefits**: For PDFs with structure (i.e., computer-readable text, lists, tables, etc.), PyMuPDF can extract data from the document without the need for OCR. If scanned, PyMuPDF can be used in conjunction with Tessaract OCR to extract text.
  - **Drawbacks**: Tesseract OCR extraction is not great at accurately extracting text, particularly when the text is in a grid layout. In general, processing text with no structure using language models does always yield highly accurate results, and varies from document to document.
- [Document Data Extraction with Marker and Azure OpenAI GPT models](./playgrounds/OpenAI/Marker-Data-Extraction/Playground.ipynb)
  - Demonstrate how to use [Marker](https://github.com/VikParuchuri/marker) as the data extraction tool in application code, and Azure OpenAI GPT models as the language model to extract structured data from documents.
  - **Benefits**: Marker can provide similar Markdown representations for PDF documents as Azure AI Document Intelligence. However, Azure AI Document Intelligence's Markdown representation has higher accuracy in terms of structure. As with Azure AI Document Intelligence, Marker's Markdown provides a better structure for language models such as GPT to extract structured data from documents. For scanned PDFs, Marker utilizes OCR techniques using Surya, and has the option to replace with an alternative such as Tesseract. For PDFs with structure (i.e., computer-readable text, lists, tables, etc.), Marker can convert to Markdown without the need to perform OCR over all the text, as well as combine results with OCR for visual elements.
  - **Drawbacks**: Marker is a resource intensive operation, and can take a long time to process large documents without a high-performance GPU compute resource. Some handwritten content may not be accurately extracted using Surya OCR when compared to Azure AI Document Intelligence's OCR capabilities. As with Azure AI Document Intelligence, complex grid layouts do not accurately result in a structured Markdown representation using tables. This is due to limitations in Markdown's table format.