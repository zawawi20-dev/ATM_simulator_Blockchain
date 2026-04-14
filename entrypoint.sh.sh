#!/bin/sh

echo "Starting ATM Node: ${NODE_NAME} (${NODE_ID}) on port ${NODE_PORT}"

# Initialize node-specific data directory
mkdir -p /app/data

# Check if user data exists, if not create default
if [ ! -f /app/data/users.txt ] || [ ! -s /app/data/users.txt ]; then
    echo "Initializing default users for ${NODE_ID}..."
    echo "admin,admin123,10000,1234567890123456,12/25,0xAdminWallet${NODE_ID}" > /app/data/users.txt
    echo "user1,pass123,5000,1111222233334444,11/24,0xUser1${NODE_ID}" >> /app/data/users.txt
    echo "user2,pass456,3000,5555666677778888,10/25,0xUser2${NODE_ID}" >> /app/data/users.txt
    
    # Generate keys
    echo "admin,key-admin-$(date +%s)-${NODE_ID}" > /app/data/keys.txt
    echo "user1,key-user1-$(date +%s)-${NODE_ID}" >> /app/data/keys.txt
    echo "user2,key-user2-$(date +%s)-${NODE_ID}" >> /app/data/keys.txt
fi

# Start the application
node server.js