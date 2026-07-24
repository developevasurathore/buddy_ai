const functions = require("firebase-functions");
require("dotenv").config();
const { GoogleGenerativeAI } = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

exports.sendChatMessage = functions.https.onCall(async (data, context) => {
  const { message, history } = data;
  if (!message || typeof message !== "string" || message.length > 4000) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Message is required and must be under 4000 characters."
    );
  }

  const safeHistory = Array.isArray(history) ? history.slice(-20) : [];

  try {
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

    const geminiHistory = safeHistory.map((h) => ({
      role: h.role === "user" ? "user" : "model",
      parts: [{ text: h.content }],
    }));

    const chat = model.startChat({ history: geminiHistory });
    const result = await chat.sendMessage(message);
    const reply = result.response.text();

    return { reply };
  } catch (err) {
    console.error("Gemini API error:", err);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to get a response from the AI provider."
    );
  }
});