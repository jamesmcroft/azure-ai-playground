# Azure AI Playgrounds - devcontainer

This devcontainer provides a development environment for running Azure AI playgrounds in this repository that do not require a GPU with CUDA support.

It includes all of the necessary tools and dependencies to setup and run the playgrounds provided.

## Configuration

- **Base Image**: `mcr.microsoft.com/vscode/devcontainers/python:1-3.12-bullseye`
- **Python Version**: `3.12`
- **Node.js Version**: `22.x` and `20.x`
- **.NET SDK Version**: `9.0` and `8.0

## Tools

The following tools are included in the devcontainer:

- **Git**
- **PowerShell Core**
- **Azure CLI**
- **Azure Developer CLI**
- **GitHub CLI**
- **Docker-in-Docker**
- **Poppler Utils**
- **Tesseract OCR**
- **ffmpeg**
- **OpenCV**

## Pre-requisites

- [**Docker Desktop**](https://docs.docker.com/desktop/install/windows-install/)
- [**Visual Studio Code**](https://code.visualstudio.com/download)
  - [**Remote - Containers**](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension for Visual Studio Code to use the devcontainer

## Run the Devcontainer

1. Clone this repository to your local machine.
2. Open the repository in Visual Studio Code.
3. In Visual Studio Code, press `F1` to open the command palette.
4. Type `Dev Containers: Open Folder in Container` and select the option to open the `Azure AI Playground - Non-CUDA` devcontainer.