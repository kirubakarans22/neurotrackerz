const SensorData = require("../models/sensorData");
const sendSMSAlert = require("../utils/sendSMS");

// 🔹 Save Sensor Data & Trigger SMS Alert
exports.saveSensorData = async (req, res) => {
    try {
        let { heartRate, latitude, longitude, status } = req.body;

        // If GPS is unavailable, store "No GPS"
        if (!latitude || !longitude || latitude === "No GPS" || longitude === "No GPS") {
            latitude = "No GPS";
            longitude = "No GPS";
        }

        // Save sensor data to MongoDB
        const newSensorData = new SensorData({ heartRate, latitude, longitude, status });
        await newSensorData.save();

        console.log("✅ Data Saved:", newSensorData);

        // 🔹 Send SMS alert for FALL DETECTED or EMERGENCY
        if (status === "Fall Detected" || status === "Emergency") {
            sendSMSAlert(heartRate, status, latitude, longitude);
        }

        res.status(201).json({ success: true, message: "Data saved & SMS sent if needed!" });
    } catch (error) {
        console.error("❌ Error Saving Data:", error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};

// 🔹 Get Last 10 Sensor Records
exports.getSensorData = async (req, res) => {
    try {
        const sensorData = await SensorData.find().sort({ timestamp: -1 }).limit(10);
        res.status(200).json(sensorData);
    } catch (error) {
        console.error("❌ Error Fetching Data:", error.message);
        res.status(500).json({ success: false, message: "Server Error" });
    }
};
