# Document Data Extraction with Marker and Azure OpenAI GPT models

## Benefits
- Marker can provide similar Markdown representations for PDF documents as Azure AI Document Intelligence. However, Azure AI Document Intelligence's Markdown representation has higher accuracy in terms of structure. 
- As with Azure AI Document Intelligence, Marker's Markdown provides a better structure for language models such as GPT to extract structured data from documents.
- For scanned PDFs, Marker utilizes OCR techniques using [Surya](https://github.com/VikParuchuri/surya), and has the option to replace with an alternative such as Tesseract.
- For PDFs with structure (i.e., computer-readable text, lists, tables, etc.), Marker can convert to Markdown without the need to perform OCR over all the text, as well as combine results with OCR for visual elements.

## Drawbacks
- Marker is a resource intensive operation, and can take a long time to process large documents without a high-performance GPU compute resource.
- Some handwritten content may not be accurately extracted using Surya OCR when compared to Azure AI Document Intelligence's OCR capabilities.
- As with Azure AI Document Intelligence, complex grid layouts do not accurately result in a structured Markdown representation using tables. This is due to limitations in Markdown's table format.