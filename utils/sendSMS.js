const twilio = require("twilio");
require("dotenv").config();

// Twilio Configuration
const client = new twilio(process.env.TWILIO_SID, process.env.TWILIO_AUTH_TOKEN);
const twilioPhoneNumber = process.env.TWILIO_PHONE_NUMBER;
const recipientPhoneNumber = process.env.RECIPIENT_PHONE_NUMBER;

// Function to Send SMS Alert
const sendSMSAlert = (heartRate, status, latitude, longitude) => {
    let locationMessage = "📍 Location: Not Found";

    if (latitude && longitude && latitude !== "No GPS" && longitude !== "No GPS") {
        locationMessage = `📍 Location: https://www.google.com/maps?q=${latitude},${longitude}`;
    }

    const messageBody = `🚨 ALERT: ${status} 🚨
💓 Heart Rate: ${heartRate} BPM
${locationMessage}`;

    client.messages.create({
        body: messageBody,
        from: twilioPhoneNumber,
        to: recipientPhoneNumber
    })
    .then(message => console.log(`📩 SMS Sent! SID: ${message.sid}`))
    .catch(error => console.error("❌ Error Sending SMS:", error));
};

module.exports = sendSMSAlert;
