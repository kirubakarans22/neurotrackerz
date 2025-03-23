const mongoose = require("mongoose");

const sensorDataSchema = new mongoose.Schema({
    heartRate: { type: Number, required: true },
    latitude: { type: String, required: true },
    longitude: { type: String, required: true },
    status: { type: String, required: true },
    timestamp: { type: Date, default: Date.now }
});

module.exports = mongoose.model("SensorData", sensorDataSchema);
