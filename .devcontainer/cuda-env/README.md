# Azure AI Playgrounds - NVIDIA CUDA devcontainer

This devcontainer provides a development environment for running Azure AI playgrounds in this repository that require the use of your NVIDIA GPU with CUDA support (for example, running PyTorch or TensorFlow with GPU support).

It includes all of the necessary tools and dependencies to setup and run the playgrounds provided.

## Configuration

- **Base Image**: `nvidia/cuda:12.5.0-devel-ubuntu22.04`
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

- A machine with a CUDA-compatible NVIDIA GPU
  - Ensure the [latest NVIDIA drivers are installed](https://www.nvidia.com/en-us/drivers/)
- [**Docker Desktop**](https://docs.docker.com/desktop/install/windows-install/)
  - If using Windows with WSL, recommend [setting up a `.wslconfig` file to increase the resources available to WSL2](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#example-wslconfig-file)
- [**Visual Studio Code**](https://code.visualstudio.com/download)
  - [**Remote - Containers**](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension for Visual Studio Code to use the devcontainer

## Run the Devcontainer

1. Clone this repository to your local machine.
2. Open the repository in Visual Studio Code.
3. In Visual Studio Code, press `F1` to open the command palette.
4. Type `Dev Containers: Open Folder in Container` and select the option to open the `Azure AI Playground - CUDA` devcontainer.