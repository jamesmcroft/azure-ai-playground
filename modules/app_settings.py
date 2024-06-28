class AppSettings:
    def __init__(self, config: dict):
        self.resource_group_name = config['RESOURCE_GROUP_NAME']
        self.document_intelligence_endpoint = config['DOCUMENT_INTELLIGENCE_ENDPOINT']
        self.completions_openai_endpoint = config['COMPLETIONS_OPENAI_ENDPOINT']
        self.completions_openai_embedding_model_deployment = config['COMPLETIONS_OPENAI_EMBEDDING_MODEL_DEPLOYMENT']
        self.completions_openai_completion_model_deployment = config['COMPLETIONS_OPENAI_COMPLETION_MODEL_DEPLOYMENT']
        self.managed_identity_client_id = config['MANAGED_IDENTITY_CLIENT_ID']
        self.storage_account_name = config['STORAGE_ACCOUNT_NAME']