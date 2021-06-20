// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;
contract Wallet {
    address[] public signers;
    uint public confirmationsQuorum;

    constructor(address[] memory _signers, uint _confirmationsQuorum) {
        signers = _signers;
        confirmationsQuorum = _confirmationsQuorum;
    }

    struct Transfer{
        uint id;
        uint amount;
        address payable to;
        uint numConfirmations;
        bool sent;
    }

    Transfer[] public allTransfers;
    uint nextID;

    // tracks transfers already confrmed by a given 'address'
    mapping(address => mapping(uint => bool)) isConfirmed;

    function createTransfer(uint _amount, address payable _to) external {
        // changed memory struct to storage
        Transfer memory newTransfer = Transfer({
            id: nextID,
            amount: _amount,
            to: _to,
            numConfirmations: 0,
            sent: false
        });
        allTransfers.push(newTransfer);
        nextID++;
    }

    function confirmTransfer(uint _id) external onlySigners() transferExists(_id) {
        require(!isConfirmed[msg.sender][_id], "You cant confirm a transfer twice");
        Transfer storage transfer = allTransfers[_id];
        // require that transfer is not already sent and that confirmation is still necessary
        require(!transfer.sent, "Transfer already sent");
        require(transfer.numConfirmations < confirmationsQuorum, "confirmation status complete");
        transfer.numConfirmations++;
        isConfirmed[msg.sender][_id] = true;
    }

    function sendTransfer(uint _id) external onlySigners() transferExists(_id) {
        Transfer storage transfer = allTransfers[_id];
        require(transfer.numConfirmations >= confirmationsQuorum, "incomplete confirmation count");
        require(!transfer.sent, "Transfer already sent");
        transfer.sent = true;
        address payable recepient = transfer.to;
        uint amount = transfer.amount;
        recepient.transfer(amount);
    }

    function getTransfers() external view returns(Transfer[] memory) {
        return allTransfers;
    }

    function getSigners() external view returns(address[] memory) {
        return signers;
    }

    // allow wallet to receive ether
    receive() external payable {}

    // allow only 'signers'
    modifier onlySigners() {
        bool alllow;
        for(uint i=0; i < signers.length; i++) {
            if(signers[i] == msg.sender){
                alllow = true;
                break;
            }
        }
        require(alllow, "Only signers allowed");
        _;
    }
    //
    modifier transferExists(uint _id) {
        require(_id < nextID, "Transfes does not exists");
        _;
    }
}