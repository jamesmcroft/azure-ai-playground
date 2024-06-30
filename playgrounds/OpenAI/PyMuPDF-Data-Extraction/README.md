# Document Data Extraction with PyMuPDF and Azure OpenAI GPT models

## Learnings

### We believed
- Using PyMuPDF and Tesseract for PDF to Markdown conversion would provide an efficient and accurate solution for extracting structured data, comparable to other advanced tools like Azure AI Document Intelligence.

### We observed
- PyMuPDF can effectively extract data from PDFs with structured elements (e.g., computer-readable text, lists, tables) without requiring OCR.
- Tesseract struggled with accurately extracting text from scanned images and handwritten content, particularly those with complex layouts, when compared to alternative OCR techniques like Azure AI Document Intelligence and Marker.
- Processing with complex scanned invoices, combined with extraction using GPT-4o, resulted in an average accuracy of 76%.

### We learned
- PyMuPDF is effective for extracting data from computer-readable PDFs, making it a reliable tool when OCR is not required.
- Tesseract's performance is suboptimal for scanned documents with complex layouts, indicating a need for further optimization or alternative solutions.
- Language models like GPT-4o can provide reasonably accurate extraction results, but the effectiveness can vary depending on the outputs produced by PyMuPDF.

### Therefore, we recommend
- Use PyMuPDF for documents with computer-readable elements to avoid the complexities and inaccuracies associated with OCR.
- Use Tesseract for simple document structures only with minimal handwritten content.
- Consider alternative OCR tools or improving pre-processing steps for scanned documents with complex layouts when using Tesseract.
- Continuously test and validate extraction results with language models like GPT-4o to understand their limitations and ensure reliability.
