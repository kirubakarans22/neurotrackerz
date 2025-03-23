const mongoose = require("mongoose");
require("dotenv").config();

const connectDB = async () => {
    try {
        console.log("🟡 Connecting to MongoDB...");
        await mongoose.connect(process.env.MONGO_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
            authSource: "admin",  // Ensures authentication is checked
        });
        console.log("✅ MongoDB Connected Successfully");
    } catch (err) {
        console.error("❌ MongoDB Connection Error:", err.message);
        process.exit(1);
    }
};

module.exports = connectDB;
