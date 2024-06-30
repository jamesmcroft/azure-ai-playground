# Document Data Extraction with Florence-2 and Azure OpenAI GPT models

## Pre-requisites

This playground requires the use of a CUDA-compatible development environment to run the Florence-2 model. Please ensure you have necessary NVIDIA drivers and CUDA installed on your machine, or use the provided [CUDA devcontainer](../../../.devcontainer/cuda-env/).

> [!NOTE]
> The [CUDA devcontainer](../../../.devcontainer/cuda-env/) provides the necessary containerized environment to run this playground. However, you still require a compatible CUDA-compatible GPU to run on the host machine.

## Learnings

### We believed
- Using Florence-2 for converting PDFs to text would provide high accuracy in extracting structured data downstream from results using language models.

### We observed
- Florence-2 provides out-of-the-box tasks for OCR and OCR with Regions, ideal for processing documents where visual elements may need to be captured with bounding boxes.
- For scanned images with complex grid/table layouts, the OCR output often included extraneous characters ('I', 'l', or '1'), leading to inaccurate downstream processing.
- The OCR with Regions task struggled with complex document layouts, often resulting in empty outputs after extended processing times (over 4 minutes).
- Hosting the model on a GPU is required, which can be costly and may not be feasible for all solutions.
- Processing with complex scanned invoices, combined with extraction using GPT-4o, resulted in an average accuracy of 74%.

### We learned
- While Florence-2 and GPT-4o provide a structured and potentially accurate extraction method, their effectiveness diminishes significantly with complex grid layouts and unstructured text.
- The necessity of self-hosting on GPU workloads can add a substantial cost and maintenance burden, making it less accessible for smaller or resource-constrained projects.
- The OCR with Regions task is not reliable for all document types, especially those with intricate layouts, indicating a need for alternative approaches where bounding boxes are essential.

### Therefore, we recommend
- Evaluate the complexity of the document layouts before choosing this extraction method. For simpler layouts, this combination may be suitable; for more complex layouts, alternative solutions should be considered.
- Consider the cost and feasibility of self-hosting the model in a containerized environment, either on-premises or cloud-based to mitigate challenges.
- Continuously test and validate the extraction accuracy across different document types to identify and address limitations, ensuring the chosen method aligns with the specific needs and constraints of the project.