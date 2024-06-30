# Document Data Extraction with Marker and Azure OpenAI GPT models

## We believed
- Using Marker for converting PDFs to Markdown would provide similar benefits to Azure AI Document Intelligence when extracting structured data downstream from results using language models.

## We observed
- Marker can provide Markdown representations for PDF documents with structure, similar to Azure AI Document Intelligence, but with lower accuracy, especially for tables.
- Both Marker and Azure's Markdown output facilitate better structured data extraction when processed by language models.
- Marker's OCR using [Surya](https://github.com/VikParuchuri/surya), is efficient, outperforming Tesseract, but not as effective as Azure AI Document Intelligence's OCR for handwritten content.
- Marker can convert PDFs with computer-readable text directly to Markdown without extensive OCR processing, combining OCR results for visual elements.
- Processing with complex scanned invoices, combined with extraction using GPT-4o, resulted in an average accuracy of 83%.

## We learned
- Marker and Azure AI Document Intelligence both excel in converting structured PDFs to Markdown, aiding in the extraction of structured data for language models.
- Marker is resource-intensive for OCR and requires a high-performance GPU for processing large documents efficiently.
- Some handwritten content poses a challenge for Marker's OCR, indicating a need to explore alternatives.
- Marker, like Azure AI Document Intelligence, can struggle with complex grid layouts due to Markdown's limitations in representing tables accurately for merged cells and multi-row/column spans.

## Therefore, we recommend
- For high accuracy and better structure in document extraction, especially for handwritten content and complex grids, consider using Azure AI Document Intelligence over Marker.
- Ensure access to high-performance GPU resources when using Marker for processing large documents with OCR to avoid long processing times.
- For documents with extensive visual elements and structured text, utilize Marker's ability to combine OCR results with structural conversion to Markdown for optimal results.
- Use Marker in scenarios where cloud-based services are not feasible or where a self-hosted solution is preferred for data extraction tasks.