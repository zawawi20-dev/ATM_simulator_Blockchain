import hashlib
import time

class Block:
    def __init__(self, index, previous_hash, timestamp, transactions, nonce=0):
        self.index = index
        self.previous_hash = previous_hash
        self.timestamp = timestamp
        self.transactions = transactions
        self.nonce = nonce
        self.hash = self.calculate_hash()

    def calculate_hash(self):
        block_string = f"{self.index}{self.previous_hash}{self.timestamp}{self.transactions}{self.nonce}"
        return hashlib.sha256(block_string.encode()).hexdigest()

class Blockchain:
    def __init__(self):
        self.chain = [self.create_genesis_block()]

    def create_genesis_block(self):
        return Block(0, "0", time.time(), "Genesis Block")

    def get_latest_block(self):
        return self.chain[-1]

    def add_block(self, new_block):
        new_block.previous_hash = self.get_latest_block().hash
        new_block.hash = new_block.calculate_hash()
        self.chain.append(new_block)

class ATMNode:
    def __init__(self, node_id, blockchain):
        self.node_id = node_id
        self.blockchain = blockchain

    def create_transaction(self, sender, recipient, amount):
        transaction = {
            'sender': sender,
            'recipient': recipient,
            'amount': amount,
            'timestamp': time.time()
        }
        return transaction

    def add_transaction_to_blockchain(self, transaction):
        new_block = Block(len(self.blockchain.chain), self.blockchain.get_latest_block().hash, time.time(), transaction)
        self.blockchain.add_block(new_block)
        print(f"Transaction added by node {self.node_id}: {transaction}")
        print(f"Transaction hash: {new_block.hash}\n")

def is_chain_valid(blockchain):
    for i in range(1, len(blockchain.chain)):
        current_block = blockchain.chain[i]
        previous_block = blockchain.chain[i - 1]

        if current_block.hash != current_block.calculate_hash():
            return False
        if current_block.previous_hash != previous_block.hash:
            return False
    return True

# Initialize the blockchain
blockchain = Blockchain()

# Create ATM nodes
atm1 = ATMNode("ATM1", blockchain)
atm2 = ATMNode("ATM2", blockchain)

# ATM1 creates a transaction
transaction1 = atm1.create_transaction("User1", "User2", 100)
atm1.add_transaction_to_blockchain(transaction1)

# ATM2 creates a transaction
transaction2 = atm2.create_transaction("User3", "User4", 50)
atm2.add_transaction_to_blockchain(transaction2)

# Print the blockchain
for block in blockchain.chain:
    print(f"Block {block.index} [Previous Hash: {block.previous_hash}]")
    print(f"Transactions: {block.transactions}")
    print(f"Hash: {block.hash}\n")

# Check if the blockchain is valid
print("Blockchain is valid:", is_chain_valid(blockchain))

