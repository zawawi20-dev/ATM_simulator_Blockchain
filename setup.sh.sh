#!/bin/bash

echo "Setting up 5-Node Virtual Blockchain ATM Network..."

# 1. Create directory structure
mkdir -p nodes/{node1,node2,node3,node4,node5}
mkdir -p nginx shared

# 2. Create default configuration
cat > shared/config.js << 'EOF'
module.exports = {
    algorithm: 'aes-256-cbc',
    key: Buffer.from('0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef', 'hex'),
    iv: Buffer.from('0123456789abcdef0123456789abcdef', 'hex')
};
EOF

# 3. Create nginx configuration
cat > nginx/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream node1 {
        server node1:3000;
    }
    
    upstream node2 {
        server node2:3000;
    }
    
    upstream node3 {
        server node3:3000;
    }
    
    upstream node4 {
        server node4:3000;
    }
    
    upstream node5 {
        server node5:3000;
    }

    server {
        listen 80;
        
        location /node1/ {
            proxy_pass http://node1/;
            rewrite ^/node1/(.*) /$1 break;
        }
        
        location /node2/ {
            proxy_pass http://node2/;
            rewrite ^/node2/(.*) /$1 break;
        }
        
        location /node3/ {
            proxy_pass http://node3/;
            rewrite ^/node3/(.*) /$1 break;
        }
        
        location /node4/ {
            proxy_pass http://node4/;
            rewrite ^/node4/(.*) /$1 break;
        }
        
        location /node5/ {
            proxy_pass http://node5/;
            rewrite ^/node5/(.*) /$1 break;
        }
        
        location / {
            proxy_pass http://node1/;
        }
    }
}
EOF

# 4. Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose not found. Installing..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# 5. Build and start the network
echo "Building Docker images..."
docker-compose build

echo "Starting 5-node network..."
docker-compose up -d

echo ""
echo "================================================"
echo "🚀 5-Node Blockchain ATM Network is running!"
echo "================================================"
echo ""
echo "Access Points:"
echo "  Computer 1: http://localhost:3001"
echo "  Computer 2: http://localhost:3002"
echo "  Computer 3: http://localhost:3003"
echo "  Computer 4: http://localhost:3004"
echo "  Computer 5: http://localhost:3005"
echo "  Dashboard:  http://localhost:80"
echo ""
echo "Test Accounts (same on all nodes):"
echo "  Username: admin, Password: admin123"
echo "  Username: user1, Password: pass123"
echo "  Username: user2, Password: pass456"
echo ""
echo "To stop the network: docker-compose down"
echo "To view logs: docker-compose logs -f"
echo "================================================"