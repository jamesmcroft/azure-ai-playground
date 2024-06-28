# Document Data Extraction with PyMuPDF and Azure OpenAI GPT models

## Benefits
- For PDFs with structure (i.e., computer-readable text, lists, tables, etc.), PyMuPDF can extract data from the document without the need for OCR.
- Tesseract can be used where PDFs are scanned or contain handwriting.

## Drawbacks
- Tesseract OCR extraction is not great at accurately extracting text, particularly when the text is in a grid layout.
- In general, processing text with no structure using language models does always yield highly accurate results, and varies from document to document.