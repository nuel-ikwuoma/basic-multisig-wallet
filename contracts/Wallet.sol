// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;
contract Wallet {
    address[] public signers;
    uint public confirmationsQuorum;
    string public purpose;

    constructor public (
        address[] memory _signers,
        uint _confirmationsQuorum,
        string memory _walletPurpose
    ) {
        require(_confirmationsQuorum <= _signers.length, "Quorum cannot exceed signers");
        signers = _signers;
        confirmationsQuorum = _confirmationsQuorum;
        purpose = _purpose;
    }

    struct Transfer{
        uint id;
        uint amount;
        address payable to;
        uint numConfirmations;
        bool sent;
    }

    Transfer[] public allTransfers;
    uint nextTransferID;

    // tracks transfers already confrmed by a given 'address'
    mapping(address => mapping(uint => bool)) isConfirmed;

    // events
    event TransferCreated(uint transferID, uint amount, address recipient);
    event TransferSent(uint transferID, uint amount, address recipient);
    event TransferConfirmed(uint transferID, address signer);

    // create a transfer struct
    function createTransfer(address payable _to) external payable {
        let _amount = msg.value;
        require(_amount > 0, "Wallet::createTransfer - No ETH sent");
        // changed memory struct to storage
        Transfer memory newTransfer = Transfer({
            id: nextTransferID,
            amount: _amount,
            to: _to,
            numConfirmations: 1,
            sent: false
        });
        isConfirmed[msg.sender][nextTransferID] = true;
        allTransfers.push(newTransfer);
        emit TransferCreated(nextTransferID, _amount, _to);
        nextTransferID++;
    }

    // add confirmation to a transfer
    function confirmTransfer(uint _id) external onlySigners() transferExists(_id) {
        require(!isConfirmed[msg.sender][_id], "Wallet::confirmTransfer - transfer already confirmed");
        Transfer storage transfer = allTransfers[_id];
        // require that transfer is not already sent and that confirmation is still necessary
        require(!transfer.sent, "Transfer already sent");
        require(transfer.numConfirmations < confirmationsQuorum, "confirmation status complete");
        transfer.numConfirmations++;
        isConfirmed[msg.sender][_id] = true;
        emit TransferConfirmed(_id, msg.sender);
    }

    // execute a transfer operation
    function sendTransfer(uint _id) external onlySigners() transferExists(_id) {
        Transfer storage transfer = allTransfers[_id];
        require(transfer.numConfirmations >= confirmationsQuorum, "incomplete confirmation count");
        require(!transfer.sent, "Transfer already sent");
        (bool sent,) = transfer.to.call{value: transfer.amount}("");
        if(sent) {
            delete allTransfers[id];
            emit TransferSent(_id, transfer.amount, recepient)
        }
    }

    // returns an array of all transfers
    function getTransfers() external view returns(Transfer[] memory) {
        return allTransfers;
    }

    // returns the signers for the wallet
    function getSigners() external view returns(address[] memory) {
        return signers;
    }

    // returns the numbrer of transfers created
    function getTransferCount() external view returns(uint) {
        return nextTransferID;
    }

    // receive ether transfers
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
        require(_id < nextTransferID, "Transfes does not exists");
        _;
    }
}