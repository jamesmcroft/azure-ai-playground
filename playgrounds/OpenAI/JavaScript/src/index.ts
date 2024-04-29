import { OpenAIClient } from "@azure/openai";
import { DefaultAzureCredential } from "@azure/identity";
import path from "path";
import dotenv from "dotenv";

dotenv.config({ path: path.resolve(__dirname, ".env") });

const getConfig = () => {
  return {
    openAIEndpoint: process.env.COMPLETIONS_OPENAI_ENDPOINT ?? "",
    openAICompletionsModelDeployment:
      process.env.COMPLETIONS_OPENAI_COMPLETION_MODEL_DEPLOYMENT ?? "",
  };
};

export async function main() {
  var credential = new DefaultAzureCredential();
  const client = new OpenAIClient(getConfig().openAIEndpoint, credential, {
    apiVersion: "2024-03-01-preview",
  });
  const deploymentId = getConfig().openAICompletionsModelDeployment;

  const text = `Dear Team,

  Thank you for attending our recent meeting on building an AI solution using Azure. I wanted to summarize the key points and action items discussed during the meeting:
  
  1. Project Overview:
    - We discussed the need for an AI solution to enhance customer interactions.
    - The goal is to integrate intelligence into our communications across various channels.
  2. Key Takeaways:
    - Azure Communication Services and Azure AI can be used together to automate and transform customer interactions.
    - Our solution will provide faster and informed responses across text-based bots, voice channels, email, and SMS.
    - Agents can leverage AI context to handle escalations effectively.
  3. Action Items:
    - Set up a project team to explore Azure Communication Services and Azure AI.
    - Identify communication channels (e.g., website chat, phone, SMS) for integration.
    - Develop a proof-of-concept bot using ChatGPT and Azure OpenAI Service.
    - Create a roadmap for implementing the solution.
  4. Next Steps:
    - Let's schedule a follow-up meeting next week to review progress and assign responsibilities.
    - Let's grab a coffee and have a chat.
  
  Feel free to reach out if you have any questions or need further clarification. Looking forward to working together on this exciting project!
  
  Best regards, 
  James`;

  const optionExtras = {
    logprobs: true,
    top_logprobs: 3,
  };

  const response = await client.getChatCompletions(
    deploymentId,
    [
      {
        role: "system",
        content:
          "You are an AI assistant that splits text, classifies it into categories, and returns the response as structured JSON objects.",
      },
      {
        role: "user",
        content:
          "Classify the following text in the following categories: 'top_priority', 'high_priority', 'medium_priority', 'low_priority'.",
      },
      { role: "user", content: text },
    ],
    {
      maxTokens: 4096,
      temperature: 0.1,
      topP: 0.1,
      ...optionExtras,
    }
  );

  const jsonResponse = JSON.stringify(response, null, 2);

  console.log("OpenAICompletions-JavaScript response:");
  console.log(jsonResponse);
}

main().catch((err) => {
  console.error("The sample encountered an error:", err);
});
