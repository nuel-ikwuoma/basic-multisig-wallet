// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "./Wallet.sol";

// Wallet factory for creating wallets
contract WalletFactory {
    Wallet walletAddress;
    
    mapping(uint => address) wallets;       // wallet ids to wallet address
    mapping(uint => address) walletOwned;   // wallet ids to wallet owners
    mapping(address => uint8) walletCount;  // owners to amount of wallet owned
    
    uint constant public MAX_LIMIT = 10;    // max num of wallet allowed for any address
    uint public nextWalletID;

    // CONTRACT EVENTS
    event WalletCreated(
        uint indexed _walletID,
        address indexed _walletOwner,
        address indexed _walletAddress
    );

    // creates a new wallet
    // returns the wallet address and the wallet ID
    function createWallet(
        address[] memory _signers,
        uint _confirmationsQuorum,
        string memory _purpose
    ) external payable maxLimit returns(address, uint) {
        require(_confirmationsQuorum <= _signers.length, "Cannot require more Quorum needed than avilable Signers");
        require(msg.value > 0, "Wallet should be pre-funded with some ETHER");
        address walletOwner = msg.sender;
        walletAddress = new Wallet(_signers, _confirmationsQuorum, _purpose);
        payable(address(walletAddress)).transfer(msg.value);
        wallets[nextWalletID] = address(walletAddress);
        walletOwned[nextWalletID] = walletOwner;
        walletCount[walletOwner]++;
        emit WalletCreated(nextWalletID, walletOwner, address(walletAddress));
        return (address(walletAddress), nextWalletID++);
    }
    
    // get the number of all wallet deployed so far
    function getWalletCount() external view returns(uint) {
        return nextWalletID;
    }
    
    // returns wallet address if owned by a specific wallet id
    function getWalletAddress(uint _id) external view walletExists(_id) returns(address) {
        return wallets[_id];
    }

    // returns the owner of a specific wallet
    function getWalletOwner(uint _id) external view walletExists(_id) returns(address) {
        return walletOwned[_id];
    }
    

    // CONTRACT MODIFIERS

    // restrict the amount of wallet a single address is allowed to create
    modifier maxLimit() {
        require(walletCount[msg.sender] <= MAX_LIMIT, "Max wallet limit exceeded");
        _;
    }

    modifier walletExists(uint _id) {
        require(_id < nextWalletID, "Wallet does not exist");
        _;
    }
    
    modifier isOwner(uint _id) {
        require(walletOwned[_id] == msg.sender, "You dont own this wallet");
        _;
    }
}
