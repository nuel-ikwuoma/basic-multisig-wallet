// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "./Wallet.sol";

// Wallet factory for creating wallets
contract WalletFactory {
    Wallet walletAddress;
    
    mapping(uint => address) wallets;       // wallet ids to wallet address
    mapping(uint => address) walletOwned;   // wallet ids to wallet owners
    mapping(address => uint8) walletCount;  // owners to amount of wallet owned
    
    uint constant public MAX_LIMIT = 10;           // max num of wallet allowed for any address
    uint public nextWalletID;

    function createWallet(address[] memory _signers,
        uint _confirmationsQuorum
        ) external maxLimit returns(uint) {
            require(_confirmationsQuorum <= _signers.length, "More quorum needed than signers");
            address walletOwner = msg.sender;
            walletAddress = new Wallet(_signers, _confirmationsQuorum);
            wallets[nextWalletID] = address(walletAddress);
            walletOwned[nextWalletID] = walletOwner;
            walletCount[walletOwner]++;
            emit WalletCreated(walletOwner, address(walletAddress), nextWalletID);
            uint walletID = nextWalletID;
            nextWalletID++;
            return walletID;
    }
    
    // num of all wallet deployed so far
    function getWalletCount() external view returns(uint) {
        return nextWalletID;
    }
    
    // returns wallet address if owned by a specific wallet id
    function getWallet(uint _id) external view isOwner(_id) returns(address) {
        return wallets[_id];
    }
    

    // CONTRACT MODIFIERS
    modifier maxLimit() {
        require(walletCount[msg.sender] <= MAX_LIMIT, "Max wallet limit exceeded");
        _;
    }
    
    modifier isOwner(uint _id) {
        require(walletOwned[_id] == msg.sender, "You dont own this wallet");
        _;
    }
    
    // CONTRACT EVENTS
    event WalletCreated(
        address indexed _walletOwner,
        address indexed _walletAddress,
        uint _walletID
    );
}