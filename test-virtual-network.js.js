const axios = require('axios');

async function testVirtualNetwork() {
    console.log('Testing Virtual 5-Node Blockchain Network...\n');
    
    const nodes = [
        { name: 'Computer 1', port: 3001 },
        { name: 'Computer 2', port: 3002 },
        { name: 'Computer 3', port: 3003 },
        { name: 'Computer 4', port: 3004 },
        { name: 'Computer 5', port: 3005 }
    ];
    
    // Test 1: Check all nodes are running
    console.log('1. Checking node status:');
    for (const node of nodes) {
        try {
            const response = await axios.get(`http://localhost:${node.port}/node-status`);
            console.log(`   ✓ ${node.name}: ONLINE (${response.data.usersCount} users)`);
        } catch (err) {
            console.log(`   ✗ ${node.name}: OFFLINE`);
        }
    }
    
    // Test 2: Login to each node
    console.log('\n2. Testing login on each node:');
    for (const node of nodes) {
        try {
            const response = await axios.post(`http://localhost:${node.port}/login`, {
                username: 'admin',
                password: 'admin123'
            });
            
            if (response.data.success) {
                console.log(`   ✓ ${node.name}: Login successful (Balance: ${response.data.user.balance})`);
            } else {
                console.log(`   ✗ ${node.name}: Login failed`);
            }
        } catch (err) {
            console.log(`   ✗ ${node.name}: Error - ${err.message}`);
        }
    }
    
    // Test 3: Cross-node transactions
    console.log('\n3. Testing cross-node transaction:');
    try {
        const response = await axios.post('http://localhost:3001/update-balance', {
            sender: 'admin',
            recipient: 'user1',
            amount: 100,
            accountType: 'savings'
        });
        
        console.log(`   Transaction from Computer 1: ${response.data.success ? 'SUCCESS' : 'FAILED'}`);
        console.log(`   Message: ${response.data.message}`);
        
        if (response.data.consensus) {
            console.log(`   ✓ Consensus reached across network`);
        }
    } catch (err) {
        console.log(`   ✗ Transaction failed: ${err.message}`);
    }
    
    // Test 4: Check consensus across nodes
    console.log('\n4. Checking transaction consistency:');
    for (const node of nodes) {
        try {
            const response = await axios.get(`http://localhost:${node.port}/get-all-transactions`);
            console.log(`   ${node.name}: ${response.data.total} transactions`);
        } catch (err) {
            console.log(`   ${node.name}: Error checking transactions`);
        }
    }
    
    console.log('\n✅ Virtual network test completed!');
}

testVirtualNetwork();